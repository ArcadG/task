require_relative 'train'
require_relative 'station'
require_relative 'route'

station_1 = Station.new('start')
station_2 = Station.new('end')

route = Route.new(station_1, station_2)

train = Train.new(123, 'g', 7)

puts '= ' * 50
train.route_train(route)
puts station_1.train_list('g').inspect
puts station_2.train_list('g').inspect

puts '- ' * 50
train.train_next
puts station_1.train_list('g').inspect
puts station_2.train_list('g').inspect

