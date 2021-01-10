//
//  ViewController.swift
//  Clima
//
//  Created by Haziel Castillo on 21/11/20.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, UITextFieldDelegate, ClimaManagerDelegate {

    var climaManager = ClimaManager()
    var ubicacionManager = CLLocationManager()
    
    @IBOutlet weak var buscarTextField: UITextField!
    @IBOutlet weak var ciudadLabel: UILabel!
    @IBOutlet weak var temperaturaLabel: UILabel!
    @IBOutlet weak var climaImageView: UIImageView!
    @IBOutlet weak var tempMaxLabel: UILabel!
    @IBOutlet weak var tempMinLabel: UILabel!
    @IBOutlet weak var vientoLabel: UILabel!
    @IBOutlet weak var humedadLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        ubicacionManager.delegate = self
        ubicacionManager.requestWhenInUseAuthorization()
        ubicacionManager.requestLocation()
        
        buscarTextField.delegate = self
        climaManager.delegado = self
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    // Programar el boton del teclado
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        ciudadLabel.text = buscarTextField.text
        climaManager.fetchClima(nombreCiudad: buscarTextField.text!)
        return true
    }
    
    // Valida si el usuario termino de editar en el textfield
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if buscarTextField.text != "" {
            return true
        } else {
            buscarTextField.placeholder = "Escribe una ciudad"
            return false
        }
    }
    
    // Implementamos el delegado
    func actualizarClima(clima: ClimaModelo) {
        DispatchQueue.main.async {
            self.temperaturaLabel.text = "\(String(clima.temperaturaDecimal))ºC"
            self.climaImageView.image = UIImage(named: clima.condicionClima)
            self.tempMaxLabel.text = "\(String(clima.temperaturaMaximaDecimal))ºC"
            self.tempMinLabel.text = "\(String(clima.temperaturaMinimaDecimal))ºC"
            self.vientoLabel.text = "\(String(clima.viento)) Km"
            self.humedadLabel.text = "\(String(clima.humedad)) f"
            self.ciudadLabel.text = "En \(clima.nombreCiudad) el clima es \(clima.descripcionClima)"
        }
    }
    
    @IBAction func obtenerUbicacion(_ sender: Any) {
        dismissKeyboard()
        ubicacionManager.requestLocation()
    }
}


extension ViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let ubications = locations.last {
            ubicacionManager.stopUpdatingLocation()
            let latitud = ubications.coordinate.latitude
            let longitud = ubications.coordinate.longitude
            climaManager.fechtClima(lat: latitud, lon: longitud)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        if error.localizedDescription == "The operation couldn’t be completed." {
            let alert = UIAlertController(title: "Error", message: "No se pudo completar la operación", preferredStyle: .alert)
            
            let actionAcept = UIAlertAction(title: "Aceptar", style: .default, handler: nil)
            alert.addAction(actionAcept)
            self.present(alert, animated: true, completion: nil)
        }
    }
}
