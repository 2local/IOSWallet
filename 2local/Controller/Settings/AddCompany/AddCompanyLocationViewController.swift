//
//  AddCompanyLocationViewController.swift
//  2local
//
//  Created by Hasan Sedaghat on 10/25/20.
//  Copyright © 2020 2local Inc. All rights reserved.
//

import UIKit
import GoogleMaps
import CoreLocation
import GooglePlaces
import KVNProgress

protocol AddCompanyProtocol {
    func companyLocationAdded(coordinate:CLLocationCoordinate2D)
}
class AddCompanyLocationViewController: BaseVC, GMSMapViewDelegate,CLLocationManagerDelegate {

    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var addBTN: UIButton!
    var delegate : AddCompanyProtocol?
    var locationManager = CLLocationManager()
    var currentLocation: CLLocation?
    var placesClient: GMSPlacesClient!
    var zoomLevel: Float = 15.0
    //let userLocationMarker = GMSMarker()
    
    var selectedCoordinate = CLLocationCoordinate2D()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.bottomView.setShadow(color: UIColor._002CA4, opacity: 1, offset: CGSize(width: 0, height: 0), radius: 6)
        self.addBTN.setBorderWith(._flamenco, width: 1.2)
        locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.distanceFilter = 50
        locationManager.startUpdatingLocation()
        locationManager.delegate = self
        mapView.delegate = self
        self.mapView.isMyLocationEnabled = true
        self.mapView.settings.myLocationButton = true
        self.setupMapStyle()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        guard let currentLocation = self.currentLocation else {
            return
        }
        
        let camera = GMSCameraPosition.camera(withLatitude: currentLocation.coordinate.latitude,longitude: currentLocation.coordinate.longitude,zoom: zoomLevel)
        mapView.camera = camera
    }
    
    @IBAction func addBTN(_ sender: Any) {
        delegate?.companyLocationAdded(coordinate: selectedCoordinate)
        KVNProgress.showSuccess(withStatus: "Location Added Successfully") {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        let coordinate = position.target
        self.selectedCoordinate = coordinate
        print(coordinate)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location: CLLocation = locations.last!
        print("Location: \(location)")
        let camera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude,longitude: location.coordinate.longitude,zoom: zoomLevel)
        self.currentLocation = locations.first
        //self.userLocationMarker.position = location.coordinate
        
        if mapView.isHidden {
            mapView.isHidden = false
            mapView.camera = camera
        }
        
        //userLocationMarker.icon = UIImage(named: "currentLocation")
        //userLocationMarker.map = self.mapView
        
    }
    
    func setupMapStyle() {
        do {
            if #available(iOS 12.0, *) {
                if self.traitCollection.userInterfaceStyle == .dark {
                    if let styleURL = Bundle.main.url(forResource: "dark-style", withExtension: "json") {
                        mapView.mapStyle = try GMSMapStyle(contentsOfFileURL: styleURL)
                    } else {
                        NSLog("Unable to find style.json")
                    }
                } else {
                    if let styleURL = Bundle.main.url(forResource: "style", withExtension: "json") {
                        mapView.mapStyle = try GMSMapStyle(contentsOfFileURL: styleURL)
                    } else {
                        NSLog("Unable to find style.json")
                    }
                }
            } else {
                if let styleURL = Bundle.main.url(forResource: "style", withExtension: "json") {
                    mapView.mapStyle = try GMSMapStyle(contentsOfFileURL: styleURL)
                } else {
                    NSLog("Unable to find style.json")
                }
            }
            
        }
        catch {
            NSLog("One or more of the map styles failed to load. \(error)")
        }
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        setupMapStyle()
    }
}
