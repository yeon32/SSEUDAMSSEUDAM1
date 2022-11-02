//
//  weather.swift
//  SSEUDAMSSEUDAM
//
//  Created by 김정연 on 2022/10/27.
//

import Foundation

struct WeatherResponse: Decodable {
    let weather: [Weather]
    let main : Main
    let name : String
}

struct Main: Decodable {
    let temp : Double
    let temp_min : Double
    let temp_max : Double
}

struct Weather: Decodable {
    let id : Double
    let main : String
    let description : String
    let icon : String
}
