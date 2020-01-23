require_relative 'instance_counter'

class Station
  include InstanceCounter
  @@stations = []

  attr_reader :trains, :name

  def initialize(name)
    @name = name
    @trains = []
    self.class.add_station(self)    
    register_instance
  end

  class << self
    def add_station(station)
      @@stations << station
    end
  
    def all
      @@stations
    end
  end

  def coming(train)
    @trains << train
  end

  def train_list(main)
    if @trains.empty?
      puts 'На станции нет поездов'
    else
      @trains.each { |train| puts "Поезд № #{ train.number }"}
    end
  end

  def departure(train)
    @trains.delete(train)
  end

  def train_station(train)
     @trains.include?(train)
  end
end
