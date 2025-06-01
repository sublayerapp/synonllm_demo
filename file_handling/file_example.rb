require_relative "file_handler"

f = FileHandler.new

f.get_file_at(File.join(__dir__, "11th-estate-intro.md"))

puts f.read File.join(__dir__, "11th-estate-intro.md"), 4


