print 'ax^+bx+c=0 Введите данные a,b,c:" "'
#"Значения вводятся через запятую"
value = gets.chomp.split(",").map(&:to_f)
a, b, c = value

d = b**2 - 4 * a * c

if d < 0
  print 'Корней нет'
elsif d > 0
  root_d = Math.sqrt(d)
  x1 = (-b + root_d)/(2 * a)
  x2 = (-b - root_d)/(2 * a)
  print "Корни x1 = #{x1} x2 = #{x2}"    
else d = 0
  x = -b/(2 * a)
  print "Корень один x = #{x}" 
end

