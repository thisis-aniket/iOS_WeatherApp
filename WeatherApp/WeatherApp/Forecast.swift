//
//  Forecast.swift
//  WeatherApp
//
//  Created by Aniket Landge on 24/02/22.
//

import Foundation

//Model For Forecast
struct Forecast: Codable{
    struct Daily: Codable{
        let dt: Date
        struct Temp: Codable{
            let min: Double
            let max: Double
        }
        let temp: Temp
        let humidity: Int
        struct Weather: Codable{
            let id: Int
            let description: String
            let icon: String
        }
        let weather: [Weather]
        let clouds: Int
        let pop: Double
    }
    let daily: [Daily]
}

