API_KEY = 'stsRvxw3RbM6zaI1qXwknZQQ30xQ9QtEFKZedcusTC2y5nx7'
API_URL = 'http://localhost:3000'

while true
  api_response = `curl #{API_URL}/gauntlet?api_key=#{API_KEY}`
  json_data = JSON.parse api_response 
  unless File.exists? nn_to_test
    `curl #{API_URL}/nn?api_key=#{API_KEY}&name=#{nn_to_test}`
  end
  `./duel_vs_master.sh`
end
