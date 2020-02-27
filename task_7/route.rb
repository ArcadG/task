class Route
  include InstanceCounter
  include Valid
  ValidationError = Class.new StandardError
  attr_reader :stations, :name

  def initialize(name, starting_station, end_station)
    @name = name
    @stations = [starting_station, end_station]
    validate!
    register_instance 
  end

  def add_station(station)
    stations.insert(-2, station)
  end

  def del_station(station)
    stations.delete(station)
  end
  
  def start_station
    stations.first
  end

  def end_station
    stations.last
  end
   
  def validate!
    raise ValidationError.new('Начальная и конечная станции должны быть разными') if start_station == end_station
  end
end
