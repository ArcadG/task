class Train
  attr_reader :speed, :wagons, :route, :type, :station_index
  def initialize(speed = 0, number, type, wagons)
    @speed = speed 
    @number = number
    @type = type
    @wagons = wagons
  end
  
  def go(speed)
    @speed += speed
  end

  def reduce_speed(speed)
    @speed -= speed 
    speed = 0 if @speed < 0
    speed
  end

  def to_attach
    wagons += 1 if speed == 0
  end
   
  def unhook
    wagons -= 1 if speed == 0 && wagons > 0
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

  def train_next
    current = current_station
    further = next_station
    further.coming(self)
    current.departure(self)
  end

  def train_bask
    current = current_station
    back = back_station
    back.coming(self)
    current.departure(self)
  end
end
 
