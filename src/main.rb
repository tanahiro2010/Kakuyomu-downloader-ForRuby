require 'net/http'
require 'nokogiri'
require 'json'
require_relative './kakuyomu'

# Read user agents from JSON file
user_agents = JSON.parse(File.read('./userAgents.json'))

# Handle command line arguments
if ARGV.empty?
  print "Enter Kakuyomu book id: "
  book_id = gets.chomp
else
  mode = ARGV[0]
  if mode == "install"
    book_id = ARGV[1]
  else
    puts "Invalid mode argument. Usage: kakuyomu install [book_id]"
    exit
  end
end

puts "Book ID: #{book_id}"

# Initialize Kakuyomu App instance
kakuyomu_app = Kakuyomu::App.new(book_id: book_id)

# Download episodes using user agents
kakuyomu_app.download(user_agents=user_agents)