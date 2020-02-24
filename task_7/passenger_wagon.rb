class PassengerWagon < Wagon
  include Output
  attr_accessor :number_of_seats, :occupied_places
  def initialize(manufacturer, number_of_seats)
    super('passenger', manufacturer)
    @number_of_seats = number_of_seats
    @occupied_places = 0
  end

  def passenger_loading
    if @number_of_seats <= @occupied_places 
      output 'Свободных мест нет'
    else   
      @occupied_places += 1
    end 
  end

  def busy_seats
    @occupied_places
  end

  def free_seat
    @number_of_seats - @occupied_places
  end
  
end
