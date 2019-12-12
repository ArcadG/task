class Train
  attr_accessor :speed, :wagons, :route, :type, :station_index
  def initialize(speed = 0, number, type, wagons)
    @speed = speed 
    @number = number
    @type = type
    @wagons = wagons
  end
  
  def go(speed)
    self.speed += speed
  end

  def reduce_speed(speed)
    self.speed -= speed 
    speed = 0 if self.speed < 0
    speed
  end

  def to_attach
    self.wagons += 1 if speed == 0
  end
   
  def unhook
    self.wagons -= 1 if speed == 0 && wagons > 0
  end
  
  def current_station
    route.stations[@station_index]
  end

  def route_train(route)
    @route = route
    @station_index = 0
    route.start_station.coming(self)
  end
   
  def next_station
    if @station_index < route.stations.size 
       route.stations[@station_index += 1]
    end
  end
   
  def back_station(route)
    if @station_index > 0  
       route.stations[@station_index -= 1] 
    end
  end

  def train_next
    current_station.departure(self)
    next_station.coming(self)
    @station_index += 1
  end

  def train_bask
    current_station.departure(self)
    back_station.coming(self)
    @station_index -= 1
  end
end
 
