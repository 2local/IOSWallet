//
//  AddMarketplaceVC.swift
//  2local
//
//  Created by Hasan Sedaghat on 10/10/20.
//  Copyright © 2020 2local Inc. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import KVNProgress
import CoreLocation

class AddMarketplaceVC: BaseVC {

  // MARK: - outlets
  @IBOutlet weak var scrollView: UIScrollView!
  @IBOutlet weak var nameTXF: SkyFloatingLabelTextField! {
    didSet {
      nameTXF.titleFont = .TLFont(weight: .medium,
                                  size: 12)
      nameTXF.placeholderFont = .TLFont()
      nameTXF.font = .TLFont()
    }
  }
  @IBOutlet weak var websiteTXF: SkyFloatingLabelTextField! {
    didSet {
      websiteTXF.titleFont = .TLFont(weight: .medium,
                                     size: 12)
      websiteTXF.placeholderFont = .TLFont()
      websiteTXF.font = .TLFont()
    }
  }
  @IBOutlet var addLocationBTN: TLButton! {
    didSet {
      addLocationBTN.layer.borderColor = UIColor.flamenco.cgColor
      addLocationBTN.layer.borderWidth = 1
    }
  }

  // MARK: - properties
  var selectedCoordinate: CLLocationCoordinate2D?

  // MARK: - view cycle
  override func viewDidLoad() {
    super.viewDidLoad()

  }

  // MARK: - actions
  @IBAction func addMarketPlace(_ sender: Any) {
    if selectedCoordinate != nil && self.nameTXF.text != "" && self.websiteTXF.text != "" {
      KVNProgress.show()
      APIManager.shared.addMarketplace(companyName: self.nameTXF.text!,
                                       website: self.websiteTXF.text!,
                                       location: selectedCoordinate!) { (data, response, _) in
        let result = APIManager.processResponse(response: response, data: data)
        if result.status {
          KVNProgress.showSuccess(withStatus: "Marketplace added\n we'll review that and will add to the markets") {
            self.navigationController?.popViewController(animated: true)
          }
        } else {
          KVNProgress.showError(withStatus: result.message)
        }
      }
    } else if self.nameTXF.text == "" {
      KVNProgress.showError(withStatus: "Please fill the market name field")
    } else if self.websiteTXF.text == "" {
      KVNProgress.showError(withStatus: "Please fill the website url field")
    } else {
      KVNProgress.showError(withStatus: "Please add the location")
    }

  }

  @IBAction func addMarketPlaceTapped(_ sender: UIButton) {
    let vc = UIStoryboard.settings.instantiate(viewController: AddMarketplaceLocationVC.self)
    vc.delegate = self
    if let navigation = navigationController {
      navigation.pushViewController(vc, animated: true)
    }
  }
}

// MARK: - delegation
extension AddMarketplaceVC: AddMarketplaceProtocol {
  func companyLocationAdded(coordinate: CLLocationCoordinate2D) {
    selectedCoordinate = coordinate
  }
}
