class CargoWagon < Wagon
  include Output
  attr_accessor :overall_volume, :loading_volume  
  def initialize(manufacturer, overall_volume)
    super('cargo', manufacturer)
    @overall_volume = overall_volume
    @loading_volume = 0
  end

  def wagon_loading(volume)
    if @overall_volume <= @loading_volume && volume > @overall_volume 
      output 'Нет места'
    else 
      @loading_volume += volume
    end
  end

  def volume_occupied
    @loading_volume
  end

  def available_volume
    @overall_volume - @loading_volume
  end
end
