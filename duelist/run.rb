require 'json'

API_KEY = 'stsRvxw3RbM6zaI1qXwknZQQ30xQ9QtEFKZedcusTC2y5nx7'
API_URL = 'http://127.0.0.1:6055'

while true
  api_response = `curl -sL #{API_URL}/match?api_key=#{API_KEY}`
  match_data = JSON.parse api_response
  nn_to_duel = match_data["name"]
  unless File.exists? nn_to_duel
    `wget "#{API_URL}/nn?api_key=#{API_KEY}&name=#{nn_to_duel}" -O #{nn_to_duel}`
  end
  puts "Duel: #{nn_to_duel}"
  puts `./duel_vs_master.sh #{nn_to_duel} #{match_data["tc"]}`
  puts "sleeping..."
  sleep 2
end
