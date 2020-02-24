require_relative 'output.rb'
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
  include Constants
  include Output
  attr_reader :route, :train, :wagon
  
  def initialize
    @stations = []
    @trains = []
    @wagons = []
    @routes = []
  end
  
  def main_menu
    MAIN_MENU_ITEMS.each { |item| output(item) }
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
      load_menu
    when '7'
      information_menu 
    when '8'
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
    output "Станция #{ station } создана"
    main_menu
  rescue Station::ValidationError => e
    output " #{ e.message} Попробуй еще раз"
    station_menu
  end
  
  def train_menu
    TRAIN_MENU_ITEMS.each { |item| output(item) }
    input = gets.chomp
    case  input
    when '1'
      print 'Введите номер поезда:>>'
      input = gets.chomp
      @trains << PassengerTrain.new(input)
      output "Пассажирский поезд № #{ input } создан" 
      main_menu
    when '2'
      print 'Введите номер поезда:>>'
      input = gets.chomp
      @trains << CargoTrain.new(input)
      output "Грузовой поезд № #{ input } создан"
      main_menu
    when '3' 
      main_menu
    else 
      train_menu
    end
  rescue Train::ValidationError => e
    output " #{ e.message } Попробуйте еще раз"
    train_menu
  end
  
  def wagon_menu
    WAGON_MENU_ITEMS.each { |item| output(item) }
    input = gets.chomp
    case input
    when '1'
      print 'Введите количество мест >>'
      input = gets.chomp.to_i   
      @wagons << PassengerWagon.new(read_manufacturer, input)
      output "Пассажирский вагон создан"
      wagon_menu
    when '2'
      print 'Введите объем >>'
      input = gets.chomp.to_i
      @wagons << CargoWagon.new(read_manufacturer, input)
      output 'Грузовой вагон создан'
      wagon_menu
    when '3' 
      main_menu
    else 
      wagon_menu
    end
  rescue Wagon::ValidationError => e   
    output " #{ e.message } Попробуйте еще раз"
    wagon_menu
  end
    
  def route_menu
    ROUTE_MENU_ITEMS.each { |item| output(item) }
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
    output 'Такой станции нет'
      route_menu 
    else
      start = @stations.select { |station| station.name == input }
      start = start.first
    end

      print 'Название конечной станции: >>'
      input = gets.chomp
    if @stations.select { |station| station.name == input }.empty?
    output 'Такой станции нет'
      route_menu 
    else
      stop = @stations.select { |station| station.name == input }
      stop = stop.first
    end
  
    @routes << Route.new(name, start, stop)
    output "Маршрут #{ name } создан"
    route_menu

  rescue Route::ValidationError => e
    output " #{ e.message } Попробуйте еще раз"
    route_menu
  end
  
  def add_intermediate_station
    route_selection
    intermediate 
    route.add_station(@intermediate_station)
    output "Промежуточная станция #{ @intermediate_station } добавлена"
    route_menu
    
  end

  def del_intermediate_station
    intermediate 
    route.del_station(@intermediate_station)
    output "Промежуточная станция #{ @intermediate_station } удалена"
    route_menu
  end

  def work_menu
    WORK_MENU_ITEMS.each { |item| output(item) } 
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
    INFORMATION_MENU_ITEMS.each { |item| output(item) }
    input = gets.chomp
    case input
    when '1'
      station_list
    when '2'
      station_train_list
    when '3'
      route_list
    when '4'
      list_all
    when '5'
      main_menu
    else
      information_menu
    end
  end

  def route_list
    @routes.each { |route| output route.name }
    information_menu
  end

  def station_list
    @stations.each { |station| output station.name }
    information_menu
  end

  def list_all
    @stations.each do |station|
      output "На станции #{ station.name } находятся поезда:"
      station.train_list_show do |train|
        output ">>>>№ #{ train.number } тип #{ train.type }"
        output "Прицеплено вагонов: #{ train.wagons.size }"
        train.wagon_list_show do |wagon|
          output "----Вагон № #{ train.wagons.index(wagon).next } тип #{ wagon.type }"
          if wagon.type == 'passenger'
            output "Количество мест: #{ wagon.number_of_seats }"
            output "Занято мест: #{ wagon.occupied_places }"
          end
          if wagon.type == 'cargo'
            output "Общий объем: #{ wagon.overall_volume }"
            output "Занятый объем: #{ wagon.loading_volume }"  
          end 
          output '-----------------------------------------------------------'     
        end
      end
    end
    information_menu
  end

  def station_train_list
    print 'Введите название станции:>>'
    input = gets.chomp
    if @stations.select { |station| station.name == input }.empty?
    output 'Такой станции нет'
      information_menu
    else
      station = @stations.select { |station| station.name == input }
      station = station.first
      station.train_list(self)
      information_menu
    end
  end

  def load_menu
    LOAD_MENU_ITEMS.each { |item| output(item) }
    input = gets.chomp
    case input
    when '1'
      put_the_passenger
    when '2'
      load_wagon
    when '3'
      main_menu
    else
      load_menu
    end
  end

  def put_the_passenger
    selection_train
    if train.type == 'passenger'
      selection_wagon_load
    else
      output 'Поезд не является пассажирским'
      load_menu
    end
    wagon.passenger_loading
    output 'Посадка пассажира'
    output "Занято мест #{ wagon.busy_seats }"
    output "Свободно мест #{ wagon.free_seat }"
    load_menu
  end

  def load_wagon
    selection_train
    if train.type =='cargo'
      selection_wagon_load
    else
      output 'Поезд не является грузовым'
    end
    print 'Введите объем груза>>'
    volume = gets.chomp.to_i
    wagon.wagon_loading(volume)
    output 'Груз загружен'
    output "Занятый объем #{ wagon.volume_occupied }"
    output "Свободный объем #{ wagon.available_volume }"
    load_menu
  end

  #вспомогательная функция выбора вагона для загрузки
  def selection_wagon_load
    print 'Введите номер вагона:>>'
    input = gets.chomp.to_i
    if input <= train.wagons.size
      @wagon = train.wagons[input - 1]
    else
      output 'Вагона с таким номером нет'
      load_menu
    end
  end 

  #замена puts
  def output(string)
    puts string
  end

  #вспомогательная функция ввода производителя вагона
  def read_manufacturer
    print 'Введите производителя вагона:>>'
    gets.chomp
  end
  
  # вспомогательная функция выбора вагона
  def selection_wagon
    if @wagons.select { |wagon| wagon.type == train.type }.empty?
      output 'Нет вагонов нужного типа, создайте вагон.'
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
    output 'Такого маршрута нет'
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
    output 'Такой станции нет'
      station_menu
    else
      intermediate_station = @stations.select { |station| station.name == input }
      @intermediate_station = intermediate_station.first
    end
  end
end
  Main.new.main_menu
