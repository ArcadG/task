class Train
  include Manufacturer
  include InstanceCounter
  include Valid

  NUMBER_FORMAT = /^[0-9а-я]{3}-?[0-9а-я]{2}$/i
  ValidationError = Class.new StandardError 

  @@trains = {}
  attr_reader :speed, :wagons, :route, :station_index, :number, :type 

  def initialize(speed = 0, number, type)
    @speed = speed 
    @number = number
    @type = type
    @wagons = []
    validate!
    self.class.add_train(self)
    register_instance
  end

  def show
    {
      name: ">>>>№ #{ number } тип #{ type }",
      wagon_size: "Прицеплено вагонов: #{ wagons.size }"
    }  
  end

  class << self
    def add_train(train)
      @@trains.merge!(train.number => train)
    end

    def find
      @@stations.detect { |train| train.number == number }
    end
  end
  
  def go(speed)
    @speed += speed
  end

  def reduce_speed(speed)
    @speed -= speed 
    speed = 0 if @speed < 0
    speed
  end

  def to_attach(wagon) 
    wagons << wagon if speed == 0 && wagon.type == type 
  end
   
  def unhook(main)
    return if speed != 0 || wagons.empty?
    wagon = wagons.fetch(-1)
    main.return_wagon(wagon)
    wagons.delete(wagon)
  end
  
  def current_station
    route.stations.detect { |station| station.train_station(self) }
  end

  def current_station_index
    route.stations.index(current_station)
  end

  def route_train(route)
    @route = route
    route.start_station.coming(self)
  end
   
  def next_station
    index = current_station_index
    if index < route.stations.size 
       route.stations[index + 1]
    end
  end
   
  def back_station
    index = current_station_index
    if index > 0  
       route.stations[index - 1] 
    end
  end

  def train_next(main)
    current = current_station
    further = next_station
    further.coming(self)
    current.departure(self)
  end
  
  def train_bask(main)
    current = current_station
    back = back_station
    back.coming(self)
    current.departure(self)
  end

  def wagon_list_show(&block)
    return if @wagons.empty?
    @wagons.each { |wagon| block.call(wagon) }
  end

  private

  def validate!
    validate_number_format! 
    validate_number!  
  end
  
  def  validate_number_format! 
    raise ValidationError.new('Введен некорректный номер') unless @number =~ NUMBER_FORMAT
  end

  def validate_number!
    raise ValidationError.new('Поезд с таким номером уже создан') if @@trains.key?(@number)
  end
end
