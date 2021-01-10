//
//  ClimaManager.swift
//  Clima
//
//  Created by Haziel Castillo on 21/11/20.
//

import Foundation

protocol ClimaManagerDelegate {
    func actualizarClima(clima: ClimaModelo)
}

struct ClimaManager {
    
    var delegado: ClimaManagerDelegate?
    
    let climaURL = "https://api.openweathermap.org/data/2.5/weather?appid=3c07af7ae4be178939938e048000c7bb&units=metric&lang=es"
    
    func fetchClima(nombreCiudad: String) {
        let urlString = "\(climaURL)&q=\(nombreCiudad)"
        realizarSolicitud(urlString: urlString)
    }
    
    func fechtClima(lat: Double, lon: Double) {
        let urlString = "\(climaURL)&lat=\(lat)&lon=\(lon)"
        realizarSolicitud(urlString: urlString)
    }
    
    func realizarSolicitud(urlString: String) {
        // 1.- Crear la URL
        if let url = URL(string: urlString) {
            // 2.- Crear el obj ULRSession
            let session = URLSession(configuration: .default)
            
            // 3.- Asignar una tarea a la session
            let tarea = session.dataTask(with: url) { (data, respuesta, error) in
                if error != nil {
                    print(error!)
                    return
                }
                
                if let datosSeguros = data {
                    // Decodificar el obj JSON de la API
                    if let clima = self.parseJSON(climaData: datosSeguros) {
                        // Quien sea el delegado, cualquier clase o estructura, que implemente el metodo actualizar clima
                        delegado?.actualizarClima(clima: clima)
                    }
                }
            }
            
            // 4.- Empezar la tarea
            tarea.resume()
        }
    }
    
    func parseJSON(climaData: Data) -> ClimaModelo? {
        let decoder = JSONDecoder()
        
        do {
            // Aqui ya accedemos a la informacion de nuestro objeto JSON
            let dataDecodificada = try decoder.decode(ClimaData.self, from: climaData)
            
            let id = dataDecodificada.weather[0].id
            let nombre = dataDecodificada.name
            let descripcion = dataDecodificada.weather[0].description
            let temperatura = dataDecodificada.main.temp
            let tempMax = dataDecodificada.main.temp_max
            let tempMin = dataDecodificada.main.temp_min
            let viento = dataDecodificada.wind.speed
            let humedad = dataDecodificada.main.humidity
            
            let objClima = ClimaModelo(conditionID: id, nombreCiudad: nombre, descripcionClima: descripcion, temperaturaCelcius: temperatura, temperaturaMaxima: tempMax, temperaturaMinima: tempMin, viento: viento, humedad: humedad)
            
            return objClima
            
        } catch {
            print(error)
            return nil
        }
    }
}
