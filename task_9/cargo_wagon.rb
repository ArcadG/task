# frozen_string_literal: true

class CargoWagon < Wagon
  attr_accessor :overall_volume, :loading_volume
  def initialize(manufacturer, overall_volume)
    super('cargo', manufacturer)
    @overall_volume = overall_volume
    @loading_volume = 0
  end

  def show
    {
      total_volume: "Общий объем: #{overall_volume}",
      occupied_volume: "Занятый объем: #{loading_volume}"
    }.merge(super)
  end

  def wagon_loading(volume)
    return if volume > @overall_volume - @loading_volume

    @loading_volume += volume
  end

  def volume_occupied
    @loading_volume
  end

  def available_volume
    @overall_volume - @loading_volume
  end
end
