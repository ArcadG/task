# frozen_string_literal: true

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
    { wagon_type: "Тип вагона #{type}" }
  end

  private

  def validate!
    validate_manufacturer!
  end

  def validate_manufacturer!
    return unless @manufacturer.empty?

    raise ValidationError, 'Производитель не может быть пустым'
  end
end
