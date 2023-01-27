require 'colorize'
require 'terminal-table'

N_25K = '25k nodes'
STC = 'STC 10+0.1'
LTC = 'LTC 60 + 0.6'

def parse_ordo_results(nnue_name, ordo_output)
  rankings = {}
  tc = nil
  ordo_output.split(/\n/).each do |row|
    if row =~ /25k nodes/
      tc = N_25K
    elsif row =~ /STC 10\+0\.1/
      tc = STC
    elsif row =~ /LTC 60\+0\.6/
      tc = LTC
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
    vstc_rating = results.dig(N_25K, :rating)
    vstc_rating = !vstc_rating.nil? && vstc_rating > 0 ? vstc_rating.to_s.green : vstc_rating
    stc_rating = results.dig(STC, :rating)
    stc_rating = !stc_rating.nil? && stc_rating > 0 ? stc_rating.to_s.green : stc_rating
    ltc_rating = results.dig(LTC, :rating)
    ltc_rating = !ltc_rating.nil? && ltc_rating > 0 ? ltc_rating.to_s.green : ltc_rating
    gauntlet_results << [
      nnue_name,
      "#{vstc_rating} +/- #{results.dig(N_25K, :error)}",
      results.dig(N_25K, :played),
      "#{stc_rating} +/- #{results.dig(STC, :error)}",
      results.dig(STC, :played),
      "#{ltc_rating} +/- #{results.dig(LTC, :error)}",
      results.dig(LTC, :played),
    ]
  end
end

table = Terminal::Table.new(
  headings: ['nnue', N_25K, '', STC, '', LTC],
  rows: gauntlet_results
)
(1..6).each {|i| table.align_column i, :right }
puts table
