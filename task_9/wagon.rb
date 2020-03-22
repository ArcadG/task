# frozen_string_literal: true

class Wagon
  include Manufacturer
  include Valid
  validate :manufacturer, :presence
  validate :manufacturer, :type, String
  attr_reader :type
  def initialize(type, manufacturer)
    @type = type
    @manufacturer = manufacturer
    validate!
  end

  def show
    { wagon_type: "Тип вагона #{type}" }
  end
end
