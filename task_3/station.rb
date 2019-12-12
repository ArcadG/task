class Station
  attr_reader :trains, :name

  def initialize(name)
   @name = name
   @trains = []
  end

  def coming(train)
    @trains << train
  end

  def train_list(type)
    @trains.select { |train| train.type == type }
  end

  def departure(train)
    @trains.delete(train)
  end
end


    
    
