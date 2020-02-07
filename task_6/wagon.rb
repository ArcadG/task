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

  def validate!
    raise ValidationError.new('Производитель не может быть пустым') if @manufacturer.empty?
  end
end
