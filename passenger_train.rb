class PassengerTrain < Train

  def initialize (number)
    super
    @type = "passenger"
  end 

  def add_carriage(carriage)
    super if carriage.type == "passenger"
  end
end
