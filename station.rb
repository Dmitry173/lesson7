require_relative "instance_counter"
require_relative "validate.rb"

class Station
  include InstanceCounter
  include Validate

  attr_reader :name, :trains
  
  NAME_ERROR = "Название не может быть короче 3 символов!"

  def self.all
    @@all
  end

  @@all = []
  
  def initialize(name)
    @name = name 
    @trains = []
    @@all << self
    validate!
  end

  def get_train(train)
    @trains << train
  end

  def send_train(train)
    trains.delete(train)
  end

  def show_train
    trains.each{ |train| puts train.number } 
  end

  def show_types(type)
    trains.each { |train| train.type == type }  
  end

  def validate!
    raise NAME_ERROR if name.length < 3
  end
end
