require 'json'

API_KEY = 'stsRvxw3RbM6zaI1qXwknZQQ30xQ9QtEFKZedcusTC2y5nx7'
API_URL = "http://#{ENV['GAUNTLET_SERVER_IP']}:6055"
CONCURRENCY = (`nproc`.to_i / 16)

def get_match_data
  nn_to_duel, tc = begin
    api_response = `curl -sL #{API_URL}/match?api_key=#{API_KEY}`
    match_data = JSON.parse api_response
    [match_data["name"], match_data["tc"]]
  rescue
    puts "Failed to get match data from server #{API_URL}"
    sleep 60
    return nil
  end
  unless File.exists? nn_to_duel
    begin
      `wget "#{API_URL}/nn?api_key=#{API_KEY}&name=#{nn_to_duel}" -O #{nn_to_duel}`
      puts `sha256sum #{nn_to_duel}`
    rescue
      puts "Failed to download #{nn_to_duel} from server #{API_URL}"
      sleep 60
      return nil
    end
  end
  [nn_to_duel, tc]
end

def upload_match_pgn(nn_to_duel, pgn_filename)
  10.times do
    begin
      api_response = `curl -F pgn=@#{pgn_filename} "#{API_URL}/pgns?api_key=#{API_KEY}&nn_name=#{nn_to_duel}"`
      if api_response["success"]
        puts "Successfully uploaded #{pgn_filename}"
        `rm #{pgn_filename}`
        break
      end
    rescue
      puts "Failed to upload #{pgn_filename} to server #{API_URL}"
      sleep 60
    end
  end
end

CONCURRENCY.times do
  fork do
    while true
      nn_to_duel, tc = get_match_data
      next unless nn_to_duel and tc
      nonce = "#{Time.now.to_i}-#{(10000 + rand*80000).to_i}"
      pgn_filename = "master-vs-#{nn_to_duel}-#{tc}-#{nonce}.pgn"
      system("./duel_vs_master.sh #{nn_to_duel} #{tc} #{pgn_filename}", out: STDOUT)
      upload_match_pgn nn_to_duel, pgn_filename
      sleep 3
    end
  end
end
Process.waitall
