date = Date.new(1995, 12, 21)

day_of_week_name = %w[
Sunday Monday Tuesday Wednesday Thursday Friday Saturday
][ date.day_of_week ]

puts "The day of the week for #{date} is #{day_of_week_name}"
