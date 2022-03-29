# frozen_string_literal: false

require 'colorize'
require_relative 'utility'
puts "\nWelcome to Weather Man App.\n\n\n".green

class WeatherMan < WeatherManExtension
  def initialize
    @month_arry = %w[Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec]
    @months = %w[January February March April May June July August September October November December]
  end

  def change_month_formate(date)
    @months[date]
  end

  def file_to_array(city, time)
    path = select_year_month_city(city, time)
    file = File.open(path)
    array_2d = []
    file.readlines[1..].each { |line| array_2d << line.split(',') }
    array_2d
  end

  def print_month_year
    puts "#{@months[@month_arry.index @month]} #{@year}"
  end

  def append_temperature(arr_to_append, temp_arr)
    arr_to_append << temp_arr.to_i
  end

  def final_calculations(max_temprature_array, min_temprature_array, avg_humidity_array)
    max_temprature = (max_temprature_array.sum / max_temprature_array.size)
    min_temprature = (min_temprature_array.sum / min_temprature_array.size)
    avg_humidity = (avg_humidity_array.sum / avg_humidity_array.size)
    [max_temprature, min_temprature, avg_humidity]
  end

  def two_bar_for_every_day_in_month(city, date)
    temp_array = file_to_array(city, date)
    print_month_year

    element = 0
    while element < temp_array.length
      print_min_max_temperatue(temp_array[element][3].to_i, temp_array[element][1].to_i, element)
      element += 1
    end
  end

  def one_bar_for_every_day_in_month(city, year)
    temp_array = file_to_array(city, year)
    print_month_year

    element = 0
    while element < temp_array.length
      print_min_max_temperatue_one_bar_only(temp_array[element][3].to_i, temp_array[element][1].to_i, element)
      element += 1
    end
  end

  def select_year_month_city(city, time)
    time = time.split('/')
    @year = time[0]
    @month = @month_arry[time[1].to_i - 1]
    "#{Dir.pwd}/#{city}_weather/#{city}_weather_#{@year}_#{@month}.txt"
  end

  def select_year_city(city, year)
    paths = []
    element = 0
    while element < 12
      path = "#{Dir.pwd}/#{city}_weather/#{city}_weather_#{year}_#{@month_arry[element]}.txt"
      element += 1
      paths << path if File.exist?(path) == true
    end
    return paths unless paths.empty? == true
  end

  def print_min_max_temperatue(min_temperature, max_temperature, serial_no)
    serial_no += 1
    puts "#{serial_no} #{horizontal_bar(max_temperature).red} #{max_temperature}C"
    puts "#{serial_no} #{horizontal_bar(min_temperature).blue} #{min_temperature}C"
  end

  def print_min_max_temperatue_one_bar_only(min_temperature, max_temperature, serial_no)
    serial_no += 1
    print "#{serial_no} #{horizontal_bar(min_temperature).blue}#{horizontal_bar(max_temperature).red} "
    print "#{min_temperature}C - #{max_temperature}C\n"
  end

  def horizontal_bar(temperature)
    bar = ''
    element = 0
    while element < temperature
      bar += '+'
      element += 1
    end
    bar
  end
end

myargs = ARGV
argv_mode = myargs[0]
argv_time = myargs[1]
argv_city = myargs[2].split('/')[-1].split('_')[0]

obj = WeatherMan.new

case argv_mode
when '-e'
  obj.most_humidity_min_max_temperatue_with_dates(argv_city, argv_time)
when '-a'
  obj.avg_humidity_min_max_temperatue(argv_city, argv_time)
when '-c'
  obj.two_bar_for_every_day_in_month(argv_city, argv_time)
when '-d'
  obj.one_bar_for_every_day_in_month(argv_city, argv_time)
else
  'Invalid Entry!\n'
end
# ruby testfile.rb -e 2004 '/Users/dev/Desktop/Weather Man/lahore_weather'
# ruby testfile.rb -a 2004/2 '/Users/dev/Desktop/Weather Man/lahore_weather'
# ruby testfile.rb -c 2004/2 '/Users/dev/Desktop/Weather Man/lahore_weather'
# ruby testfile.rb -d 2004/2 '/Users/dev/Desktop/Weather Man/lahore_weather'
