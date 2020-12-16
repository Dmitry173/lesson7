require_relative "instance_counter"
require_relative "validate.rb"

class Route
  include InstanceCounter
  include Validate
  
  attr_accessor :stations

  STATION_ERROR = "Начальная станция не может быть конечной"


  def initialize (first_station, last_station)
    @stations = [first_station, last_station]
    validate!
  end

  def first_station
    stations.first
  end

  def last_station
    stations.last
  end

  def add_station(station)
    @stations.insert(-2, station)
  end

  def remove_station(station)
    return if station == stations.first || station == stations.last
    @stations.delete(station) if stations.include?(station)
  end

  def show_station 
    @stations.each { |station| puts station }
  end

  def validate!
    raise STATION_ERROR if first_station == last_station
  end
end
