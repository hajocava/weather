//
//  ClimaModelo.swift
//  Clima
//
//  Created by Haziel Castillo on 21/11/20.
//

import Foundation

struct ClimaModelo {
    let conditionID: Int
    let nombreCiudad: String
    let descripcionClima: String
    let temperaturaCelcius: Double
    let temperaturaMaxima: Double
    let temperaturaMinima: Double
    let viento: Double
    let humedad: Int
    
    // Crear propiedad computada
    var condicionClima: String {
        switch conditionID {
        case 200...232:
            return "cloud.bolt"
        case 300...321:
            return "cloud.drizzle"
        case 500...531:
            return "cloud.rain"
        case 600...622:
            return "cloud.snow"
        case 701...781:
            return "cloud.fog"
        case 800:
            return "sun.max"
        case 801...804:
            return "cloud.sun"
        default:
            return "cloud"
        }
    }
    
    var temperaturaDecimal: String {
        return String(format: "%.1f", temperaturaCelcius)
    }
    
    var temperaturaMaximaDecimal: String {
        return String(format: "%.1f", temperaturaMaxima)
    }
    
    var temperaturaMinimaDecimal: String {
        return String(format: "%.1f", temperaturaMinima)
    }
    
}
