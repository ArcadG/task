class Wagon
  include Manufacturer
  include Valid
  ValidationError = Class.new StandardError 
  attr_reader :type
  def initialize(type, manufacturer)
    @type = type
    @manufacturer = manufacturer
    validate!
  end

  def show
    { wagon_type: "Тип вагона #{ type }" }
  end

  private

  def validate!
    validate_manufacturer! 
  end

  def validate_manufacturer!
    raise ValidationError.new('Производитель не может быть пустым') if @manufacturer.empty?
  end
end
