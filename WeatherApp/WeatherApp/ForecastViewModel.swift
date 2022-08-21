//
//  ForecastViewModel.swift
//  WeatherApp
//
//  Created by Aniket Landge on 04/03/22.
//

import Foundation

//View Model for Forecast Model
struct ForecastViewModel{
    let forecast: Forecast.Daily
    var system: Int
    
    //Dateformatter for date
    private static var dateFormatter: DateFormatter{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "E, MMM, d"
        return dateFormatter
    }
    
    //Number formatter for floating data types like double, long etc.
    var numberFormatter: NumberFormatter{
        let numberFormatter = NumberFormatter()
        numberFormatter.maximumFractionDigits = 1
        return numberFormatter
    }
    
    //Number formatter for pop
    var numberFormatter2: NumberFormatter{
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .percent
        return numberFormatter
    }
    
    func convert(_ temp: Double) -> Double{
        let celsius = temp - 273.5
        if system == 0 {
            return celsius
        }else{
            return celsius * 9 / 5 + 32
        }
    }
    
    var day: String{
        return Self.dateFormatter.string(from: forecast.dt)
    }
    
    var overView: String{
        return forecast.weather[0].description.capitalized
    }
    
    var high: String{
        return "H: \(self.numberFormatter.string(for: convert(forecast.temp.min)) ?? "0")°"
    }
    
    var low: String{
        return "L: \(self.numberFormatter.string(for: convert(forecast.temp.min)) ?? "0")°"
    }
    
    var pop: String{
        return "💧 \(self.numberFormatter2.string(for: forecast.pop) ?? "0%")"
    }
    
    //Note -> No need to use the Number formatter for clouds and humidity because they already given in percent.
    var clouds: String{
        return "☁️ \(forecast.clouds)%"
    }
    
    var humidity: String{
        return "Humidity: \(forecast.humidity)%"
    }
    
    var weatherIconURL: URL{
        let urlString = "https://openweathermap.org/img/wn/\(forecast.weather[0].icon)@2x.png"
        return URL(string: urlString)!
    }
}
