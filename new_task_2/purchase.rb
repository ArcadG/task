basket = {}
loop do
  print 'Введите название товара,чтобы закончить введите стоп: '
  name = gets.chomp
  break if name == 'стоп'
  print 'Введите кол-во: '
  quantity = gets.chomp.to_f
  print 'Введите цену за ед.: '
  cost = gets.chomp.to_f
  
  basket[name] = { 'quantity' => quantity, 'cost' => cost }
end
puts basket

grand_total = 0
basket.each do |name, value|
  total = value['quantity'] * value['cost']
  grand_total += total
  puts "#{name}, стоимость: #{total}"
  puts "Итого #{grand_total}"
end
puts "Итого #{grand_total}"
