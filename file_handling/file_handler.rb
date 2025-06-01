require_relative "../synonllm"

class FileHandler
  include Synonllm

  def open_the_file_at_the_given_path_and_return_a_file_object(filepath)
    puts "Opening file at path: #{filepath}"
    File.open(filepath)
  end

  def read_the_contents_of_the_file_at_a_given_path_and_return_the_contents_of_the_file(filepath)
    puts "Reading contents of file at path: #{filepath}"
    File.read(filepath)
  end

  def read_the_contents_of_the_file_at_a_given_path_and_return_the_given_number_of_lines(filepath, number_of_lines)
    puts "Reading first #{number_of_lines} lines of file at path: #{filepath}"
    File.readlines(filepath).take(number_of_lines)
  end
end
