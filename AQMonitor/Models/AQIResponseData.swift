//
//  AQIResponseData.swift
//  AQMonitor
//

import Foundation

struct AQIResponseData: Codable {
    var city: String
    var aqi: Float
    init(city: String, aqi: Float) {
        self.city = city
        self.aqi = aqi
    }
}
