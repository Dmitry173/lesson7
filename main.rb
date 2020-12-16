require_relative "station"
require_relative "route"
require_relative "train"
require_relative "carriage"
require_relative "cargo_carriage"
require_relative "passenger_carriage"
require_relative "cargo_train"
require_relative "passenger_train"


class Railway

  attr_accessor :route, :station

  def initialize
    @stations = []
    @trains = []
    @routes = []
  end

  def choice
    loop do 
      puts " "
      puts "Выберите действие"
      puts "Нажмите 1, чтобы создать станцию"
      puts "Нажмите 2, чтобы создать поезд"
      puts "Нажмите 3, чтобы создавать маршруты и управлять в нем станциями(добавлять, удалять)"
      puts "Нажмите 4, назначить маршрут поезду"
      puts "Нажмите 5, чтобы прицепить вагон к поезду"
      puts "Нажмите 6, чтобы отцепить вагон от поезда"
      puts "Нажмите 7, чтобы перемещать поезд по маршруту(вперед и обратно)"
      puts "Нажмите 8, чтобы просматривать список станций и список поездов на станции"
      puts "Нажмите 0, чтобы выйти"
      action = gets.chomp 
      break if action == "0"
      case action
      when "1"
        create_station
      when "2"
        new_train
      when "3"
        create_route
      when "4"
        add_route
      when "5"
        add_carriage
      when "6"
        remove_carriage
      when "7"
        move_train
      when "8"
        show_list
      end
    end
  end

  def create_station
    puts "Введите название станции(минимум 3 символа)"
    name = gets.chomp
    station = Station.new(name)
    @stations.push(station)
    puts "Создана станция #{name}"
  rescue Exception => e
    puts e.message
    retry
  end

  def new_train
    puts "Введите тип поезда (cargo / passenger)"
    type = gets.chomp
    puts "Введите номер поезда в формате ххх-хх"
    number = gets.chomp
    if type == "cargo"
      @trains.push(CargoTrain.new(number))
      puts "Создан поезд под номером #{number} типа #{type}"
    elsif type == "passenger"
      @trains.push(PassengerTrain.new(number))
      puts "Создан поезд под номером #{number} типа #{type}"
    else
      puts "Данного типа поезда не существует"
    end
  rescue Exception => e
    puts e.message
    retry
  end

  def create_route
    loop do
      puts "Выберите действие"
      puts "Нажмите 1, чтобы создать маршрут"
      puts "Нажмите 2, чтобы добавить станцию в маршрут"
      puts "Нажмите 3, чтобы удалить станцию из маршрута"
      puts "Нажмите 0, чтобы вернуться в главное меню"
      action = gets.chomp 
      break if action == "0"
      case action
      when "1"
        create_new_route
      when "2"
        add_station_to_route
      when "3"
        remove_station_from_route
      end
    end
  end

  def create_new_route
    puts "Укажите первую станцию в маршруте"
    first_station = select_station
    puts "Укажите последнюю станцию в маршруте"
    last_station = select_station
    @routes.push(Route.new(first_station, last_station))
    puts "Создан маршрут от #{first_station.name} до #{last_station.name}"
  rescue Exception => e
    puts e.message
    retry
  end

  def add_station_to_route
    route = select_route
    puts "Какую станцию добавить в маршрут?"
    station = select_station
    if route.stations.include?(station)
      puts "В маршруте уже есть такая станция"
    else
      route.add_station(station)
      puts "К маршруту добавлена станция #{station.name}"
    end
  end

  def remove_station_from_route
    route = select_route
    puts "Выберите станцию"
    station = select_station
    if station == route.first_station || station == route.last_station
      puts "Нельзя удалить начальную и конечную станции"
    elsif route.stations.include?(station)
      route.stations.delete(station)
      puts "Станция #{station.name} удалена из маршрута"
    else
      puts "Данной станции нет в маршруте"
    end
  end

  def add_route
    train = select_train
    route = select_route
    train.add_route(route)
    puts "К поезду №#{train.number} добавлен маршрут от станции #{route.stations.first.name} до станции #{route.stations.last.name}"
  end

  def show_routes
    @routes.each.with_index(1) { |route, x| puts "#{x}. #{route.stations}" }
        # не получается выводить @name станции, только всю информацию об объектах
  end

  def show_stations
    @stations.each.with_index(1) { |station, x| puts "#{x}. #{station.name}" }
  end

  def show_trains
    @trains.each.with_index(1) { |train, x| print "#{x}. #{train.number} \n" }
  end

  def select_route
    puts "выберите маршрут:"
    show_routes
    @routes[gets.to_i - 1]
  end

  def select_train
    puts "выберите поезд:"
    show_trains
    @trains[gets.to_i - 1]
  end

  def select_station
    show_stations
    @stations[gets.to_i - 1]
  end

  def add_carriage
    train = select_train
    if train.type == "cargo"
      carriage = CargoCarriage.new
      train.carriages.push(carriage)
      puts "К поезду №#{train.number} добавлен вагон" 
    elsif train.type == "pass"
      carriage = PassengerCarriage.new
      train.carriages.push(carriage)
      puts "К поезду №#{train.number} добавлен вагон" 
    end
  end
 
  def remove_carriage
    train = select_train
    if speed = 0 && train.carriages.size != 0
      train.carriages.pop
      puts "У поезда №#{train.number} убран вагон"
    else
      puts "Поезд в пути или у него нет вагов"
    end
  end
  
  def move_train
    train = select_train
    loop do
      puts "Введите '1' чтобы отправить поезд на следующую станцию"
      puts "Введите '2' чтобы отправить поезд на предыдущую станцию" 
      puts "Введите '3' чтобы вернуться в меню"
      case gets.to_i
      when 1
        train.move_next
        puts "Станция - #{train.station.name}"
        puts "Следующая станция - #{train.next_station.name}" if train.next_station != nil
      when 2
        train.move_prev
        puts "Станция - #{train.station.name}"
        puts "Следующая станция - #{train.prev_station.name}" if train.prev_station != nil
      when 3
        break
      else
        "Введите верное значение"
      end
    end
  end

  def show_list
    puts "Выберите станцию"
    station = select_station
    puts "Поезда на станции:"
    station.show_train
  end
end

railway = Railway.new
railway.choice
