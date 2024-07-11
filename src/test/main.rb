require 'net/http'
require 'Nokogiri'
require 'json'
require './kakuyomu'

userAgents_str = ""

File.open(path="./userAgents.json", "r") do |file|
  file.each do |line|
    userAgents_str += line
  end
end
userAgents = JSON.parse(userAgents_str)

if ARGV.length == 0
  print "Kakuyomu book id $"
  book_id = gets.chomp
else
  mode = ARGV[0]
  if mode == "install"
    book_id = ARGV[1]
  end
end

puts book_id

Kakuyomu_app = Kakuyomu::App.new book_id:book_id

Kakuyomu_app.download userAgents=userAgents