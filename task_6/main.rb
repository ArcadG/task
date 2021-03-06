class Main
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
    input = gets.chomp
    case input
    when '1' 
      station_menu
    when '2'
      train_menu
    when '3' 
      wagon_menu
    when '4' 
      route_menu
    when '5' 
      work_menu
    when '6'
      information_menu 
    when '7'
      exit
    else 
      main_menu
    end
  end

  private

  def return_wagon(wagon)
    @wagons << wagon
  end

  private

  def station_menu
    print 'Название станции:>> '
    station = gets.chomp
    @stations << Station.new(station)
    puts "Станция #{ station } создана"
    main_menu
  rescue Station::ValidationError => e
    puts " #{ e.message} Попробуй еще раз"
    station_menu
  end
  
  def train_menu
    TRAIN_MENU_ITEMS.each { |item| puts(item) }
    input = gets.chomp
    case  input
    when '1'
      print 'Введите номер поезда:>>'
      input = gets.chomp
      @trains << PassengerTrain.new(input)
      puts "Пассажирский поезд № #{ input } создан" 
      main_menu
    when '2'
      print 'Введите номер поезда:>>'
      input = gets.chomp
      @trains << CargoTrain.new(input)
      puts "Грузовой поезд № #{ input } создан"
      main_menu
    when '3' 
      main_menu
    else 
      train_menu
    end
  rescue Train::ValidationError => e
    puts " #{ e.message } Попробуйте еще раз"
    train_menu
  end
  
  def wagon_menu
    WAGON_MENU_ITEMS.each { |item| puts(item) }
    input = gets.chomp
    case input
    when '1'
      @wagons << PassengerWagon.new(read_manufacturer)
      puts "Пассажирский вагон создан"
      wagon_menu
    when '2'
      @wagons << CargoWagon.new(read_manufacturer)
      puts 'Грузовой вагон создан'
      wagon_menu
    when '3' 
      main_menu
    else 
      wagon_menu
    end
  rescue Wagon::ValidationError => e   
    puts " #{ e.message } Попробуйте еще раз"
    wagon_menu
  end
    
  def route_menu
    ROUTE_MENU_ITEMS.each { |item| puts(item) }
    input = gets.chomp
    case input
    when '1'
      station_start_stop
    when '2'
      add_intermediate_station
    when '3'
      del_intermediate_station
    when '4'
      main_menu 
    else
      route_menu          
    end
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
    end

      print 'Название конечной станции: >>'
      input = gets.chomp
    if @stations.select { |station| station.name == input }.empty?
      puts 'Такой станции нет'
      route_menu 
    else
      stop = @stations.select { |station| station.name == input }
      stop = stop.first
    end
  
    @routes << Route.new(name, start, stop)
    puts "Маршрут #{ name } создан"
    route_menu

  rescue Route::ValidationError => e
    puts " #{ e.message } Попробуйте еще раз"
    route_menu
  end
  
  def add_intermediate_station
    route_selection
    intermediate 
    route.add_station(@intermediate_station)
    puts "Промежуточная станция #{ @intermediate_station } добавлена"
    route_menu
    
  end

  def del_intermediate_station
    intermediate 
    route.del_station(@intermediate_station)
    puts "Промежуточная станция #{ @intermediate_station } удалена"
    route_menu
  end

  def work_menu
    WORK_MENU_ITEMS.each { |item| puts (item) } 
    input = gets.chomp
    case input
    when '1'
      train_route
    when '2'
      add_wagon
    when '3'
      del_wagon
    when '4'
      forward_movement
    when '5'
      backward_movement
    when '6'
      main_menu
    else
      work_menu
    end
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
    train.unhook(self)
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
    INFORMATION_MENU_ITEMS.each { |item| puts item }
    input = gets.chomp
    case input
    when '1'
      station_list
    when '2'
      station_train_list
    when '3'
      route_list
    when '4'
      main_menu
    else
      information_menu
    end
  end

  def route_list
    @routes.each { |route| puts route.name }
    information_menu
  end

  def station_list
    @stations.each { |station| puts station.name }
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
      station.train_list(self)
      information_menu
    end
  end

  #вспомогательная функция ввода производителя вагона
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

  #вспомогательная функция выбора поезда
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

  #вспомогательная функция выбора маршрута
  def route_selection
    print 'Введите название маршрута:>>'
    input = gets.chomp
    if @routes.select { |route| route.name == input}.empty?
      puts 'Такого маршрута нет'
      work_menu
    else
      route = @routes.select { |route| route.name == input}
      @route = route.first
    end
  end
  
  #вспомогательная функция для промежуточных станций
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
