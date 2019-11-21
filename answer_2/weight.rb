print "Введите Ваше имя " ""
name = gets.chomp.capitalize
print "#{name} введите Ваш рост " ""
height = gets.chomp.to_i
weight = height - 110
print "#{name} Ваш идеальный вес #{weight} кг"