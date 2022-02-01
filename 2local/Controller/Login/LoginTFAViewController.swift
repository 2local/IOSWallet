//
//  LoginTFAViewController.swift
//  2local
//
//  Created by Hasan Sedaghat on 12/30/19.
//  Copyright © 2019 2local Inc. All rights reserved.
//

import UIKit
import SROTPView
import KVNProgress
protocol TwoVerificationDelegate: AnyObject {
    func verificationStatus(_ status: Bool)
}

class LoginTFAViewController: UIViewController {

    @IBOutlet var codeTXF: SROTPView!
    @IBOutlet var popUpView: UIView!

    var code = ""
    weak var delegate: TwoVerificationDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.tapToDismissKeyboard()
        self.popUpView.tapToDismissKeyboard()
        codeTXF.otpTextFieldsCount = 6
        codeTXF.otpTextFieldActiveBorderColor = .blueHaze
        codeTXF.otpTextFieldDefaultBorderColor = .solitude
        codeTXF.otpTextFieldFontColor = UIColor.color404040
        codeTXF.otpTextFieldFont = .TLFont(weight: .medium,
                                           size: 19)
        codeTXF.cursorColor = .flamenco
        codeTXF.otpTextFieldBorderWidth = 1
        codeTXF.otpTextFieldActiveBorderWidth = 1
        codeTXF.otpEnteredString = { pin in
            print("The entered pin is \(pin)")
            self.code = pin
            if self.code.count == 6 {
                self.view.endEditing(true)
            }
        }
    }

    override func viewDidLayoutSubviews() {
        codeTXF.initializeUI()
    }

    @IBAction func confirm(_ sender: Any) {
        self.verfyCode()
    }

    @IBAction func close(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    func verfyCode() {
        KVNProgress.show()
        APIManager.shared.verifyTwoVerification(code: code) { (data, response, _) in
            let result = APIManager.processResponse(response: response, data: data)
            if result.status {
                do {
                    if let isValid = try JSONDecoder().decode(ResultData<TwoVerification>.self, from: data!).record?.valid {
                        if isValid {
                            DispatchQueue.main.async {
                                KVNProgress.dismiss {
                                    self.dismiss(animated: true, completion: {
                                        self.delegate?.verificationStatus(true)
                                    })
                                }
                            }
                        } else {
                            DispatchQueue.main.async {
                                KVNProgress.showError(withStatus: result.message)
                            }
                        }
                    } else {
                        DispatchQueue.main.async {
                            KVNProgress.showError(withStatus: "There is a problem in verification")
                        }
                    }
                } catch {
                    DispatchQueue.main.async {
                        KVNProgress.showError(withStatus: "Failed To Parse Data From Server")
                    }
                }
            } else {
                DispatchQueue.main.async {
                    KVNProgress.showError(withStatus: result.message)
                }
            }
        }
    }
}
