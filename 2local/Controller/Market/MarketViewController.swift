//
//  MarketViewController.swift
//  2local
//
//  Created by Hasan Sedaghat on 12/31/19.
//  Copyright © 2019 2local Inc. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import CoreLocation
import KVNProgress


protocol MarketInfoDelegate: AnyObject {
    func marketDidSelected(id:Int)
}

class MarketViewController: BaseVC, CLLocationManagerDelegate,GMSMapViewDelegate {
    
    @IBOutlet var maps: GMSMapView!
    @IBOutlet weak var searchBar: UITextField!
    weak var delegate : MarketInfoDelegate?
    var locationManager = CLLocationManager()
    var currentLocation: CLLocation?
    var placesClient: GMSPlacesClient!
    var zoomLevel: Float = 15.0
    let userLocationMarker = GMSMarker()
    var markers = [GMSMarker]()
    var buttomPadding = 0
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        setupMapStyle()
        setupMapMarkers(places: DataProvider.shared.places)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.distanceFilter = 50
        locationManager.startUpdatingLocation()
        locationManager.delegate = self
        placesClient = GMSPlacesClient.shared()
        maps.delegate = self
        searchBar.delegate = self
        setupMapStyle()
        setupMapMarkers(places: DataProvider.shared.places)
    }
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        if marker != self.userLocationMarker {
            for marker in markers {
                marker.icon = #imageLiteral(resourceName: "maps-marker")
            }
            marker.icon = #imageLiteral(resourceName: "maps-selected-marker")
            let camera = GMSCameraPosition.camera(withLatitude: marker.position.latitude,longitude: marker.position.longitude,zoom: 10)
            maps.animate(to: camera)
            delegate?.marketDidSelected(id: Int(marker.title ?? "0")!)
            return true
        }
        return false
    }
    
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        self.view.endEditing(true)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location: CLLocation = locations.last!
        print("Location: \(location)")
        let camera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude,longitude: location.coordinate.longitude,zoom: zoomLevel)
        
        self.userLocationMarker.position = location.coordinate
        
        if maps.isHidden {
            maps.isHidden = false
            maps.camera = camera
        } else {
            if userLocationMarker.icon != UIImage(named: "currentLocation") {
                maps.animate(to: camera)
            }
        }
        
        userLocationMarker.icon = UIImage(named: "currentLocation")
        userLocationMarker.map = self.maps
    
    }
    
    
    func setupMapMarkers(places:[Companies]) {
        for marker in markers {
            marker.map = nil
        }
        markers.removeAll()
        
        for place in places.enumerated() {
            let marker: GMSMarker = GMSMarker()
            marker.icon = #imageLiteral(resourceName: "maps-marker")
            marker.title = String(describing: place.offset)
            let lat = Double(place.element.lat ?? "0.0")!
            let lng = Double(place.element.lng ?? "0.0")!
            marker.position = CLLocationCoordinate2D(latitude: lat, longitude: lng)
            DispatchQueue.main.async {
                marker.map = self.maps
            }
            markers.append(marker)
        }
    }
    
    func clearMarkers() {
        for marker in markers {
            marker.icon = #imageLiteral(resourceName: "maps-marker")
        }
    }
    
    func setupMapStyle() {
        do {
            if #available(iOS 12.0, *) {
                if self.traitCollection.userInterfaceStyle == .dark {
                    if let styleURL = Bundle.main.url(forResource: "dark-style", withExtension: "json") {
                        maps.mapStyle = try GMSMapStyle(contentsOfFileURL: styleURL)
                    } else {
                        NSLog("Unable to find style.json")
                    }
                } else {
                    if let styleURL = Bundle.main.url(forResource: "style", withExtension: "json") {
                        maps.mapStyle = try GMSMapStyle(contentsOfFileURL: styleURL)
                    } else {
                        NSLog("Unable to find style.json")
                    }
                }
            } else {
                if let styleURL = Bundle.main.url(forResource: "style", withExtension: "json") {
                    maps.mapStyle = try GMSMapStyle(contentsOfFileURL: styleURL)
                } else {
                    NSLog("Unable to find style.json")
                }
            }
            
        }
        catch {
            NSLog("One or more of the map styles failed to load. \(error)")
        }
    }
    
    func setPadding(inset:Int) {
        if maps != nil {
            maps.padding = UIEdgeInsets(top: 0, left: 0, bottom: CGFloat(inset), right: 0)
        }
    }
}

extension MarketViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.3, animations: {
            textField.alpha = 1
        }, completion: nil)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.3, animations: {
            textField.alpha = 0.6
        }, completion: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let places = DataProvider.shared.places
        var isFound = false
        for place in places.enumerated() {
            if (place.element.name?.lowercased().contains(textField.text!.lowercased()))! {
                let lat = Double(place.element.lat ?? "0.0")!
                let lng = Double(place.element.lng ?? "0.0")!
                let camera = GMSCameraPosition(latitude: lat, longitude: lng, zoom: 10)
                self.maps.animate(to: camera)
                isFound = true
                self.delegate?.marketDidSelected(id: place.offset)
                break
            }
        }
        
        if !isFound {
            KVNProgress.showError(withStatus: "No marketplace is found")
        }
    
        self.view.endEditing(true)
        return true
    }
}
