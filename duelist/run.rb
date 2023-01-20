require 'json'

API_KEY = 'stsRvxw3RbM6zaI1qXwknZQQ30xQ9QtEFKZedcusTC2y5nx7'
API_URL = 'http://127.0.0.1:6055'

while true
  api_response = `curl -sL #{API_URL}/match?api_key=#{API_KEY}`
  match_data = JSON.parse api_response
  nn_to_duel = match_data["name"]
  tc = match_data["tc"]
  unless File.exists? nn_to_duel
    `wget "#{API_URL}/nn?api_key=#{API_KEY}&name=#{nn_to_duel}" -O #{nn_to_duel}`
  end
  puts "Duel: master vs #{nn_to_duel} @ #{tc}"
  nonce = "#{Time.now.to_i}-#{(10000 + rand*10000).to_i}"
  filename = "master-vs-#{nn_to_duel}-#{tc}-#{nonce}.pgn"
  puts `./duel_vs_master.sh #{nn_to_duel} #{tc} #{filename}`
  api_response = `curl -F file=@#{filename} "#{API_URL}/pgns?api_key=#{API_KEY}"`
  if api_response["success"]
    puts "Successfully uploaded #{filename}"
    `rm #{filename}`
  end
  sleep 3
end
