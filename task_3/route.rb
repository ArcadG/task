class Route
  attr_reader :stations

  def initialize(starting_station, end_station)
    @stations = [starting_station, end_station]
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

  def stations_list
    stations.each { |station| puts station.name  }
  end
end
