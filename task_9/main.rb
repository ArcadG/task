# frozen_string_literal: true

require_relative 'accessors.rb'
require_relative 'constants.rb'
require_relative 'valid.rb'
require_relative 'manufacturer.rb'
require_relative 'instance_counter.rb'
require_relative 'station.rb'
require_relative 'train.rb'
require_relative 'route.rb'
require_relative 'wagon.rb'
require_relative 'cargo_train.rb'
require_relative 'passenger_train.rb'
require_relative 'passenger_wagon.rb'
require_relative 'cargo_wagon.rb'

class Main
  include Accessors
  include Constants
  attr_reader :route, :train, :wagon

  def initialize
    @stations = []
    @trains = []
    @wagons = []
    @routes = []
  end

  def main_menu
    MAIN_MENU_ITEMS.each { |item| puts(item) }
    input = gets.chomp.to_i
    menu = { 1 => :station_menu, 2 => :train_menu, 3 => :wagon_menu,
             4 => :route_menu, 5 => :work_menu, 6 => :load_menu,
             7 => :information_menu, 8 => :exit }
    send(menu[input] || main_menu)
  end

  def return_wagon(wagon)
    @wagons << wagon
    work_menu
  end

  private

  def station_menu
    print 'Название станции:>> '
    station = gets.chomp
    @stations << Station.new(station)
    puts "Станция #{station} создана"
    main_menu
  rescue Station::ValidationError => e
    puts " #{e.message} Попробуй еще раз"
    main_menu
  end

  def train_menu
    TRAIN_MENU_ITEMS.each { |item| puts(item) }
    input = gets.chomp.to_i
    menu = { 1 => :make_passenger_train, 2 => :make_cargo_train, 3 => :main_menu }
    send(menu[input] || train_menu)
  rescue Train::ValidationError => e
    puts " #{e.message} Попробуйте еще раз"
    train_menu
  end

  def wagon_menu
    WAGON_MENU_ITEMS.each { |item| puts(item) }
    input = gets.chomp.to_i
    menu = { 1 => :make_passenger_wagon, 2 => :make_cargo_wagon, 3 => :main_menu }
    send(menu[input] || wagon_menu)
  rescue Wagon::ValidationError => e
    puts " #{e.message} Попробуйте еще раз"
    wagon_menu
  end

  def route_menu
    ROUTE_MENU_ITEMS.each { |item| puts(item) }
    input = gets.chomp.to_i
    menu = { 1 => :station_start, 2 => :add_intermediate_station,
             3 => :del_intermediate_station, 4 => :main_menu }
    send(menu[input] || route_menu)
  end

  def station_start_stop
    print 'Введите название маршрута:>>'
    name = gets.chomp
    print 'Название начальной станции: >>'
    input = gets.chomp
    if @stations.select { |station| station.name == input }.empty?
      puts 'Такой станции нет'
      route_menu
    else
      start = @stations.select { |station| station.name == input }
      start = start.first
      station_stop
    end

    def station_stop
      print 'Название конечной станции: >>'
      input = gets.chomp
      if @stations.select { |station| station.name == input }.empty?
        puts 'Такой станции нет'
        route_menu
      else
        stop = @stations.select { |station| station.name == input }
        stop = stop.first
      end
    end

    @routes << Route.new(name, start, stop)
    puts "Маршрут #{name} создан"
    route_menu
  rescue Route::ValidationError => e
    puts " #{e.message} Попробуйте еще раз"
    route_menu
  end

  def add_intermediate_station
    route_selection
    intermediate
    route.add_station(@intermediate_station)
    puts "Промежуточная станция #{@intermediate_station} добавлена"
    route_menu
  end

  def del_intermediate_station
    intermediate
    route.del_station(@intermediate_station)
    puts "Промежуточная станция #{@intermediate_station} удалена"
    route_menu
  end

  def work_menu
    WORK_MENU_ITEMS.each { |item| puts(item) }
    input = gets.chomp.to_i
    menu = { 1 => :train_route, 2 => :add_wagon, 3 => :del_wagon,
             4 => :forward_movement, 5 => :backward_movement,
             6 => :main_menu }
    send(menu[input] || work_menu)
  end

  def train_route
    selection_train
    route_selection
    train.route_train(route)
    main_menu
  end

  def add_wagon
    selection_train
    selection_wagon
    train.to_attach(wagon)
    @wagons.delete(wagon)
    work_menu
  end

  def del_wagon
    selection_train
    if train.speed != 0 || train.wagons.empty?
      puts 'Поезд движется, или не прицеплены вагоны.'
    else
      train.unhook(self)
    end
  end

  def forward_movement
    selection_train
    train.train_next(self)
    work_menu
  end

  def backward_movement
    selection_train
    train.train_bask(self)
    work_menu
  end

  def information_menu
    INFORMATION_MENU_ITEMS.each { |item| puts(item) }
    input = gets.chomp.to_i
    menu = { 1 => :station_list, 2 => :station_train_list, 3 => :route_list,
             4 => :list_all, 5 => :main_menu }
    send(menu[input] || information_menu)
  end

  def route_list
    puts @routes.map(&:name)
    information_menu
  end

  def station_list
    puts @stations.map(&:name)
    information_menu
  end

  def list_all
    @stations.each do |station|
      puts station.show[:info]
      if station.trains.empty?
        puts 'Нет поездов'
      else
        station.train_list_show do |train|
          puts train.show[:name]
          puts train.show[:wagon_size]
          if train.wagons.empty?
            puts 'Нет вагонов'
          else
            train.wagon_list_show do |wagon|
              puts "----Вагон № #{train.wagons.index(wagon).next}"
              puts wagon.show[:wagon_type]
              if train.type == 'passenger'
                puts wagon.show[:total_seats]
                puts wagon.show[:occupied_seats]
              else
                puts wagon.show[:total_volume]
                puts wagon.show[:occupied_volume]
              end
              puts '-----------------------------------------------------------'
            end
          end
        end
      end
    end
    information_menu
  end

  def station_train_list
    print 'Введите название станции:>>'
    input = gets.chomp
    if @stations.select { |station| station.name == input }.empty?
      puts 'Такой станции нет'
      information_menu
    else
      station = @stations.select { |station| station.name == input }
      station = station.first
      if station.train_list(self).nil?
        puts 'На станции нет поездов'
      else
        puts station.train_list(self)
      end
      information_menu
    end
  end

  def load_menu
    LOAD_MENU_ITEMS.each { |item| puts(item) }
    input = gets.chomp.to_i
    menu = { 1 => :put_the_passenger, 2 => :load_wagon, 3 => :main_menu }
    send(menu[input] || load_menu)
  end

  def put_the_passenger
    selection_train
    if train.type == 'passenger'
      selection_wagon_load
    else
      puts 'Поезд не является пассажирским'
      load_menu
    end
    if wagon.passenger_loading.nil?
      puts 'Свободных мест нет'
    else
      puts 'Посадка пассажира'
      puts "Занято мест #{wagon.busy_seats}"
      puts "Свободно мест #{wagon.free_seat}"
    end
    load_menu
  end

  def load_wagon
    selection_train
    if train.type == 'cargo'
      selection_wagon_load
    else
      puts 'Поезд не является грузовым'
    end
    print 'Введите объем груза>>'
    volume = gets.chomp.to_i
    wagon.wagon_loading(volume)
    if wagon.wagon_loading(volume).nil?
      puts 'Нет места'
    else
      puts 'Груз загружен'
      puts "Занятый объем #{wagon.volume_occupied}"
      puts "Свободный объем #{wagon.available_volume}"
    end
    load_menu
  end

  # для сздания пассажирских поездов
  def make_passenger_train
    print 'Введите номер поезда:>>'
    input = gets.chomp
    @trains << PassengerTrain.new(input)
    puts "Пассажирский поезд № #{input} создан"
    main_menu
  end

  # для создания грузовых поездов
  def make_cargo_train
    print 'Введите номер поезда:>>'
    input = gets.chomp
    @trains << CargoTrain.new(input)
    puts "Грузовой поезд № #{input} создан"
    main_menu
  end

  # для создания пассажирских вагонов
  def make_passenger_wagon
    print 'Введите количество мест >>'
    input = gets.chomp.to_i
    @wagons << PassengerWagon.new(read_manufacturer, input)
    puts 'Пассажирский вагон создан'
    wagon_menu
  end

  # для создания грузовых вагонов
  def make_cargo_wagon
    print 'Введите объем >>'
    input = gets.chomp.to_i
    @wagons << CargoWagon.new(read_manufacturer, input)
    puts 'Грузовой вагон создан'
    wagon_menu
  end

  # вспомогательная функция выбора вагона для загрузки
  def selection_wagon_load
    print 'Введите номер вагона:>>'
    input = gets.chomp.to_i
    if input <= train.wagons.size
      @wagon = train.wagons[input - 1]
    else
      puts 'Вагона с таким номером нет'
      load_menu
    end
  end

  # вспомогательная функция ввода производителя вагона
  def read_manufacturer
    print 'Введите производителя вагона:>>'
    gets.chomp
  end

  # вспомогательная функция выбора вагона
  def selection_wagon
    if @wagons.select { |wagon| wagon.type == train.type }.empty?
      puts 'Нет вагонов нужного типа, создайте вагон.'
      main_menu
    else
      wagon = @wagons.select { |wagon| wagon.type == train.type }
      @wagon = wagon.first
    end
  end

  # вспомогательная функция выбора поезда
  def selection_train
    print 'Введите номер поезда:>>'
    input = gets.chomp
    if @trains.select { |train| train.number == input }.empty?
      puts 'Такого поезда нет'
    else
      train = @trains.select { |train| train.number == input }
      @train = train.first
    end
  end

  # вспомогательная функция выбора маршрута
  def route_selection
    print 'Введите название маршрута:>>'
    input = gets.chomp
    if @routes.select { |route| route.name == input }.empty?
      puts 'Такого маршрута нет'
      work_menu
    else
      route = @routes.select { |route| route.name == input }
      @route = route.first
    end
  end

  # вспомогательная функция для промежуточных станций
  def intermediate
    print 'Название станции: >>'
    input = gets.chomp
    if @stations.select { |station| station.name == input }.empty?
      puts 'Такой станции нет'
      station_menu
    else
      intermediate_station = @stations.select { |station| station.name == input }
      @intermediate_station = intermediate_station.first
    end
  end
end
Main.new.main_menu
