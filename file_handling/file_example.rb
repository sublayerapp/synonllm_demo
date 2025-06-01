require_relative "file_handler"

f = FileHandler.new

f.get_file_at("./11th-estate-intro.md")

puts f.read "./11th-estate-intro.md", 4


