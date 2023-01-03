require 'tty-table'
require 'uri'
require 'net/http'
require 'openssl'
require 'pry'
require 'json'
require 'pastel'
require 'time'

pastel = Pastel.new
puts pastel.on_red("Welcome to PGA Data App")
puts pastel.red("Overview")
puts pastel.green("1 World Rankings")
puts pastel.green("2 Schedules of each year")
puts pastel.green("3 Check players on the PGA tour")
puts pastel.green("4 Live Tournament & Leaderboard")

puts pastel.red("Please type the number of options")
user_menu = gets.chomp
### MENU 1
if user_menu == "1"

  url = URI("https://live-golf-data.p.rapidapi.com/stats?year=2022&statId=186")

  http = Net::HTTP.new(url.host, url.port)
  http.use_ssl = true
  http.verify_mode = OpenSSL::SSL::VERIFY_NONE

  request = Net::HTTP::Get.new(url)
  request = Net::HTTP::Get.new(url)
  request["X-RapidAPI-Key"] = '24a30ed321msh6d75f0cef15cde9p1ad4bajsn8f68a7d2e16d'
  request["X-RapidAPI-Host"] = 'live-golf-data.p.rapidapi.com'
  response = http.request(request)
  #  binding.pry
  index = 1
  JSON.parse(response.read_body)["rankings"].each do |rank|
    puts pastel.red("#{index}") +" #{rank["firstName"]} "+ "#{rank["lastName"]}"
    puts  "Previous rank: #{rank["previousRank"]["$numberInt"]}"
    index+=1
  end
### MENU 2
elsif user_menu == "2"
  puts pastel.on_red("Enter a year")
  year = gets.chomp 
  if (2021..2023).member?(year.to_i)

    url = URI("https://live-golf-data.p.rapidapi.com/schedule?orgId=1&year=#{year}")

    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    request = Net::HTTP::Get.new(url)
    request = Net::HTTP::Get.new(url)
    request["X-RapidAPI-Key"] = '24a30ed321msh6d75f0cef15cde9p1ad4bajsn8f68a7d2e16d'
    request["X-RapidAPI-Host"] = 'live-golf-data.p.rapidapi.com'

    response = http.request(request)

    JSON.parse(response.read_body)["schedule"].each do |sh|
      time = Time.at(sh["date"]["start"]["$date"]["$numberLong"].to_i/1000)
      puts pastel.green("#{sh["name"]} Tournament Id: #{sh["tournId"]}")
      puts "Date: #{time.strftime("%m-%d-%Y")} Course: #{sh["courses"][0]["courseName"]}"
    end
  else
    puts "Invalid year"
  end
### MENU 3
elsif user_menu == "3"
  puts "Type first name"
  first = gets.chomp.capitalize
  puts "Type last name"
  last = gets.chomp.capitalize
 
  if first != nil && last == ""
    url = URI("https://live-golf-data.p.rapidapi.com/players?firstName=#{first}")

    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    request = Net::HTTP::Get.new(url)
    request = Net::HTTP::Get.new(url)
    request["X-RapidAPI-Key"] = '24a30ed321msh6d75f0cef15cde9p1ad4bajsn8f68a7d2e16d'
    request["X-RapidAPI-Host"] = 'live-golf-data.p.rapidapi.com'

    response = http.request(request)
    JSON.parse(response.read_body).each do |player|
      puts "#{player["firstName"]} #{player["lastName"]} #{player["playerId"]}"
      # puts "#{player[0]["firstName"].capitalize} #{player[0]["lastName"].capitalize}"
      # puts "Player's Id: #{player[0]["playerId"]}"
    end
  elsif last != nil && first == ""
    url = URI("https://live-golf-data.p.rapidapi.com/players?lastName=#{last}")

    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    request = Net::HTTP::Get.new(url)
    request = Net::HTTP::Get.new(url)
    request["X-RapidAPI-Key"] = '24a30ed321msh6d75f0cef15cde9p1ad4bajsn8f68a7d2e16d'
    request["X-RapidAPI-Host"] = 'live-golf-data.p.rapidapi.com'

    response = http.request(request)
    JSON.parse(response.read_body).each do |player|
      puts "#{player["firstName"]} #{player["lastName"]} #{player["playerId"]}"
      # puts "#{player[0]["firstName"].capitalize} #{player[0]["lastName"].capitalize}"
      # puts "Player's Id: #{player[0]["playerId"]}"
    end
  elsif last != nil && first != nil
    url = URI("https://live-golf-data.p.rapidapi.com/players?firstName=#{first}&lastName=#{last}")

    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    request = Net::HTTP::Get.new(url)
    request = Net::HTTP::Get.new(url)
    request["X-RapidAPI-Key"] = '24a30ed321msh6d75f0cef15cde9p1ad4bajsn8f68a7d2e16d'
    request["X-RapidAPI-Host"] = 'live-golf-data.p.rapidapi.com'

    response = http.request(request)
    JSON.parse(response.read_body).each do |player|
      puts "#{player["firstName"]} #{player["lastName"]} #{player["playerId"]}"
    end
  else
    puts "Invalid name"
  end
### MENU 4
elsif user_menu == "4"
  ### getting current week's tournament id from schedule
  current_year = Time.new.year.to_i
  url = URI("https://live-golf-data.p.rapidapi.com/schedule?orgId=1&year=#{current_year}")

  http = Net::HTTP.new(url.host, url.port)
  http.use_ssl = true
  http.verify_mode = OpenSSL::SSL::VERIFY_NONE
  
  request = Net::HTTP::Get.new(url)
  request = Net::HTTP::Get.new(url)
  request["X-RapidAPI-Key"] = '24a30ed321msh6d75f0cef15cde9p1ad4bajsn8f68a7d2e16d'
  request["X-RapidAPI-Host"] = 'live-golf-data.p.rapidapi.com'
  
  response = http.request(request)

  tourn_id = ""
  JSON.parse(response.read_body)["schedule"].each do |sh|
    # time = Time.at(sh["date"]["start"]["$date"]["$numberLong"].to_i/1000)
    if Date.today.strftime("%U").to_i == sh["date"]["weekNumber"].to_i
      tourn_id = sh["tournId"]
    end
    # puts "Date: #{time.strftime("%m-%d-%Y")} Course: #{sh["courses"][0]["courseName"]}"
  end
  ### getting tournament info from tournaments

  url = URI("https://live-golf-data.p.rapidapi.com/tournament?orgId=1&tournId=#{tourn_id}&year=#{current_year.to_s}")

  http = Net::HTTP.new(url.host, url.port)
  http.use_ssl = true
  http.verify_mode = OpenSSL::SSL::VERIFY_NONE

  request = Net::HTTP::Get.new(url)
  request = Net::HTTP::Get.new(url)
  request["X-RapidAPI-Key"] = '24a30ed321msh6d75f0cef15cde9p1ad4bajsn8f68a7d2e16d'
  request["X-RapidAPI-Host"] = 'live-golf-data.p.rapidapi.com'

  response = http.request(request)
  puts pastel.on_red("This week: #{Time.now.strftime("%d/%m/%Y")}")
  puts pastel.green("#{JSON.parse(response.read_body)["name"]}")
  # JSON.parse(response.read_body)["players"]
  

  ### getting current leader board
  if Date.today.monday? || Date.today.tuesday? || Date.today.wednesday?
    puts pastel.on_red("Tournament starts on Thursday")
    puts pastel.red("Players for the tournament")
    url = URI("https://live-golf-data.p.rapidapi.com/tournament?orgId=1&tournId=#{tourn_id}&year=#{current_year.to_s}")

    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
  
    request = Net::HTTP::Get.new(url)
    request = Net::HTTP::Get.new(url)
    request["X-RapidAPI-Key"] = '24a30ed321msh6d75f0cef15cde9p1ad4bajsn8f68a7d2e16d'
    request["X-RapidAPI-Host"] = 'live-golf-data.p.rapidapi.com'

    response = http.request(request)
    JSON.parse(response.read_body)["players"].each do |ld|
      puts "#{ld["firstName"]} " "#{ld["lastName"]} "               

    end
  else
    url = URI("https://live-golf-data.p.rapidapi.com/leaderboard?orgId=1&tournId=#{tourn_id}&year=#{current_year.to_s}")
    
    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    request = Net::HTTP::Get.new(url)
    request = Net::HTTP::Get.new(url)
    request["X-RapidAPI-Key"] = '24a30ed321msh6d75f0cef15cde9p1ad4bajsn8f68a7d2e16d'
    request["X-RapidAPI-Host"] = 'live-golf-data.p.rapidapi.com'

    response = http.request(request)
    JSON.parse(response.read_body)["leaderboardRows"].each do |ld|
      puts "#{ld["position"]}  "  " #{ld["firstName"]} " "#{ld["lastName"]} "               
      puts "Total: #{ld["total"]} "
    end
  end
else
  puts "Please type valid option"
end




