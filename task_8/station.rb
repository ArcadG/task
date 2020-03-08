# frozen_string_literal: true

class Station
  include InstanceCounter
  include Valid
  NAME_FORMAT = /^[а-я]*$/i.freeze
  ValidationError = Class.new StandardError
  attr_reader :trains, :name
  @@stations = []

  def initialize(name)
    @name = name
    @trains = []
    validate!
    self.class.add_station(self)
    register_instance
  end

  def show
    { info: "На станции #{name} находятся поезда:" }
  end

  class << self
    def add_station(station)
      @@stations << station
    end

    def all
      @@stations
    end
  end

  def coming(train)
    @trains << train
  end

  def train_list(_main)
    return if @trains.empty?

    @trains.map { |train| "Поезд № #{train.number}" }
  end

  def train_list_show(&block)
    return if @trains.empty?

    @trains.each { |train| block.call(train) }
  end

  def departure(train)
    @trains.delete(train)
  end

  def train_station(train)
    @trains.include?(train)
  end

  private

  def validate!
    validate_name!
    validate_name_format!
  end

  def validate_name!
    unless @@stations.select { |station| station.name == name }.empty?
      raise ValidationError, 'Такая станция уже есть'
    end
  end

  def validate_name_format!
    raise ValidationError, 'Неверное название' unless name =~ NAME_FORMAT
  end
end
