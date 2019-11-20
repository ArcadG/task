print "ax^+bx+c=0 Введите данные a,b,c:" ""
#"Значения вводятся через запятую"
value = gets.chomp.split(",")
a, b, c = value
a = a.to_f 
b = b.to_f
c = c.to_f

d = b ** 2 - 4 * a * c

if d < 0
  print "Корней нет"
elsif d > 0
  x1 = (-b + Math.sqrt(d)) / (2 * a)
  x2 = (-b - Math.sqrt(d)) / (2 * a)
  print "Корни x1=#{x1} x2=#{x2}"    
else d = 0
  x = -b / (2 * a)
  print "Корень один x=#{x}" 
end

