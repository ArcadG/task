print "Введите стороны треугольника a,b,c:" ""
#"Значения вводятся через запятую"
sides = gets.chomp.split(",").map(&:to_f)
a, b, c = sides.sort
print a.inspect
if a == b && a ** 2 + b ** 2 == c ** 2
  print "Треугольник является равнобедренным, прямоугольным"
elsif 
  a ** 2 + b ** 2 == c ** 2
  print "Треугольник является прямоугольным"    
elsif
  a == b && b == c
  print "Треугольник является равносторонним, но не является прямоугольным"
else
  print "Треугольник не является прямоугольным"
end