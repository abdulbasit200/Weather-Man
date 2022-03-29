# frozen_string_literal: false

require 'colorize'

class WeatherManExtension
  def print_values(value_array)
    print_month_year
    puts "Highest Average Temperatue: #{value_array[0]}C".red
    puts "Lowest Average Temperatue : #{value_array[1]}C".blue
    puts "Mean Average Humidity: #{value_array[2]}%".green
  end

  def avg_humidity_min_max_temperatue(city, time)
    temp_array = file_to_array(city, time)
    max_temprature_array = []
    min_temprature_array = []
    avg_humidity_array = []
    element = 0
    while element < temp_array.length
      max_temprature_array = append_temperature(max_temprature_array, temp_array[element][1])
      min_temprature_array = append_temperature(min_temprature_array, temp_array[element][3])
      avg_humidity_array = append_temperature(avg_humidity_array, temp_array[element][8])
      element += 1
    end
    value_array = final_calculations(max_temprature_array, min_temprature_array, avg_humidity_array)
    print_values(value_array)
  end

  def files_data_to_array_for_more_than_one_file(city, year)
    element = 0
    paths = select_year_city(city, year)
    array_2d = []
    while element < paths.length
      file = File.open(paths[element])
      element += 1
      file.readlines[1..].each { |line| array_2d << line.split(',') }
    end
    array_2d
  end

  def maximum_temperature_day_in_year(temp_array)
    max_temp_date = ''
    max_temp = -256
    element = 0
    while element < temp_array.length
      if max_temp < temp_array[element][1].to_i
        max_temp = temp_array[element][1].to_i
        max_temp_date = temp_array[element][0].split('-')
      end
      element += 1
    end
    max_temp_date = "#{change_month_formate(max_temp_date[1].to_i)} #{max_temp_date[2]}"
    [max_temp, max_temp_date]
  end

  def minimum_temperature_day_in_year(temp_array)
    min_temp_date = ''
    min_temp = 10_000
    element = 0
    while element < temp_array.length
      if min_temp > temp_array[element][3].to_i && min_temp != ''
        min_temp = temp_array[element][3].to_i
        min_temp_date = temp_array[element][0].split('-')
      end
      element += 1
    end
    min_temp_date = "#{change_month_formate(min_temp_date[1].to_i)} #{min_temp_date[2]}"
    [min_temp, min_temp_date]
  end

  def most_humid_day_in_year(temp_array)
    max_humid_date = ''
    max_humid = 0
    element = 0
    while element < temp_array.length
      if max_humid < temp_array[element][7].to_i
        max_humid = temp_array[element][7].to_i
        max_humid_date = temp_array[element][0].split('-')
      end
      element += 1
    end
    max_humid_date = "#{change_month_formate(max_humid_date[1].to_i)} #{max_humid_date[2]}"
    [max_humid, max_humid_date]
  end

  def most_humidity_min_max_temperatue_with_dates(city, year)
    temp_array = files_data_to_array_for_more_than_one_file(city, year)
    max_temp_date_array = maximum_temperature_day_in_year(temp_array)
    min_temp_date_array = minimum_temperature_day_in_year(temp_array)
    max_humid_date_array = most_humid_day_in_year(temp_array)
    puts "Highest Temperatue: #{max_temp_date_array[0]}C on #{max_temp_date_array[1]}".red
    puts "Lowest Temperatue: #{min_temp_date_array[0]}C on #{min_temp_date_array[1]}".blue
    puts "Highest Humidity: #{max_humid_date_array[0]}C on #{max_humid_date_array[1]}".green
  end
end
