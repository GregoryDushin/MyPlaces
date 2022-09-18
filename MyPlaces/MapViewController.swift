//
//  MapViewController.swift
//  MyPlaces
//
//  Created by Григорий Душин on 15.09.2022.
//

import UIKit
import MapKit
import CoreLocation

protocol MapViewControllerDelegate {
    func getAdress (_ adress: String?)
}


class MapViewController: UIViewController {
    
    var mapViewControllerDelegate: MapViewControllerDelegate?
    
    var place = Place()
    
    let annotationIdentifier = "annotationIdentifier"
    
    let locationManager = CLLocationManager()
    
    let regionInMeters = 10000
    
    var incomeSegueIdentifire = ""
    

    @IBOutlet weak var doneButton: UIButton!
    
    @IBOutlet weak var adressLabel: UILabel!
    
    @IBOutlet weak var mapPinImage: UIImageView!
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        adressLabel.text = ""
        mapView.delegate = self
        setupMapView()
        checkLocationServises()
        
        
    }
    
    @IBAction func closeVC() {
        dismiss(animated: true)
    }
    
    @IBAction func centerViewInUserLocation(_ sender: Any) {
       showUserLocation()
    }
    @IBAction func doneButtonPressed() {
        mapViewControllerDelegate?.getAdress(adressLabel.text)
        dismiss(animated: true)
    }
    
    private func setupMapView() {
        if incomeSegueIdentifire == "showPlace" {
            setupPlacemark()
            mapPinImage.isHidden = true
            adressLabel.isHidden = true
            doneButton.isHidden = true
        }
    }
    
    private func setupPlacemark() {
        
        guard let location = place.location else {return}
        
        let geocoder = CLGeocoder()
        
        geocoder.geocodeAddressString(location) { placemarks, error in
            if let error = error {
                print(error)
                return
            }
            guard let placemarks = placemarks else {return}
            
            let placemark = placemarks.first
            
            let annotation = MKPointAnnotation()
            annotation.title = self.place.name
            annotation.subtitle = self.place.type
            
            guard let placeMarkLocation = placemark?.location else {return}
            
            annotation.coordinate = placeMarkLocation.coordinate
            
            self.mapView.showAnnotations([annotation], animated: true)
            self.mapView.selectAnnotation(annotation, animated: true)
        }
    }
    
    private func checkLocationServises() {
        
        if CLLocationManager.locationServicesEnabled() {
            setupLocationManager()
            checkLocationAutorization()
            
        }else{
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.showAlert(title: "Location services are disabled", message: "Turn on location services")
            }
        }
    }
    private func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
   
    private func checkLocationAutorization() {
        let manager = CLLocationManager()
        switch manager.authorizationStatus {
        case .authorizedWhenInUse :
            mapView.showsUserLocation = true
            
            if incomeSegueIdentifire == "getAdress" {
         showUserLocation()
            }
            
            break
        case .denied :
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.showAlert(title: "Location services are disabled", message: "Turn on location services")
            }
            break
        case .notDetermined :
            locationManager.requestWhenInUseAuthorization()
            break
        case .restricted:
            break
        case .authorizedAlways:
            break
        @unknown default:
            print ("new methods are avaliable")
        }
        
    }
    
    private func getCenterLocation(for mapView: MKMapView) -> CLLocation{
        let lattitude = mapView.centerCoordinate.latitude
        let longitude = mapView.centerCoordinate.longitude
        
        return CLLocation(latitude: lattitude, longitude: longitude)
        
    }
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    private func showUserLocation(){
        if let location = locationManager.location?.coordinate {
            let region = MKCoordinateRegion(center: location, latitudinalMeters: 10000, longitudinalMeters: 10000)
            mapView.setRegion(region, animated: true)
        }
    }
    
}
   
    
    extension MapViewController : MKMapViewDelegate {
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            guard !(annotation is MKUserLocation) else {return nil}
            
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: annotationIdentifier) as? MKPinAnnotationView
            
            if annotationView == nil  {
                annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: annotationIdentifier)
                annotationView?.canShowCallout = true
            }
            if let imageData = place.imageData {
                let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
                imageView.layer.cornerRadius = 10
                imageView.clipsToBounds = true
                imageView.image = UIImage(data: imageData)
                annotationView?.rightCalloutAccessoryView = imageView
            }
            
            return annotationView
        }
        func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
            let center = getCenterLocation(for: mapView)
            let geocoder = CLGeocoder()
            geocoder.reverseGeocodeLocation(center) { placemarks, error in
                if let error = error {
                    print(error)
                    return
                }
                guard let placemarks = placemarks else {return}
                let placemark = placemarks.first
                let streetName = placemark?.thoroughfare
                let buildNumber = placemark?.subThoroughfare
                
                DispatchQueue.main.async {
                    if streetName != nil && buildNumber != nil {
                      self.adressLabel.text = "\(streetName!) , \(buildNumber!)"
                    } else if streetName != nil {
                        self.adressLabel.text = "\(streetName!)"
                    } else {
                        self.adressLabel.text = ""
                    }
                }
            }
        }
    }
extension MapViewController: CLLocationManagerDelegate {

        func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
            checkLocationAutorization()
        }
    }
