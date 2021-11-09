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


class MarketViewController: BaseVC, CLLocationManagerDelegate, GMSMapViewDelegate {
    
    //MARK: - outlets
    @IBOutlet var maps: GMSMapView!
    @IBOutlet weak var searchBar: UITextField!
    @IBOutlet var marketInfoView: MarketInfoView!
    @IBOutlet var marketInfoHeight: NSLayoutConstraint!
    
    //MARK: - properties
    var locationManager = CLLocationManager()
    var currentLocation: CLLocation?
    var placesClient: GMSPlacesClient!
    var zoomLevel: Float = 15.0
    let userLocationMarker = GMSMarker()
    var markers = [GMSMarker]()
    
    var bottomPadding = 0
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        setupMapStyle()
        setupMapMarkers(places: DataProvider.shared.places)
    }
    
    //MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.setPadding(inset: self.bottomPadding)
    }
    
    //MARK: - functions
    fileprivate func setupLocationManager() {
        locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.distanceFilter = 50
        locationManager.startUpdatingLocation()
        locationManager.delegate = self
    }
    
    fileprivate func setupView() {
        setupLocationManager()
        placesClient = GMSPlacesClient.shared()
        maps.delegate = self
        searchBar.delegate = self
        setupMapStyle()
        setupMapMarkers(places: DataProvider.shared.places)
        
        
        self.marketInfoHeight.constant = 0
        self.marketInfoView.closeButton.addTarget(self, action: #selector(closeMarketInfoView), for: .touchUpInside)
    }
    
    @objc func closeMarketInfoView() {
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: [.curveEaseIn], animations: {
            
            self.marketInfoHeight.constant = 0
            self.view.layoutIfNeeded()
            self.setPadding(inset: self.bottomPadding)
            self.clearMarkers()
        }, completion: nil)
    }
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        if marker != self.userLocationMarker {
            for marker in markers {
                marker.icon = #imageLiteral(resourceName: "maps-marker")
            }
            marker.icon = #imageLiteral(resourceName: "maps-selected-marker")
            let camera = GMSCameraPosition.camera(withLatitude: marker.position.latitude,longitude: marker.position.longitude,zoom: 10)
            maps.animate(to: camera)
            marketDidSelected(id: Int(marker.title ?? "0")!)
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

//MARK: - textfield
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
                marketDidSelected(id: place.offset)
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

//MARK: - Marker view functions
extension MarketViewController {
    
    func marketDidSelected(id: Int) {
        let marketInfoViewHeight : CGFloat = 200.0
        let mapPadding = 170
        UIView.animate(withDuration: 0.2) {
            self.marketInfoView.nameLabel.text = DataProvider.shared.places[id].name
            self.marketInfoView.websiteLabel.text = DataProvider.shared.places[id].websiteURL
        }
        
        self.marketInfoView.lat = Double(DataProvider.shared.places[id].lat ?? "0.0")!
        self.marketInfoView.lng = Double(DataProvider.shared.places[id].lng ?? "0.0")!
        self.marketInfoView.directionButton.addTarget(self, action: #selector(directionMarket), for: .touchUpInside)
        
        if marketInfoHeight.constant == 0 {
//            if self.marketInfoView.superview == nil {
//                self.marketInfoView.frame.origin = CGPoint(x: 0, y: self.view.frame.height - marketInfoViewHeight)
//                self.view.addSubview(self.marketInfoView)
//            }
            if UIDevice.current.modelName == "iPhone X" || UIDevice.current.modelName == "iPhone XS" || UIDevice.current.modelName == "iPhone XS Max" || UIDevice.current.modelName == "iPhone XR" || UIDevice.current.modelName == "iPhone 11" || UIDevice.current.modelName == "iPhone 11 Pro" || UIDevice.current.modelName == "iPhone 11 Pro Max" || UIDevice.current.modelName == "Simulator"  {
                
                UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0.5, options: [.curveEaseOut], animations: {
                    self.marketInfoHeight.constant = marketInfoViewHeight
                    self.setPadding(inset: mapPadding)
                    self.view.layoutIfNeeded()
                }, completion: nil)
            }
            else {
                UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0.5, options: [.curveEaseOut], animations: {
                    self.marketInfoHeight.constant = marketInfoViewHeight
                    self.setPadding(inset: mapPadding + 40)
                    self.view.layoutIfNeeded()
                }, completion: nil)
            }
        }
    }
    
    @objc func callMarket() {
        let numbers = self.marketInfoView.callNumber.split(separator: ",")
        if let number = (numbers.randomElement()?.description)?.replacingOccurrences(of: " ", with: "") {
            if let url = URL(string: "tel://\(number)"), UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
                
            }
        }
    }
    
    @objc func directionMarket() {
        
        if (UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!)) {
            if let url = "comgooglemaps://?saddr=&daddr=\(self.marketInfoView.lat)),\(self.marketInfoView.lng))&directionsmode=driving".getCleanedURL() {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
            else {
                KVNProgress.showError(withStatus: "The coordinator is not valid")
            }
        }
        else if let url = "http://maps.apple.com/maps?saddr=\(self.marketInfoView.lat),\(self.marketInfoView.lng)".getCleanedURL(), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
        else {
            KVNProgress.showError(withStatus: "You don't have any map in your device")
        }
        
    }
    
}
