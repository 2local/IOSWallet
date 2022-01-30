//
//  APIManager.swift
//  2local
//
//  Created by Hasan Sedaghat on 12/28/19.
//  Copyright © 2019 2local Inc. All rights reserved.
//

import UIKit
import CoreLocation

class APIManager: NSObject {
  static let shared = APIManager()

  let baseURL = Configuration.shared.baseURL
  let apiKey = Configuration.shared.apiKey
  let bscScanToken = Configuration.shared.bscScanToken
  let marketplaceBaseUrl = Configuration.shared.marketplaceBaseURL

  static func processResponse(response: URLResponse?,
                              data: Data?) -> (status: Bool,
                                               statusCode: Int?,
                                               message: String?) {
    let httpResponse = response as? HTTPURLResponse
    if data != nil {
      if httpResponse?.statusCode == 200 {
        do {
          let result = try JSONDecoder().decode(Result.self, from: data!)
          if result.code != "200" {
            if result.code == "1" {
              return(true, 200, result.message)
            } else {
              return(false, Int(result.code ?? "0"), result.message)
            }
          } else {
            return(true, 200, result.message)
          }
        } catch {
          return(false, -1, "Failed To Parse Data From Server")
        }
      } else if httpResponse?.statusCode == 400 {
        let result = try? JSONDecoder().decode(Result.self, from: data!)

        if UIApplication.shared.keyWindow?.rootViewController?.presentedViewController != nil {
          if let userData = DataProvider.shared.keychain.getData("userData") {
            do {
              let user = try? JSONDecoder().decode(User.self, from: userData)
              user?.id = nil
              let userData = try? JSONEncoder().encode(user)
              DataProvider.shared.keychain.set(userData!, forKey: "userData")
            }
          }
          DispatchQueue.main.async {
            UIApplication.shared.keyWindow?.rootViewController?
              .presentedViewController?.children.first?.performSegue(withIdentifier: "SignOut", sender: nil)
          }

        } else if result?.error != "The payload is invalid."{
        }

        return(false, httpResponse?.statusCode, result?.message ?? "Please Enter Your Information To Login Again")
      } else {
        do {
          let result = try JSONDecoder().decode(Result.self, from: data!)
          return(false,
                 httpResponse?.statusCode,
                 "\(result.message ?? "\(String(describing: httpResponse?.statusCode))")")
        } catch {
          return(false, httpResponse?.statusCode, "Error Code: \(httpResponse?.statusCode ?? 0)")
        }
      }
    } else {
      return(false, httpResponse?.statusCode, "SESSION DATA IS NIL")
    }
  }

  static func processResponseETHScan(response: URLResponse?, data: Data?) -> (status: Bool,
                                                                              statusCode: Int?,
                                                                              message: String?) {
    let httpResponse = response as? HTTPURLResponse
    if data != nil {
      if httpResponse?.statusCode == 200 {
        do {
          let result = try JSONDecoder().decode(Result.self, from: data!)
          if result.code != "200" {
            if result.status == "1" {
              return(true, 200, result.message)
            } else {
              return(false, Int(result.status ?? "0"), result.message)
            }
          } else {
            return(true, 200, result.message)
          }
        } catch {
          return(false, -1, "Failed To Parse Data From Server")
        }
      } else if httpResponse?.statusCode == 400 {
        let result = try? JSONDecoder().decode(Result.self, from: data!)

        if UIApplication.shared.keyWindow?.rootViewController?.presentedViewController != nil {
          if let userData = DataProvider.shared.keychain.getData("userData") {
            do {
              let user = try? JSONDecoder().decode(User.self, from: userData)
              user?.id = nil
              let userData = try? JSONEncoder().encode(user)
              DataProvider.shared.keychain.set(userData!, forKey: "userData")
            }
          }
          DispatchQueue.main.async {
            UIApplication.shared.keyWindow?.rootViewController?
              .presentedViewController?.children.first?.performSegue(withIdentifier: "SignOut", sender: nil)
          }

        } else if result?.error != "The payload is invalid."{
          DispatchQueue.main.async {
            UIApplication.shared.keyWindow?.rootViewController?.performSegue(withIdentifier: "goToLogin", sender: nil)
          }
        }

        return(false,
               httpResponse?.statusCode,
               result?.message ?? "Please Enter Your Information To Login Again")
      } else {
        do {
          let result = try JSONDecoder().decode(Result.self, from: data!)
          return(false,
                 httpResponse?.statusCode,
                 "\(result.message ?? "\(String(describing: httpResponse?.statusCode))")")
        } catch {
          return(false, httpResponse?.statusCode, "Error Code: \(httpResponse?.statusCode ?? 0)")
        }
      }
    } else {
      return(false, httpResponse?.statusCode, "SESSION DATA IS NIL")
    }
  }

  func login(email: String,
             password: String,
             completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
    let url = URL(string: baseURL + Endpoints.login)
    print("\(url!)")
    var request = URLRequest(url: url!)
    request.httpMethod = HttpMethod.POST.rawValue
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    request.setValue(apiKey, forHTTPHeaderField: "Api-Key")
    request.httpBody = try? JSONSerialization.data(withJSONObject: ["email": email,
                                                                    "password": password],
                                                   options: .prettyPrinted)

    URLSession.shared.dataTask(with: request, completionHandler: completion)
      .resume()
  }

  func signup(name: String,
              email: String,
              password: String,
              completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
    let url = URL(string: baseURL + Endpoints.register)
    print("\(url!)")
    var request = URLRequest(url: url!)
    request.httpMethod = HttpMethod.POST.rawValue
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    request.setValue(apiKey, forHTTPHeaderField: "Api-Key")
    request.httpBody = try? JSONSerialization.data(withJSONObject: ["name": name.toBase64(),
                                                                    "email": email.toBase64(),
                                                                    "password": password.toBase64()],
                                                   options: .prettyPrinted)

    URLSession.shared.dataTask(with: request, completionHandler: completion)
      .resume()
  }

  func makeTrust(privateKey: String, completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
    let url = URL(string: baseURL + Endpoints.makeTrust)
    print("\(url!)")
    var request = URLRequest(url: url!)
    request.httpMethod = HttpMethod.POST.rawValue
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    request.httpBody = try? JSONSerialization.data(withJSONObject: ["private_key": privateKey,
                                                                    "investor_key": privateKey],
                                                   options: .prettyPrinted)
    URLSession.shared.dataTask(with: request, completionHandler: completion)
      .resume()
  }

  func getTransferOrderDetail(userId: String, completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
    var url = URL(string: baseURL + Endpoints.getTransferOrderDetail)
    url?.appending("user_id", value: userId)
    print("\(url!)")
    var request = URLRequest(url: url!)
    request.httpMethod = HttpMethod.GET.rawValue
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    request.setValue(DataProvider.shared.keychain.get("act") ?? "nil", forHTTPHeaderField: "Authorization")
    URLSession.shared.dataTask(with: request, completionHandler: completion)
      .resume()
  }

  func getOrders(userId: String, completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
    var url = URL(string: baseURL + Endpoints.getOrders)
    url?.appending("user_id", value: userId)
    print("\(url!)")
    var request = URLRequest(url: url!)
    request.httpMethod = HttpMethod.GET.rawValue
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    request.setValue(apiKey, forHTTPHeaderField: "Api-Key")
    request.setValue(LocalDataManager.shared.getTokenField(), forHTTPHeaderField: "Authorization")
    URLSession.shared.dataTask(with: request, completionHandler: completion)
      .resume()
  }

  func getProfile(userId: Int, completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
    var url = URL(string: baseURL + Endpoints.getProfile)
    url?.appending("user_id", value: "\(userId)")
    print("\(url!)")
    var request = URLRequest(url: url!)
    request.httpMethod = HttpMethod.GET.rawValue
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    request.setValue(apiKey, forHTTPHeaderField: "Api-Key")
    request.setValue(LocalDataManager.shared.getTokenField(), forHTTPHeaderField: "Authorization")
    URLSession.shared.dataTask(with: request, completionHandler: completion)
      .resume()
  }

  func getExchangeRate(completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
    let url = URL(string: baseURL + Endpoints.getExchangeRate)
    print("\(url!)")
    var request = URLRequest(url: url!)
    request.httpMethod = HttpMethod.GET.rawValue
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    request.setValue(LocalDataManager.shared.getTokenField(), forHTTPHeaderField: "Authorization")
    URLSession.shared.dataTask(with: request, completionHandler: completion)
      .resume()
  }
  func getL2LExchangeRate(completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
    let url = URL(string: baseURL + Endpoints.L2LExchangeRate)
    print("\(url!)")
    var request = URLRequest(url: url!)
    request.httpMethod = HttpMethod.GET.rawValue
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    request.setValue(LocalDataManager.shared.getTokenField(), forHTTPHeaderField: "Authorization")
    URLSession.shared.dataTask(with: request, completionHandler: completion)
      .resume()
  }
  /*
   func addOrder(userId: Int,
   quantity: Double,
   currency: String,
   amount: Double,
   status: String,
   date: String,
   paymentType: String,
   l2lQuantity: Double,
   completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
   let url = URL(string: baseURL + Endpoints.addOrder)
   print("\(url!)")
   var request = URLRequest(url: url!)
   request.httpMethod = HttpMethod.POST.rawValue
   request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
   request.setValue(LocalDataManager.shared.getTokenField(), forHTTPHeaderField: "Authorization")
   let parameters = "user_id=\(userId)&quantity=\(quantity)&
   currency=\(currency)&requestor=mobile&amount=\(amount)&payment_type=\(paymentType)&ltwol_tokens=\(l2lQuantity)&status=\(status)&date=\(date)"
   request.httpBody = parameters.data(using: .utf8, allowLossyConversion: true)
   URLSession.shared.dataTask(with: request, completionHandler: completion)
   .resume()
   }*/

  func mollie(userId: Int,
              quantity: Double,
              currency: String,
              amount: Double,
              paymentType: String,
              l2lQuantity: Double,
              completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
    let url = URL(string: baseURL + Endpoints.mobile)
    print("\(url!)")
    var request = URLRequest(url: url!)
    request.httpMethod = HttpMethod.POST.rawValue
    request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
    request.setValue(LocalDataManager.shared.getTokenField(), forHTTPHeaderField: "Authorization")
    let parameters = "user_id=\(userId)&quantity=\(quantity)&currency=\(currency)" +
    "&requestor=mobile&amount=\(amount)" +
    "&payment_type=\(paymentType)&ltwol_tokens=\(l2lQuantity)"
    request.httpBody = parameters.data(using: .utf8, allowLossyConversion: true)
    URLSession.shared.dataTask(with: request, completionHandler: completion)
      .resume()
  }

  func checkTrust(publicKey: String, issuer: String, completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
    let url = URL(string: "http://secured.2local.io:5500/" + "api/main/checkTrust")

    print("\(url!)")
    var request = URLRequest(url: url!)
    request.httpMethod = HttpMethod.POST.rawValue
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    request.setValue(LocalDataManager.shared.getTokenField(), forHTTPHeaderField: "Authorization")
    request.httpBody = try? JSONSerialization.data(withJSONObject: ["account_id": publicKey, "issuer": issuer], options: .prettyPrinted)
    URLSession.shared.dataTask(with: request, completionHandler: completion)
      .resume()
  }

  func transfer(amount: String, walletNumber: String, completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
    let url = URL(string: baseURL + Endpoints.transferOrder)
    print("\(url!)")
    var request = URLRequest(url: url!)
    request.httpMethod = HttpMethod.POST.rawValue
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    request.setValue(LocalDataManager.shared.getTokenField(), forHTTPHeaderField: "Authorization")
    request.httpBody = try? JSONSerialization.data(withJSONObject: ["receiving_keys": walletNumber,
                                                                    "amount": amount,
                                                                    "source": "Out",
                                                                    "status": "open",
                                                                    "user_id": ((DataProvider.shared.user?.id)!)], options: .prettyPrinted)
    URLSession.shared.dataTask(with: request, completionHandler: completion)
      .resume()
  }

  func getBalance(publicKey: String,
                  email: String,
                  completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
    let url = URL(string: baseURL + "order/get-balance")

    print("\(url!)")
    var request = URLRequest(url: url!)
    request.httpMethod = HttpMethod.POST.rawValue
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    request.setValue(LocalDataManager.shared.getTokenField(), forHTTPHeaderField: "Authorization")
    request.httpBody = try? JSONSerialization.data(withJSONObject: ["public_key": publicKey, "email": email], options: .prettyPrinted)
    URLSession.shared.dataTask(with: request, completionHandler: completion)
      .resume()
  }

  func verifyTwoVerification(code: String, completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
    let url = URL(string: baseURL + Endpoints.validate)
    print("\(url!)")
    var request = URLRequest(url: url!)
    request.httpMethod = HttpMethod.POST.rawValue
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    request.setValue(LocalDataManager.shared.getTokenField(), forHTTPHeaderField: "Authorization")
    request.httpBody = try? JSONSerialization.data(withJSONObject: ["code": code,
                                                                    "user_id": ("\(DataProvider.shared.user?.id ?? -1)")],
                                                   options: .prettyPrinted)
    URLSession.shared.dataTask(with: request, completionHandler: completion)
      .resume()
  }

  func updateProfile(parameter: String, completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
    let url = URL(string: baseURL + Endpoints.updateProfile)
    print("\(url!)")
    var request = URLRequest(url: url!)
    request.httpMethod = HttpMethod.POST.rawValue
    request.setValue(apiKey, forHTTPHeaderField: "Api-Key")
    request.setValue(LocalDataManager.shared.getTokenField(), forHTTPHeaderField: "Authorization")
    request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
    request.httpBody = parameter.data(using: .utf8, allowLossyConversion: true)
    URLSession.shared.dataTask(with: request, completionHandler: completion)
      .resume()
  }

  func addMarketplace(companyName: String,
                      website: String,
                      location: CLLocationCoordinate2D,
                      completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
    let url = URL(string: marketplaceBaseUrl + Endpoints.createCompany)
    print("\(url!)")
    var request = URLRequest(url: url!)
    request.httpMethod = HttpMethod.POST.rawValue
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    request.setValue(LocalDataManager.shared.getTokenField(), forHTTPHeaderField: "Authorization")
    request.httpBody = try? JSONSerialization.data(withJSONObject: ["company_name": companyName,
                                                                    "website_url": website,
                                                                    "latitude": location.latitude.description,
                                                                    "longitude": location.longitude.description,
                                                                    "status": "available",
                                                                    "reserve": "reserve"],
                                                   options: .prettyPrinted)
    URLSession.shared.dataTask(with: request, completionHandler: completion)
      .resume()
  }

  func getMarketplaces(completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
    let url = URL(string: marketplaceBaseUrl + Endpoints.getCompany)
    print("\(url!)")
    var request = URLRequest(url: url!)
    request.httpMethod = HttpMethod.GET.rawValue
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    request.setValue(LocalDataManager.shared.getTokenField(), forHTTPHeaderField: "Authorization")
    URLSession.shared.dataTask(with: request, completionHandler: completion)
      .resume()
  }

  func getETHTransactionStatus(receiveAddress: String, completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
    let url = URL(string: "\(Configuration.shared.ethscanUrl)?module=account&action=txlist&apikey=\(Configuration.shared.ethscanToken)&address=\(receiveAddress)")
    print("\(url!)")
    var request = URLRequest(url: url!)
    request.httpMethod = HttpMethod.GET.rawValue
    URLSession.shared.dataTask(with: request, completionHandler: completion)
      .resume()
  }

  func getBSCTransaction(address: String,
                         contractAddress: String,
                         action: String,
                         completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
    let url = URL(string: "\(Configuration.shared.bscScanUrl)?module=account&action=\(action)&apikey=\(bscScanToken)&address=\(address)\(contractAddress)&sort=desc&page=1&offset=100")
    print("\(url!)")
    var request = URLRequest(url: url!)
    request.httpMethod = HttpMethod.GET.rawValue
    URLSession.shared.dataTask(with: request, completionHandler: completion)
      .resume()
  }

  func getGasPrice(completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
    let url = URL(string: "\(Configuration.shared.ethscanUrl)?module=gastracker&action=gasoracle&apikey=\(Configuration.shared.ethscanToken)")
    print("\(url!)")
    var request = URLRequest(url: url!)
    request.httpMethod = HttpMethod.GET.rawValue
    URLSession.shared.dataTask(with: request, completionHandler: completion)
      .resume()
  }

  func getBSCGasPrice(completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
    let url = URL(string: "\(Configuration.shared.bscScanUrlTestnet)?module=proxy&action=eth_gasPrice&apikey=YourApiKeyToken")
    print("\(url!)")
    var request = URLRequest(url: url!)
    request.httpMethod = HttpMethod.GET.rawValue
    URLSession.shared.dataTask(with: request, completionHandler: completion)
      .resume()
  }

  func getFee(of symbol: String, completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
    var stringUrl = "\(Configuration.shared.bitrueUrl)v1/ticker/price?symbol=\(symbol)USDT"
    if symbol == Coins.tLocal.symbol() {
      stringUrl = "\(Configuration.shared.laTokenBaseUrl)v2/ticker/\(Configuration.shared.tlcBaseCurrency)/\(Configuration.shared.tlcQuoteCurrency)"
    }

    let url = URL(string: stringUrl)
    print("\(url!)")
    var request = URLRequest(url: url!)
    request.httpMethod = HttpMethod.GET.rawValue
    URLSession.shared.dataTask(with: request, completionHandler: completion)
      .resume()
  }
}
