require 'json'

API_KEY = 'stsRvxw3RbM6zaI1qXwknZQQ30xQ9QtEFKZedcusTC2y5nx7'
API_URL = "http://#{ENV['GAUNTLET_SERVER_IP']}:6055"

def get_match_data
  begin
    api_response = `curl -sL #{API_URL}/match?api_key=#{API_KEY}`
    match_data = JSON.parse api_response
    nn_to_duel, tc = match_data["name"], match_data["tc"]
  rescue
    puts "Failed to get match data from server #{API_URL}"
    sleep 60
    nil
  end
end

def upload_match_pgn(nn_to_duel, filename)
  10.times do
    begin
      api_response = `curl -F file=@#{filename} -F name=#{nn_to_duel} "#{API_URL}/pgns?api_key=#{API_KEY}"`
      if api_response["success"]
        puts "Successfully uploaded #{filename}"
        `rm #{filename}`
        break
      end
    rescue
      puts "Failed to upload #{filename} to server #{API_URL}"
      sleep 60
    end
  end
end

(`nproc`.to_i / 16).times do
  fork do
    while true
      nn_to_duel, tc = get_match_data
      next unless nn_to_duel and tc
      unless File.exists? nn_to_duel
        `wget "#{API_URL}/nn?api_key=#{API_KEY}&name=#{nn_to_duel}" -O #{nn_to_duel}`
        puts `sha256sum #{nn_to_duel}`
      end
      puts "Duel: master vs #{nn_to_duel} @ #{tc}"
      nonce = "#{Time.now.to_i}-#{(10000 + rand*10000).to_i}"
      filename = "master-vs-#{nn_to_duel}-#{tc}-#{nonce}.pgn"
      puts `./duel_vs_master.sh #{nn_to_duel} #{tc} #{filename}`
      upload_match_pgn nn_to_duel, filename
      sleep 3
    end
  end
end
Process.waitall
