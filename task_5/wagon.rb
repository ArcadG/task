class Wagon
  include Manufacturer
  attr_reader :type
  def initialize(type, manufacturer)
    @type = type
    @manufacturer = manufacturer
  end
end