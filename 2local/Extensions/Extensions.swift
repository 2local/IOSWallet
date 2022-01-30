//
//  Extensions.swift
//  2local
//
//  Created by Hasan Sedaghat on 12/28/19.
//  Copyright © 2019 2local Inc. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    func transparentNavigationBar() {
        UINavigationBar.appearance().isTranslucent = true
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()

    }

    func shadowNavigationBar() {
        self.navigationController?.navigationBar.layer.masksToBounds = false
        self.navigationController?.navigationBar.layer.shadowColor = UIColor.black.cgColor
        self.navigationController?.navigationBar.layer.shadowOpacity = 0.5
        self.navigationController?.navigationBar.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        self.navigationController?.navigationBar.layer.shadowRadius = 2
    }
}

extension UIPageControl {
    func customPageControl(dotFillColor: UIColor, dotBorderColor: UIColor, dotBorderWidth: CGFloat) {
        for (pageIndex, dotView) in self.subviews.enumerated() {
            if self.currentPage == pageIndex {

                dotView.backgroundColor = dotFillColor
                dotView.layer.cornerRadius = dotView.frame.size.height / 2
            } else {
                dotView.backgroundColor = .clear
                dotView.layer.cornerRadius = dotView.frame.size.height / 2
                dotView.layer.borderColor = dotBorderColor.cgColor
                dotView.layer.borderWidth = dotBorderWidth
            }
        }
    }
}

extension UIView {
    func roundCorners(corners: UIRectCorner, radius: CGFloat ) {

        let maskPath1 = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let maskLayer1 = CAShapeLayer()
        maskLayer1.frame = bounds
        maskLayer1.path = maskPath1.cgPath
        layer.mask = maskLayer1

    }

    func setShadow(color: UIColor, opacity: Float, offset: CGSize, radius: CGFloat) {
        self.layer.masksToBounds = false
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOpacity = opacity
        self.layer.shadowOffset = offset
        self.layer.shadowRadius = radius
    }

    func roundCornersWithShadow(corners: UIRectCorner, radius: CGFloat, shadowColor: UIColor, shadowOpacity: Float, shadowOffset: CGSize, shadowRadius: CGFloat) {

        let maskPath = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))// .cgPath
        let myLayer = CAShapeLayer()
        myLayer.frame = bounds
        myLayer.path = maskPath.cgPath
        self.layer.mask = myLayer

        myLayer.shadowPath = myLayer.path
        myLayer.shadowColor = shadowColor.cgColor
        myLayer.shadowOffset = shadowOffset
        myLayer.shadowOpacity = shadowOpacity
        myLayer.shadowRadius = shadowRadius

        layer.insertSublayer(myLayer, at: 0)
    }

    func tapToDismissKeyboard() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        tapGesture.cancelsTouchesInView = false
        self.addGestureRecognizer(tapGesture)
    }

    @objc func hideKeyboard() {
        self.endEditing(true)
    }
}

extension UICollectionView {
    func scrollToNearestVisibleCollectionViewCell() -> Int {
        self.decelerationRate = UIScrollView.DecelerationRate.fast
        let visibleCenterPositionOfScrollView = Float(self.contentOffset.x + (self.bounds.size.width / 2))
        var closestCellIndex = -1
        var closestDistance: Float = .greatestFiniteMagnitude
        for index in 0..<self.visibleCells.count {
            let cell = self.visibleCells[index]
            let cellWidth = cell.bounds.size.width
            let cellCenter = Float(cell.frame.origin.x + cellWidth / 2)

            // Now calculate closest cell
            let distance: Float = fabsf(visibleCenterPositionOfScrollView - cellCenter)
            if distance < closestDistance {
                closestDistance = distance
                closestCellIndex = self.indexPath(for: cell)!.row
            }
        }
        if closestCellIndex != -1 {
            self.scrollToItem(at: IndexPath(row: closestCellIndex, section: 0), at: .centeredHorizontally, animated: true)
            return closestCellIndex
        }
        return 0
    }
    func currentIndexPath() -> IndexPath {
        var visibleRect = CGRect()
        visibleRect.origin = self.contentOffset
        visibleRect.size = self.bounds.size
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        guard let indexPath = self.indexPathForItem(at: visiblePoint) else {
            return IndexPath(row: 0, section: 0)
        }
        return indexPath
    }
}

extension UIFont {

    func bold() -> UIFont {
        var symTraits = fontDescriptor.symbolicTraits
        symTraits.insert([.traitBold])
        let fontDescriptorVar = fontDescriptor.withSymbolicTraits(symTraits)
        return UIFont(descriptor: fontDescriptorVar!, size: 0)
    }
}

extension Sequence {
    func group<GroupingType: Hashable>(by key: (Iterator.Element) -> GroupingType) -> [[Iterator.Element]] {
        var groups: [GroupingType: [Iterator.Element]] = [:]
        var groupsOrder: [GroupingType] = []
        forEach { element in
            let key = key(element)
            if case nil = groups[key]?.append(element) {
                groups[key] = [element]
                groupsOrder.append(key)
            }
        }
        return groupsOrder.map { groups[$0]! }
    }
}

extension UITextField {
    func setPlaceholder(text: String, color: UIColor, font: UIFont) {
        self.attributedPlaceholder = NSAttributedString(string: text, attributes: [NSAttributedString.Key.foregroundColor: color, NSAttributedString.Key.font: font])
    }
}

extension UIScrollView {
    func handleKeyboard() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    @objc func keyboardWillShow(notification: NSNotification) {
      let keyboardFrame: CGRect = (notification.userInfo![UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?
        .cgRectValue ?? .init(x: 0, y: 0, width: 0, height: 0)
        var contentInset: UIEdgeInsets = self.contentInset
        contentInset.bottom = 50
        self.contentInset = contentInset
        self.setContentOffset(CGPoint(x: 0, y: self.contentInset.bottom ), animated: false)
        UIView.animate(withDuration: 1, animations: {
            // self.layoutIfNeeded()
        }, completion: nil)
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        self.contentInset.bottom = CGFloat(0)
    }

}

extension UITableView {
    func setBackgroundView(imageName: UIImage, labelText: String, labelColor: UIColor) {
        DispatchQueue.main.async {
            let superView = UIView(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
            let backgoundImage = UIImageView()
            backgoundImage.frame.size = CGSize(width: 110, height: 110)
            backgoundImage.center.x = superView.center.x
            backgoundImage.center.y = superView.center.y - 110
            backgoundImage.contentMode = .scaleAspectFit
            backgoundImage.image = imageName
            superView.addSubview(backgoundImage)
            let backgroundLabel = UILabel()
            backgroundLabel.frame.size = CGSize(width: superView.frame.width - 60, height: 30)
            backgroundLabel.center.x = superView.center.x
            backgroundLabel.frame.origin.y = backgoundImage.frame.origin.y + backgoundImage.frame.height + 10
            backgroundLabel.font = .TLFont(weight: .vazirFD,
                                           size: 16)
            backgroundLabel.text = labelText
            backgroundLabel.textAlignment = .center
            backgroundLabel.textColor = labelColor
            superView.addSubview(backgroundLabel)
            UIView.transition(with: self, duration: 0.2, options: [.transitionCrossDissolve], animations: {
                self.backgroundView = superView
            }, completion: nil)
        }
    }
    func setBackgroundImage(imageName: UIImage) {
        DispatchQueue.main.async {
            let superView = UIView(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
            let backgoundImage = UIImageView()
            backgoundImage.frame.size = CGSize(width: 110, height: 110)
            backgoundImage.center.x = superView.center.x
            backgoundImage.center.y = superView.center.y - 50
            backgoundImage.contentMode = .scaleAspectFit
            backgoundImage.image = imageName
            superView.addSubview(backgoundImage)
            UIView.transition(with: self, duration: 0.2, options: [.transitionCrossDissolve], animations: {
                self.backgroundView = superView
            }, completion: nil)
        }
    }

    func setBackgroundLabel(labelText: String, labelColor: UIColor, font: UIFont) {
        DispatchQueue.main.async {
            let superView = UIView(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
            let backgroundLabel = UILabel()
            backgroundLabel.frame.size = CGSize(width: superView.frame.width - 60, height: 90)
            backgroundLabel.center.x = superView.center.x
            backgroundLabel.frame.origin.y = superView.center.y - 45
            backgroundLabel.font = font
            backgroundLabel.text = labelText
            backgroundLabel.textAlignment = .center
            backgroundLabel.textColor = labelColor
            backgroundLabel.numberOfLines = 0
            superView.addSubview(backgroundLabel)
            UIView.transition(with: self, duration: 0.2, options: [.transitionCrossDissolve], animations: {
                self.backgroundView = superView
            }, completion: nil)
        }
    }

    func removeBackgroundView() {
        UIView.transition(with: self, duration: 0.2, options: [.transitionCrossDissolve], animations: {
            self.backgroundView = nil
        }, completion: nil)
    }
}

extension UICollectionView {
    func setBackgroundView(imageName: UIImage, labelText: String, labelColor: UIColor, font: UIFont) {
        DispatchQueue.main.async {
            let superView = UIView(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
            let backgoundImage = UIImageView()
            backgoundImage.frame.size = CGSize(width: 110, height: 110)
            backgoundImage.center.x = superView.center.x
            backgoundImage.center.y = superView.center.y - 110
            backgoundImage.contentMode = .scaleAspectFit
            backgoundImage.image = imageName
            superView.addSubview(backgoundImage)
            let backgroundLabel = UILabel()
            backgroundLabel.frame.size = CGSize(width: superView.frame.width - 60, height: 30)
            backgroundLabel.center.x = superView.center.x
            backgroundLabel.frame.origin.y = backgoundImage.frame.origin.y + backgoundImage.frame.height + 10
            backgroundLabel.font = font
            backgroundLabel.text = labelText
            backgroundLabel.textAlignment = .center
            backgroundLabel.textColor = labelColor
            superView.addSubview(backgroundLabel)
            UIView.transition(with: self, duration: 0.2, options: [.transitionCrossDissolve], animations: {
                self.backgroundView = superView
            }, completion: nil)
        }
    }
    func setBackgroundImage(imageName: UIImage, size: CGSize) {
        DispatchQueue.main.async {
            let superView = UIView(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
            let backgoundImage = UIImageView()
            backgoundImage.frame.size = size
            backgoundImage.center.x = superView.center.x
            backgoundImage.center.y = superView.center.y
            backgoundImage.contentMode = .scaleAspectFit
            backgoundImage.image = imageName
            superView.addSubview(backgoundImage)
            UIView.transition(with: self, duration: 0.2, options: [.transitionCrossDissolve], animations: {
                self.backgroundView = superView
            }, completion: nil)
        }
    }

    func setBackgroundLabel(labelText: String, labelColor: UIColor, font: UIFont) {
        DispatchQueue.main.async {
            let superView = UIView(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
            let backgroundLabel = UILabel()
            backgroundLabel.frame.size = CGSize(width: superView.frame.width - 60, height: 90)
            backgroundLabel.center.x = superView.center.x
            backgroundLabel.frame.origin.y = superView.center.y - 45
            backgroundLabel.font = font
            backgroundLabel.text = labelText
            backgroundLabel.textAlignment = .center
            backgroundLabel.textColor = labelColor
            backgroundLabel.numberOfLines = 0
            superView.addSubview(backgroundLabel)
            UIView.transition(with: self, duration: 0.2, options: [.transitionCrossDissolve], animations: {
                self.backgroundView = superView
            }, completion: nil)
        }
    }

    func removeBackgroundView() {
        UIView.transition(with: self, duration: 0.2, options: [.transitionCrossDissolve], animations: {
            self.backgroundView = nil
        }, completion: nil)
    }
}

extension UILabel {
    func decimalFormat() {
        let formatter = NumberFormatter()
        formatter.groupingSeparator = ","
        formatter.numberStyle = .decimal
        let number = formatter.number(from: self.text!)
        let stringNumber = formatter.string(from: number ?? 0)
        self.text = stringNumber
    }
    var numberOfVisibleLines: Int {
        let textSize = CGSize(width: CGFloat(self.frame.size.width), height: CGFloat(MAXFLOAT))
        let rHeight: Int = lroundf(Float(self.sizeThatFits(textSize).height))
        let charSize: Int = lroundf(Float(self.font.pointSize))
        return rHeight / charSize
    }
}

extension String {
    func toEnglishFormat() -> String {
        let formatter = NumberFormatter()
        formatter.locale = Locale(identifier: "EN")
        let number = formatter.number(from: self)
        var stringNumber = formatter.string(from: number ?? 0)!
        if self.count > stringNumber.count {
            stringNumber = "0" + stringNumber
        }
        stringNumber = stringNumber.replacingOccurrences(of: " ", with: "")
        return stringNumber
    }
    func weekdayFromDate(dateFormat: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        if let date = dateFormatter.date(from: self) {

            let weekDay = dateFormatter.weekdaySymbols[Calendar.current.component(.weekday, from: date) - 1]
            return weekDay
        } else {
            return "nil"
        }
    }

    func dayNumberOfWeek() -> Int? {
        return Calendar.current.dateComponents([.weekday], from: self.toDate(format: "yyyy-MM-dd")).weekday
    }

    var asDate: Date {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        formatter.timeZone = TimeZone.init(abbreviation: "GMT")
        return formatter.date(from: self)!
    }

    func toDate(format: String) -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.timeZone = TimeZone.init(abbreviation: "GMT")
        return formatter.date(from: self)!
    }

    func getCleanedURL() -> URL? {
        guard self.isEmpty == false else {
            return nil
        }
        if let url = URL(string: self) {
            return url
        } else {
            if let urlEscapedString = self.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed), let escapedURL = URL(string: urlEscapedString) {
                return escapedURL
            }
        }
        return nil
    }

    func convertToPriceType() -> String {
        let formatter = NumberFormatter()
        formatter.groupingSeparator = ","
        formatter.numberStyle = .decimal
        if let number = formatter.number(from: self) {
            if let stringNumber = formatter.string(from: number) {
                return stringNumber
            } else {
                return self
            }
        } else {
            return self
        }
    }
    func toBase64() -> String {
        return Data(self.utf8).base64EncodedString()
    }
}

extension URL {

    mutating func appending(_ queryItem: String, value: String?) {
        var urlComponents = URLComponents(string: absoluteString)
        var queryItems: [URLQueryItem] = urlComponents?.queryItems ??  []
        let queryItem = URLQueryItem(name: queryItem, value: value)
        queryItems.append(queryItem)
        urlComponents?.queryItems = queryItems
        self = urlComponents!.url ?? URL(string: "")!
    }
}

extension UIApplication {

    var screenShot: UIImage? {
        return keyWindow?.layer.screenShot
    }
}

extension CALayer {

    var screenShot: UIImage? {
        let scale = UIScreen.main.scale
        UIGraphicsBeginImageContextWithOptions(frame.size, false, scale)
        if let context = UIGraphicsGetCurrentContext() {
            render(in: context)
            let screenshot = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return screenshot
        }
        return nil
    }
}

extension Date {
    func daysFrom(date: Date) -> Int? {
        return Calendar.current.dateComponents([.day], from: date, to: self).day
    }
    func convertToTimeZone(initTimeZone: TimeZone, timeZone: TimeZone) -> Date {
        let delta = TimeInterval(timeZone.secondsFromGMT() - initTimeZone.secondsFromGMT())
        return addingTimeInterval(delta)
    }

    func getWeekDates() -> [Date] {
        var arrThisWeek: [Date] = []
        for index in 0..<7 {
            arrThisWeek.append(Calendar.current.date(byAdding: .day, value: index, to: self.startOfWeek!)!)
        }
        return arrThisWeek
    }

    var getLast12Month: ([String], [String]) {
        let dates = (-11...0).compactMap { Calendar.current.date(byAdding: .month, value: $0, to: self)}

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM"

        let months = dates.map { dateFormatter.string(from: $0)}

        dateFormatter.dateFormat = "yyyy-MM"
        let finalDates = dates.map { dateFormatter.string(from: $0)}

        return (months, finalDates)
    }

    var startOfWeek: Date? {
        let gregorian = Calendar(identifier: .gregorian)
        guard let sunday = gregorian.date(from: gregorian.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)) else { return nil }
        return gregorian.date(byAdding: .day, value: 1, to: sunday)
    }

    var endOfWeek: Date? {
        let gregorian = Calendar(identifier: .gregorian)
        guard let sunday = gregorian.date(from: gregorian.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)) else { return nil }
        return gregorian.date(byAdding: .day, value: 7, to: sunday)
    }
}

extension Int {

    func toPersianNumberWords() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .spellOut
        formatter.locale = Locale(identifier: "fa_IR")
        var plainText = ""
        plainText = formatter.string(from: (self as NSNumber))! + "م"
        plainText = plainText.replacingOccurrences(of: "سهم", with: "سوم")
        return plainText
    }

    func secondsToHoursMinutesSeconds() -> (Int, Int, Int) {
        return (self / 3600, (self % 3600) / 60, (self % 3600) % 60)
    }
}

extension UIDevice {

    var modelName: String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }

        switch identifier {
            case "iPod5,1":                                 return "iPod touch (5th generation)"
            case "iPod7,1":                                 return "iPod touch (6th generation)"
            case "iPod9,1":                                 return "iPod touch (7th generation)"
            case "iPhone3,1", "iPhone3,2", "iPhone3,3":     return "iPhone 4"
            case "iPhone4,1":                               return "iPhone 4s"
            case "iPhone5,1", "iPhone5,2":                  return "iPhone 5"
            case "iPhone5,3", "iPhone5,4":                  return "iPhone 5c"
            case "iPhone6,1", "iPhone6,2":                  return "iPhone 5s"
            case "iPhone7,2":                               return "iPhone 6"
            case "iPhone7,1":                               return "iPhone 6 Plus"
            case "iPhone8,1":                               return "iPhone 6s"
            case "iPhone8,2":                               return "iPhone 6s Plus"
            case "iPhone8,4":                               return "iPhone SE"
            case "iPhone9,1", "iPhone9,3":                  return "iPhone 7"
            case "iPhone9,2", "iPhone9,4":                  return "iPhone 7 Plus"
            case "iPhone10,1", "iPhone10,4":                return "iPhone 8"
            case "iPhone10,2", "iPhone10,5":                return "iPhone 8 Plus"
            case "iPhone10,3", "iPhone10,6":                return "iPhone X"
            case "iPhone11,2":                              return "iPhone XS"
            case "iPhone11,4", "iPhone11,6":                return "iPhone XS Max"
            case "iPhone11,8":                              return "iPhone XR"
            case "iPhone12,1":                              return "iPhone 11"
            case "iPhone12,3":                              return "iPhone 11 Pro"
            case "iPhone12,5":                              return "iPhone 11 Pro Max"
            case "iPhone12,8":                              return "iPhone SE (2nd generation)"
            case "iPhone13,1":                              return "iPhone 12 mini"
            case "iPhone13,2":                              return "iPhone 12"
            case "iPhone13,3":                              return "iPhone 12 Pro"
            case "iPhone13,4":                              return "iPhone 12 Pro Max"
            case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":return "iPad 2"
            case "iPad3,1", "iPad3,2", "iPad3,3":           return "iPad (3rd generation)"
            case "iPad3,4", "iPad3,5", "iPad3,6":           return "iPad (4th generation)"
            case "iPad6,11", "iPad6,12":                    return "iPad (5th generation)"
            case "iPad7,5", "iPad7,6":                      return "iPad (6th generation)"
            case "iPad7,11", "iPad7,12":                    return "iPad (7th generation)"
            case "iPad11,6", "iPad11,7":                    return "iPad (8th generation)"
            case "iPad4,1", "iPad4,2", "iPad4,3":           return "iPad Air"
            case "iPad5,3", "iPad5,4":                      return "iPad Air 2"
            case "iPad11,3", "iPad11,4":                    return "iPad Air (3rd generation)"
            case "iPad13,1", "iPad13,2":                    return "iPad Air (4th generation)"
            case "iPad2,5", "iPad2,6", "iPad2,7":           return "iPad mini"
            case "iPad4,4", "iPad4,5", "iPad4,6":           return "iPad mini 2"
            case "iPad4,7", "iPad4,8", "iPad4,9":           return "iPad mini 3"
            case "iPad5,1", "iPad5,2":                      return "iPad mini 4"
            case "iPad11,1", "iPad11,2":                    return "iPad mini (5th generation)"
            case "iPad6,3", "iPad6,4":                      return "iPad Pro (9.7-inch)"
            case "iPad7,3", "iPad7,4":                      return "iPad Pro (10.5-inch)"
            case "iPad8,1", "iPad8,2", "iPad8,3", "iPad8,4":return "iPad Pro (11-inch) (1st generation)"
            case "iPad8,9", "iPad8,10":                     return "iPad Pro (11-inch) (2nd generation)"
            case "iPad6,7", "iPad6,8":                      return "iPad Pro (12.9-inch) (1st generation)"
            case "iPad7,1", "iPad7,2":                      return "iPad Pro (12.9-inch) (2nd generation)"
            case "iPad8,5", "iPad8,6", "iPad8,7", "iPad8,8":return "iPad Pro (12.9-inch) (3rd generation)"
            case "iPad8,11", "iPad8,12":                    return "iPad Pro (12.9-inch) (4th generation)"
            case "AppleTV5,3":                              return "Apple TV"
            case "AppleTV6,2":                              return "Apple TV 4K"
            case "AudioAccessory1,1":                       return "HomePod"
            case "i386", "x86_64":                          return "Simulator"
            default:                                        return identifier
        }
    }
}
