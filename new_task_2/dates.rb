print 'Введите день месяца: '
day = gets.chomp.to_i
print 'Bведите месяц от 1 до 12: '
month = gets.chomp.to_i
print 'Введите год: '
year = gets.chomp.to_i

def leap_year(year)
  if year % 4 == 0 && year % 100 != 0 then 29    
  elsif year % 400 == 0 then 29   
  else 28     
  end
end
 
month_day = [31, leap_year(year), 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
namber_day = month_day.first(month - 1).sum 
puts namber_day + day  
