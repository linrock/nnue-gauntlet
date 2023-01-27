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
    gauntlet_results << [
      nnue_name,
      "#{results.dig("25k nodes", :rating)} +/- #{results.dig("25k nodes", :error)}",
      "#{results.dig("STC 10+0.1", :rating)} +/- #{results.dig("STC 10+0.1", :error)}",
      "#{results.dig("LTC 60+0.6", :rating)} +/- #{results.dig("LTC 60+0.6", :error)}",
    ]
  end
end

table = Terminal::Table.new(
  headings: ['nnue', '25k nodes', 'STC 10+0.1', 'LTC 60+0.6'], rows: gauntlet_results
)
table.align_column 1, :right
table.align_column 2, :right
table.align_column 3, :right
puts table
