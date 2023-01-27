require 'terminal-table'

def parse_ordo_results(nnue_name, ordo_output)
  rankings = {}
  tc = nil
  ordo_output.split(/\n/).each do |row|
    if row =~ /25k nodes/
      tc = '25k nodes'
    elsif row =~ /STC 10\+0\.1/
      tc = 'STC 10+0.1'
    elsif row =~ /LTC 60\+0\.6/
      tc = 'LTC 60+0.6'
    elsif row.include? nnue_name
      rating, error, points, played = row.split(/\s+/)[4, 4].map(&:to_f)
      rankings[tc] = { rating: rating, error: error, points: points, played: played }
    end
  end
  rankings
end

gauntlet_results = []
nnue_in_gauntlet = `ls -1 nn/nn-*.nnue | xargs -n1 basename`.strip.split(/\n/)
nnue_in_gauntlet.each do |nnue_name|
  puts "ordo: #{nnue_name}"
  ordo_output = `./ordo_calc.sh #{nnue_name}`
  results = parse_ordo_results(nnue_name, ordo_output)
  if results
    vstc_rating = results.dig("25k nodes", :rating)
    vstc_rating = !vstc_rating.nil? && vstc_rating > 0 ? vstc_rating.to_s.green : vstc_rating
    stc_rating = results.dig("STC 10+0.1", :rating)
    stc_rating = !stc_rating.nil? && stc_rating > 0 ? stc_rating.to_s.green : stc_rating
    ltc_rating = results.dig("LTC 60+0.6", :rating)
    ltc_rating = !ltc_rating.nil? && ltc_rating > 0 ? ltc_rating.to_s.green : ltc_rating
    gauntlet_results << [
      nnue_name,
      "#{vstc_rating} +/- #{results.dig("25k nodes", :error)}",
      results.dig("25k nodes", :played),
      "#{stc_rating} +/- #{results.dig("STC 10+0.1", :error)}",
      results.dig("STC 10+0.1", :played),
      "#{ltc_rating} +/- #{results.dig("LTC 60+0.6", :error)}",
      results.dig("LTC 60+0.6", :played),
    ]
  end
end

table = Terminal::Table.new(
  headings: ['nnue', '25k nodes', '', 'STC 10+0.1', '', 'LTC 60+0.6'], rows: gauntlet_results
)
(1..6).each {|i| table.align_column i, :right }
puts table
