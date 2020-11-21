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
    
    // Crear propiedad computada
    var condicionClima: String {
        switch conditionID {
        case 200...232:
            return "cloud-rain-solid"
        case 701...781:
            return "cloud.fog"
        case 800:
            return "sun"
        default:
            return "cloud-solid"
        }
    }
    
    var temperaturaDecimal: String {
        return String(format: "%.1f", temperaturaCelcius)
    }
}
