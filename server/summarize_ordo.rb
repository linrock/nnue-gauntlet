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

nnue_in_gauntlet = `ls -1 nn/nn-*.nnue | xargs -n1 basename`.strip.split(/\n/)
nnue_in_gauntlet.each do |nnue_name|
  puts "ordo: #{nnue_name}"
  ordo_output = `./ordo_calc.sh #{nnue_name}`
  pp parse_ordo_results(nnue_name, ordo_output)
  puts
end
