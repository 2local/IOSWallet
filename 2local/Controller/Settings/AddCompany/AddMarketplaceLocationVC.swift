//
//  AddMarketplaceLocationVC.swift
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

protocol AddMarketplaceProtocol {
  func companyLocationAdded(coordinate: CLLocationCoordinate2D)
}

class AddMarketplaceLocationVC: BaseVC {

  // MARK: - outlets
  @IBOutlet weak var mapView: GMSMapView!
  @IBOutlet weak var bottomView: UIView!
  @IBOutlet weak var addBTN: UIButton!

  // MARK: - properties
  var delegate: AddMarketplaceProtocol?
  var locationManager = CLLocationManager()
  var currentLocation: CLLocation?
  var placesClient: GMSPlacesClient!
  var zoomLevel: Float = 15.0
  // let userLocationMarker = GMSMarker()

  var selectedCoordinate = CLLocationCoordinate2D()

  // MARK: - life cycle
  override func viewDidLoad() {
    super.viewDidLoad()

    setupLocationManager()
    setupMapView()
    setupView()
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)

    guard let currentLocation = self.currentLocation else { return }

    let camera = GMSCameraPosition.camera(withLatitude: currentLocation.coordinate.latitude,
                                          longitude: currentLocation.coordinate.longitude,
                                          zoom: zoomLevel)
    mapView.camera = camera
  }

  // MARK: - functions
  fileprivate func setupView() {
    self.bottomView.setShadow(color: UIColor.color002CA4, opacity: 1, offset: CGSize(width: 0, height: 0), radius: 6)
    self.addBTN.setBorderWith(.flamenco, width: 1.2)
  }

  override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
    setupMapStyle()
  }

  // MARK: - actions
  @IBAction func addBTN(_ sender: Any) {
    delegate?.companyLocationAdded(coordinate: selectedCoordinate)
    KVNProgress.showSuccess(withStatus: "Location Added Successfully") {
      if let navigation = self.navigationController {
        navigation.popViewController(animated: true)
      }
    }
  }
}

// MARK: - Location manager
extension AddMarketplaceLocationVC: CLLocationManagerDelegate {

  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    let location: CLLocation = locations.last!
    print("Location: \(location)")
    let camera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude,
                                          longitude: location.coordinate.longitude,
                                          zoom: zoomLevel)
    self.currentLocation = locations.first
    // self.userLocationMarker.position = location.coordinate

    if mapView.isHidden {
      mapView.isHidden = false
      mapView.camera = camera
    }

    // userLocationMarker.icon = UIImage(named: "currentLocation")
    // userLocationMarker.map = self.mapView

  }

  fileprivate func setupLocationManager() {
    locationManager = CLLocationManager()
    locationManager.desiredAccuracy = kCLLocationAccuracyBest
    locationManager.requestWhenInUseAuthorization()
    locationManager.distanceFilter = 50
    locationManager.startUpdatingLocation()
    locationManager.delegate = self

  }

}

// MARK: - Map
extension AddMarketplaceLocationVC: GMSMapViewDelegate {

  func setupMapView() {
    mapView.delegate = self
    mapView.isMyLocationEnabled = true
    mapView.settings.myLocationButton = true

    setupMapStyle()
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

    } catch {
      NSLog("One or more of the map styles failed to load. \(error)")
    }
  }

  func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
    let coordinate = position.target
    self.selectedCoordinate = coordinate
  }

}
