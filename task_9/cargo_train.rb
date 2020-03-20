# frozen_string_literal: true

class CargoTrain < Train
  def initialize(number)
    super(number, 'cargo')
  end
end
