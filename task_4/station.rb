class Station
  attr_reader :trains, :name

  def initialize(name)
   @name = name
   @trains = []
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
