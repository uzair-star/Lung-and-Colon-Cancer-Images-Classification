//
//  PExtensions.swift
//  Plancky
//
//  Created by Usama on 03/02/2021.
//  Copyright © 2021 nketc. All rights reserved.
//

import UIKit
import Foundation
import SystemConfiguration
import MapKit

//MARK:- Encryption Decryption
//MARK:- Globals

private var rightViews = NSMapTable<UITextField, UIView>(keyOptions: NSPointerFunctions.Options.weakMemory, valueOptions: NSPointerFunctions.Options.strongMemory)
private var errorViews = NSMapTable<UITextField, UIView>(keyOptions: NSPointerFunctions.Options.weakMemory, valueOptions: NSPointerFunctions.Options.strongMemory)

func pToDateTimeForChat(dateString: String) -> Date {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
    return dateFormatter.date(from: dateString) ?? Date()
}

func pTimeAgoSinceDate(_ date:Date,currentDate:Date = NSDate() as Date, numericDates:Bool) -> String {
    let calendar = Calendar.current
    let now = currentDate
    let earliest = (now as NSDate).earlierDate(date)
    let latest = (earliest == now) ? date : now
    let components:DateComponents = (calendar as NSCalendar).components([NSCalendar.Unit.minute , NSCalendar.Unit.hour , NSCalendar.Unit.day , NSCalendar.Unit.weekOfYear , NSCalendar.Unit.month , NSCalendar.Unit.year , NSCalendar.Unit.second], from: earliest, to: latest, options: NSCalendar.Options())
    
    if (components.year! >= 2) {
        return "\(components.year!) years ago"
    } else if (components.year! >= 1){
        if (numericDates){
            return "1 year ago"
        } else {
            return "Last year"
        }
    } else if (components.month! >= 2) {
        return "\(components.month!) months ago"
    } else if (components.month! >= 1){
        if (numericDates){
            return "1 month ago"
        } else {
            return "Last month"
        }
    } else if (components.weekOfYear! >= 2) {
        return "\(components.weekOfYear!) weeks ago"
    } else if (components.weekOfYear! >= 1){
        if (numericDates){
            return "1 week ago"
        } else {
            return "Last week"
        }
    } else if (components.day! >= 2) {
        return "\(components.day!) days ago"
    } else if (components.day! >= 1){
        if (numericDates){
            return "1 day ago"
        } else {
            return "Yesterday"
        }
    } else if (components.hour! >= 2) {
        return "\(components.hour!) hours ago"
    } else if (components.hour! >= 1){
        if (numericDates){
            return "1 hour ago"
        } else {
            return "An hour ago"
        }
    } else if (components.minute! >= 2) {
        return "\(components.minute!) minutes ago"
    } else if (components.minute! >= 1){
        if (numericDates){
            return "1 minute ago"
        } else {
            return "A minute ago"
        }
    } else if (components.second! >= 3) {
        return "\(components.second!) seconds ago"
    } else {
        return "Just now"
    }
    
}


func pToDateTime(dateString: String) -> Date
{
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
    return dateFormatter.date(from: dateString)!
}



//MARK:- VIEW
extension UIView {
    func pSetShadowWithColor(color: UIColor = .black, opacity: Float = 0.8, offset: CGSize = .zero, radius: CGFloat = 2.0, viewCornerRadius: CGFloat?) {
        //layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: viewCornerRadius ?? 0.0).CGPath
        layer.cornerRadius = viewCornerRadius ?? 6.0
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = offset
        layer.shadowRadius = radius
    }
    @IBInspectable var round: Bool {
        get {
            return true
        }
        set {
            layer.cornerRadius = newValue ?  frame.height / 2 : 0
            layer.masksToBounds = newValue
        }
    }
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    
    @IBInspectable var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable var borderColor: UIColor? {
        get {
            return UIColor(cgColor: layer.borderColor!)
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }
    class func pFromNib<T: UIView>() -> T {
        return Bundle(for: T.self).loadNibNamed(String(describing: T.self), owner: nil, options: nil)![0] as! T
    }
    func pAddDropShadow() {
        layer.shadowColor = UIColor.lightGray.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 3.0)
        layer.shadowOpacity = 0.4
        layer.shadowRadius = 5.0
        layer.masksToBounds = false
    }
    func pAddDropShadowLight() {
        layer.shadowColor = UIColor.lightGray.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 1.5)
        layer.shadowOpacity = 0.2
        layer.shadowRadius = 2.5
        layer.masksToBounds = false
    }
    
    func pSlightRound(radius: CGFloat) {
        self.layer.cornerRadius = radius
        self.clipsToBounds = true
    }
    
    func pRoundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
//    func fadeIn(duration: TimeInterval = 0.75) {
//        UIView.animate(withDuration: duration, animations: {
//            self.alpha = 1.0
//        })
//    }
    
//    func fadeOut(duration: TimeInterval = 0.5) {
//        UIView.animate(withDuration: duration, animations: {
//            self.alpha = 0.0
//        })
//    }
//
//    func blink(numberOfFlashes: Float = 10000) {
//        let flash = CABasicAnimation(keyPath: "opacity")
//        flash.duration = 0.2
//        flash.fromValue = 1
//        flash.toValue = 0.1
//        flash.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)//CAMediaTimingFunctionName.easeInEaseOut)
//        flash.autoreverses = true
//        flash.repeatCount = numberOfFlashes
//        layer.add(flash, forKey: nil)
//    }
    
    func pShake() {
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        animation.duration = 0.6
        animation.values = [-20.0, 20.0, -20.0, 20.0, -10.0, 10.0, -5.0, 5.0, 0.0 ]
        layer.add(animation, forKey: "shake")
    }
    public func pMakeRounded(){
        self.clipsToBounds = true
        self.layer.cornerRadius = self.bounds.height / 2
    }
    func pDropShadow(scale: Bool = true) {
        let radius: CGFloat = self.frame.width / 2.0 //change it to .height if you need spread for height
        let shadowPath = UIBezierPath(rect: CGRect(x: 0, y: 0, width: 2.1 * radius, height: self.frame.height))
        //Change 2.1 to amount of spread you need and for height replace the code for height
        
        self.layer.cornerRadius = 0
        self.layer.shadowColor = UIColor.lightGray.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 0.2)  //Here you control x and y
        self.layer.shadowOpacity = 0.2
        self.layer.shadowRadius = 5.0 //Here your control your blur
        self.layer.masksToBounds =  false
        self.layer.shadowPath = shadowPath.cgPath
    }
    public func pSetBorder(width:CGFloat = 0.5,color:UIColor = .themeDarkBlue) {
        
        self.layer.borderWidth = width
        self.layer.borderColor = color.cgColor
    }
//    public func rounded() {
//        let width = bounds.width < bounds.height ? bounds.width : bounds.height
//        let mask = CAShapeLayer()
//        mask.path = UIBezierPath(ovalIn: CGRect(x: bounds.midX - width / 2, y: bounds.midY - width / 2, width: width, height: width)).cgPath
//        self.layer.mask = mask
//    }
    
//    func shake(count : Float? = nil,for duration : TimeInterval? = nil,withTranslation translation : Float? = nil) {
//        let animation : CABasicAnimation = CABasicAnimation(keyPath: "transform.translation.x")
//        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
//        animation.repeatCount = count ?? Float(Double.infinity)
//        animation.duration = 1//(duration ?? 1000)/TimeInterval(animation.repeatCount)
//        animation.autoreverses = true
//        animation.byValue = translation ?? -5
//        layer.add(animation, forKey: "shake")
//    }
    
    func pSetRounded(color:UIColor) {
        
        self.layer.cornerRadius = 10
        self.clipsToBounds = true
        self.layer.borderColor = color.cgColor
        self.layer.borderWidth = 1
        
    }
    func pSetBorder(color:UIColor,radius:CGFloat) {
        
        self.layer.cornerRadius = radius
        self.clipsToBounds = true
        self.layer.borderColor = color.cgColor
        self.layer.borderWidth = 1
        
    }
    
    func pShadow() {
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 1
        self.layer.shadowOffset = CGSize.zero
        self.layer.shadowRadius = 8
    }
    
    func pShadowOnGray() {
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.2
        self.layer.shadowOffset = CGSize.zero
        self.layer.shadowRadius = 1
    }
    
    func pLightBorder() {
        self.layer.cornerRadius = 10
        self.clipsToBounds = true
        self.layer.borderColor = UIColor.gray.cgColor
        self.layer.borderWidth = 0.25
    }
    
    func pRound5() {
        
        self.layer.cornerRadius = 10
        self.clipsToBounds = true
        
    }
    
    func pSetGradientBackground() {
        let colorTop =  UIColor.clear.cgColor
        let colorBottom = UIColor.black.cgColor
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [ colorTop, colorBottom]
        gradientLayer.locations = [ 0.0, 1.0]
        gradientLayer.frame = self.bounds
        
        self.layer.addSublayer(gradientLayer)
    }
    
    
    func pRoundToHalfHeight() {
        
        self.layer.cornerRadius = self.frame.size.height/2
        self.clipsToBounds = true
        self.layer.borderColor = UIColor.white.cgColor
        self.layer.borderWidth = 2
        
    }
    
}
//MARK:- NSOBJECT
extension NSObject {
    var pTheClassName: String {
        return NSStringFromClass(type(of: self))
    }
}
//MARK:-ARRAY
extension Array where Element: Hashable {
    func pRemovingDuplicates() -> [Element] {
        var addedDict = [Element: Bool]()
        
        return filter {
            addedDict.updateValue(true, forKey: $0) == nil
        }
    }
    
    mutating func pRemoveDuplicates() {
        self = self.pRemovingDuplicates()
    }
}
//MARK:- TableView
extension UITableView {
    
    func pScrollToBottom(){
        
        DispatchQueue.main.async {
            let indexPath = IndexPath(
                row: self.numberOfRows(inSection:  self.numberOfSections-1) - 1,
                section: self.numberOfSections - 1)
            if self.pHasRowAtIndexPath(indexPath: indexPath) {
                self.scrollToRow(at: indexPath, at: .bottom, animated: true)
            }
        }
    }
    
    func pScrollToTop() {
        
        DispatchQueue.main.async {
            let indexPath = IndexPath(row: 0, section: 0)
            if self.pHasRowAtIndexPath(indexPath: indexPath) {
                self.scrollToRow(at: indexPath, at: .top, animated: false)
            }
        }
    }
    
    func pHasRowAtIndexPath(indexPath: IndexPath) -> Bool {
        return indexPath.section < self.numberOfSections && indexPath.row < self.numberOfRows(inSection: indexPath.section)
    }
}

//MARK:- DATE
extension Date{
    func pToString() -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        return dateFormatter.string(from: self)
    }
    
    func pDayOfTheWeek() -> String? {
            
        let dateFormatter = DateFormatter()
            
        dateFormatter.dateFormat = "EEEE"
           
        return dateFormatter.string(from: self)
        
    }
}
//MARK:- DATA
extension Data{
    var pHexString: String {
        return self.map { String(format: "%02.2hhx", arguments: [$0]) }.joined()
    }
}
//MARK:- String
extension String {
    var isContainsLetters : Bool{
        let letters = CharacterSet.letters
        return self.rangeOfCharacter(from: letters) != nil
    }
    func getURL() -> String? {
        
        let detector = try! NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
        let matches = detector.matches(in: self, options: [], range: NSRange(location: 0, length: self.utf16.count))

        for match in matches {
            guard let range = Range(match.range, in: self) else { continue }
            let url = self[range]
            print(url)
            return String(url)
       
        }
        return nil
    }
    
//    func pLocalized(lang: String = LanguageManager.language) ->String {
//
//        let path = Bundle.main.path(forResource: lang, ofType: "lproj")
//        let bundle = Bundle(path: path!)
//
//        return NSLocalizedString(self, tableName: nil, bundle: bundle!, value: "", comment: "")
//    }
//
//    func pLocalizedEn(lang: String) ->String {
//
//        let path = Bundle.main.path(forResource: lang, ofType: "lproj")
//        let bundle = Bundle(path: path!)
//
//        return NSLocalizedString(self, tableName: nil, bundle: bundle!, value: "", comment: "")
//    }
//
    func pUtcToLocalDateTime() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd H:mm:ss.S"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        
        if let date = dateFormatter.date(from: self) {
            dateFormatter.timeZone = TimeZone.current
            dateFormatter.dateFormat = "yyyy-MM-dd H:mm:ss.S"
        
            return dateFormatter.string(from: date)
        }
        return nil
    }

    public func pMakeParameter() -> String? {
        return addingPercentEncoding(withAllowedCharacters: .pUrlQueryValueAllowed)
    }

    func pChangeFormat(from:String = "yyyy-MM-dd'T'HH:mm:ss.SSSZ",to:String)->String {
        let formatter = DateFormatter()
        formatter.dateFormat = from //"yyyy-MM-dd HH:mm:ss"
        let date = formatter.date(from: self)
        formatter.dateFormat = to
        //formatter.dateStyle = .full
//        formatter.locale   = Locale(identifier:LanguageManager.language)
        if let convertedDate = date{
            if to == "dd MMM yyyy" {
                if let d = formatter.string(from: convertedDate).split(separator: " ").first,
                   let day = Int(d){
                    // String(d)
                    let numberFormatter = NumberFormatter()
                    numberFormatter.numberStyle = .ordinal
                    let ordinalDay = numberFormatter.string(from: NSNumber(value: day))
                    return formatter.string(from: convertedDate).replacingOccurrences(of: String(d), with: ordinalDay ?? "")
                }
            }
            return formatter.string(from: convertedDate)
        }else{
            return self
        }
    }
    func pToDate(_ format:String = "yyyy-MM-dd'T'HH:mm:ss.SSSZ") -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.date(from: self)
    }
    func pMakeFirebaseString()->String{
        let arrCharacterToReplace = [".","#","$","[","]"]
        var finalString = self
        
        for character in arrCharacterToReplace{
            finalString = finalString.replacingOccurrences(of: character, with: " ")
        }
        
        return finalString
    }
    func pCapitalizingFirstLetter() -> String {
        let first = String(self.prefix(1)).capitalized
        let other = String(self.dropFirst())
        return first + other
    }
    func pRemoveSpaces() -> String {
        let trimmedString = self.trimmingCharacters(in: .whitespaces)
        return trimmedString
    }
    mutating func capitalizeFirstLetter() {
        self = self.pCapitalizingFirstLetter()
    }
    func pSpaceToUnderscore() -> String {
        return self.replacingOccurrences(of: " ", with: "_")
    }
    func pUnderscoreToSpace() -> String {
        return self.replacingOccurrences(of: "_", with: " ")
    }
    func pIsValidEmail() -> Bool {
        // here, `try!` will always succeed because the pattern is valid
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: self)
    }
    func isValidEmail() -> Bool {
        // here, `try!` will always succeed because the pattern is valid
        let regex = try! NSRegularExpression(pattern: "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$", options: .caseInsensitive)
        return regex.firstMatch(in: self, options: [], range: NSRange(location: 0, length: count)) != nil
    }

    // vrify Valid PhoneNumber or Not
    func isValidPhone() -> Bool {

        let phoneRegex = "^[0-9]{10}$";
        let valid = NSPredicate(format: "SELF MATCHES %@", phoneRegex).evaluate(with: phoneRegex)
        return valid
    }
    func pStrikeThrough() -> NSAttributedString {
        let attributeString =  NSMutableAttributedString(string: self)
        attributeString.addAttribute(
            NSAttributedString.Key.strikethroughStyle,
            value: NSUnderlineStyle.single.rawValue,
            range:NSMakeRange(0,attributeString.length))
        return attributeString
    }
    
    func pToKhamr() -> String {
        
       
        var text = self
//        text = text.replacingOccurrences(of: "0", with: "0".pLocalized())
//        text = text.replacingOccurrences(of: "1", with: "1".pLocalized())
//        text = text.replacingOccurrences(of: "2", with: "2".pLocalized())
//        text = text.replacingOccurrences(of: "3", with: "3".pLocalized())
//        text = text.replacingOccurrences(of: "4", with: "4".pLocalized())
//        text = text.replacingOccurrences(of: "5", with: "5".pLocalized())
//        text = text.replacingOccurrences(of: "6", with: "6".pLocalized())
//        text = text.replacingOccurrences(of: "7", with: "7".pLocalized())
//        text = text.replacingOccurrences(of: "8", with: "8".pLocalized())
//        text = text.replacingOccurrences(of: "9", with: "9".pLocalized())
//        text = text.replacingOccurrences(of: ":", with: ":".pLocalized())
//        text = text.replacingOccurrences(of: "AM", with: "AM".pLocalized())
//        text = text.replacingOccurrences(of: "PM", with: "PM".pLocalized())
//        text = text.replacingOccurrences(of: "st", with: "".pLocalized())
//        //text = text.replacingOccurrences(of: "nd", with: "".pLocalized())
//        text = text.replacingOccurrences(of: "th", with: "".pLocalized())

        return text
    }
}
extension UserDefaults {
    private struct Keys {
        // MARK: - Constants
        static let cvvs = "cvvs"

    }
    
    var cvvsArray:[[String:String]]?{
            
            get{
                return  UserDefaults.standard.value(forKey: UserDefaults.Keys.cvvs) as? [[String:String]]

            }
            set{
                let defaults = UserDefaults.standard
                defaults.setValue(newValue, forKey: UserDefaults.Keys.cvvs)
                defaults.synchronize()
            }
            
    }
    func pDecode<T : Codable>(for type: T.Type, using key : String) -> T? {
        guard let data = UserDefaults.standard.object(forKey: key) as? Data else { return nil }
        return try? PropertyListDecoder().decode(type, from: data)
    }
    
    func pEncode<T : Codable>(for type: T?, using key : String) {
        let encodedData = try? PropertyListEncoder().encode(type)
        UserDefaults.standard.set(encodedData, forKey: key)
        UserDefaults.standard.synchronize()
    }
}
//MARK:- SEARCH
extension UISearchBar {
    /// Returns the`UITextField` that is placed inside the text field.
    var pTextField: UITextField {
        if #available(iOS 13, *) {
            return searchTextField
        } else {
            return self.value(forKey: "_searchField") as! UITextField
        }
    }
}

//MARK:- UIBUTTON
extension UIButton {
    func pSetBackgroundColor(color: UIColor, forState: UIControl.State) {
        UIGraphicsBeginImageContext(CGSize(width: 1, height: 1))
        UIGraphicsGetCurrentContext()!.setFillColor(color.cgColor)
        UIGraphicsGetCurrentContext()!.fill(CGRect(x: 0, y: 0, width: 1, height: 1))
        let colorImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        self.setBackgroundImage(colorImage, for: forState)
    }
}
//MARK:- CHARACTER
extension CharacterSet {
    static let pUrlQueryValueAllowed: CharacterSet = {
        let generalDelimitersToEncode = ":#[]@" // does not include "?" or "/" due to RFC 3986 - Section 3.4
        let subDelimitersToEncode = "!$&'()*+,;="
        
        var allowed = CharacterSet.urlQueryAllowed
        allowed.remove(charactersIn: generalDelimitersToEncode + subDelimitersToEncode)
        
        return allowed
    }()
}
//MARK:- CONSTRAINTS
extension NSLayoutConstraint {
    func pConstraintWithMultiplier(_ multiplier: CGFloat) -> NSLayoutConstraint {
        return NSLayoutConstraint(item: self.firstItem!, attribute: self.firstAttribute, relatedBy: self.relation, toItem: self.secondItem, attribute: self.secondAttribute, multiplier: multiplier, constant: self.constant)
    }
    func pSetMultiplier(multiplier:CGFloat) -> NSLayoutConstraint {
        
        NSLayoutConstraint.deactivate([self])
        
        let newConstraint = NSLayoutConstraint(
            item: firstItem!,
            attribute: firstAttribute,
            relatedBy: relation,
            toItem: secondItem,
            attribute: secondAttribute,
            multiplier: multiplier,
            constant: constant)
        
        newConstraint.priority = priority
        newConstraint.shouldBeArchived = self.shouldBeArchived
        newConstraint.identifier = self.identifier
        
        NSLayoutConstraint.activate([newConstraint])
        return newConstraint
    }
}
//MARK:- REACHIBILITY
public class PReachability {
    class func pIsConnectedToNetwork() -> Bool {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        return (isReachable && !needsConnection)
    }
}
//MARK:- ARRAY
extension Array where Element:Equatable {
    func pRemoveDuplicates() -> [Element] {
        var result = [Element]()
        
        for value in self {
            if result.contains(value) == false {
                result.append(value)
            }
        }
        
        return result
    }
    func pUnique<T:Hashable>(map: ((Element) -> (T)))  -> [Element] {
        var set = Set<T>() //the unique list kept in a Set for fast retrieval
        var arrayOrdered = [Element]() //keeping the unique list of elements but ordered
        for value in self {
            if !set.contains(map(value)) {
                set.insert(map(value))
                arrayOrdered.append(value)
            }
        }
        
        return arrayOrdered
    }
}
extension Array{
    func pCheckArrayForDataEntry() -> Array<String> {
        
        var clearedArray = [String]()
        
        for value in self {
            let newValue = value as! String
            if newValue != "" {
                clearedArray.append(newValue.trimmingCharacters(in: .whitespaces).capitalized.pMakeFirebaseString())
            }
        }
        
        return clearedArray
    }

    func pArrayToActionaryWithDate() -> Dictionary<String,String> {
        var clearedDictionary = [String:String]()
        
        for value in self {
            let newValue = value as! String
            clearedDictionary[newValue] = "\(NSDate())"
        }
        
        return clearedDictionary
    }


    func pSpaceToUnderscore() -> Array<String> {
        
        var clearedArray = [String]()
        
        for value in self {
            let newValue = value as! String
            if newValue != "" {
                clearedArray.append(newValue.replacingOccurrences(of: " ", with: "_"))
            }
        }
        
        return clearedArray
    }


    func pUnderscoreToSpace() -> Array<String> {
        
        var clearedArray = [String]()
        
        for value in self {
            let newValue = value as! String
            if newValue != "" {
                clearedArray.append(newValue.replacingOccurrences(of: "_", with: " "))
            }
        }
        
        return clearedArray
    }
//    mutating func remove(at indexes: [Int]) {
//        for index in indexes.sorted(by: >) {
//            remove(at: index)
//        }
//    }

}
//MARK:- IMAGEVIEW
extension UIImageView{
    func pLoadImage(url:String) {
        if let http = URL(string: url) {
            var comps = URLComponents(url: http, resolvingAgainstBaseURL: false)!
            comps.scheme = "https"
            let https = comps.url!
            print(https)
//            self.kf.indicatorType = .none
//            self.kf.setImage(with: http,placeholder: #imageLiteral(resourceName: "placeHolder"))
        }else{
            self.image = #imageLiteral(resourceName: "placeHolder")
        }
        
    }
    
   
}
//MARK:- COLORS
extension UIColor{
    static func pHexColor(hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    public static var themeBlueColor = UIColor.pHexColor(hex: "#F25125")
    public static var navyBlue = UIColor.pHexColor(hex: "#165C8B")
    public static var greyColor = UIColor.pHexColor(hex: "#9B9B9B")
    public static var royalBlue = UIColor.pHexColor(hex: "#235DD9")
    public static var themeDarkBlue = UIColor.pHexColor(hex: "#F25125")
//    public static var themeDarkBlue = UIColor.pHexColor(hex: "#4055a4")
    public static var themeLightGrey = UIColor.pHexColor(hex: "#EBEBEB")
    public static var themeYellow = UIColor.pHexColor(hex: "#CBA02D")
    
}
//MARK:- USER DEFAULTS
extension UserDefaults {
    static func pIsFirstLaunch() -> Bool {
        let hasBeenLaunchedBeforeFlag = "hasBeenLaunchedBeforeFlag"
        let isFirstLaunch = !UserDefaults.standard.bool(forKey: hasBeenLaunchedBeforeFlag)
        if (isFirstLaunch) {
            UserDefaults.standard.set(true, forKey: hasBeenLaunchedBeforeFlag)
            UserDefaults.standard.synchronize()
        }
        return isFirstLaunch
    }
}
//MARK:- UIIMAGE
extension UIImage {
    func pResizeWith(percentage: CGFloat) -> UIImage? {
        let imageView = UIImageView(frame: CGRect(origin: .zero, size: CGSize(width: size.width * percentage, height: size.height * percentage)))
        imageView.contentMode = .scaleAspectFit
        imageView.image = self
        UIGraphicsBeginImageContextWithOptions(imageView.bounds.size, false, scale)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        imageView.layer.render(in: context)
        guard let result = UIGraphicsGetImageFromCurrentImageContext() else { return nil }
        UIGraphicsEndImageContext()
        return result
    }
    func pResizeWith(width: CGFloat) -> UIImage? {
        let imageView = UIImageView(frame: CGRect(origin: .zero, size: CGSize(width: width, height: CGFloat(ceil(width/size.width * size.height)))))
        imageView.contentMode = .scaleAspectFit
        imageView.image = self
        UIGraphicsBeginImageContextWithOptions(imageView.bounds.size, false, scale)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        imageView.layer.render(in: context)
        guard let result = UIGraphicsGetImageFromCurrentImageContext() else { return nil }
        UIGraphicsEndImageContext()
        return result
    }
    class func pGetColoredRectImageWith(color: CGColor, andSize size: CGSize) -> UIImage{
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        let graphicsContext = UIGraphicsGetCurrentContext()
        graphicsContext?.setFillColor(color)
        let rectangle = CGRect(x: 0.0, y: 0.0, width: size.width, height: size.height)
        graphicsContext?.fill(rectangle)
        let rectangleImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return rectangleImage!
    }
}
//MARK:- LOCATION
extension CLLocationCoordinate2D {
    //distance in meters, as explained in CLLoactionDistance definition
    func pDistance(from: CLLocationCoordinate2D) -> CLLocationDistance {
        let destination=CLLocation(latitude:from.latitude,longitude:from.longitude)
        return CLLocation(latitude: latitude, longitude: longitude).distance(from: destination)
    }
}
//MARK:- DOUBLE
extension Double {
    /// Rounds the double to decimal places value
    func pRoundTo(places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
    //MARK:- Format number
    func prettyNumberFormat(_ currencySymbol:String = "$")->String? {
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = 2
        formatter.numberStyle = .currency
        formatter.currencySymbol = currencySymbol
        formatter.allowsFloats = true
        formatter.alwaysShowsDecimalSeparator = true
        formatter.currencyGroupingSeparator = ","
        formatter.currencyDecimalSeparator = "."
        return formatter.string(from: NSNumber(value: self))
    }
    
}
extension Double {
    private static var pNumberFormatter: NumberFormatter = {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal

        return numberFormatter
    }()

    var pDelimiter: String {
        return Double.pNumberFormatter.string(from: NSNumber(value: self)) ?? ""
    }
}
//MARK:- CATRANSITION
extension CATransition {
    
    //New viewController will appear from bottom of screen.
    func pPopUpFadeIn() -> CATransition {
        self.duration = 0.375 //set the duration to whatever you'd like.
        self.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        self.type = CATransitionType.fade
        return self
    }
    //New viewController will appear from top of screen.
    func pPopUpFadeOut() -> CATransition {
        self.duration = 0.375 //set the duration to whatever you'd like.
        self.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        self.type = CATransitionType.fade
        return self
    }
    //New viewController will appear from left side of screen.
    func pPresentFromLeft() -> CATransition {
        self.duration = 0.5 //set the duration to whatever you'd like.
        self.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        self.type = CATransitionType.moveIn
        self.subtype = CATransitionSubtype.fromLeft
        return self
    }
    func pDismissFromRight() -> CATransition {
        self.duration = 0.5 //set the duration to whatever you'd like.
        self.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        self.type = CATransitionType.moveIn
        self.subtype = CATransitionSubtype.fromRight
        return self
    }
    //New viewController will pop from right side of screen.
    func pPopFromRight() -> CATransition {
        self.duration = 0.1 //set the duration to whatever you'd like.
        self.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        self.type = CATransitionType.reveal
        self.subtype = CATransitionSubtype.fromRight
        return self
    }
}
//MARK:- VIEW CONTROLLER

extension UIViewController {
    var pPreviousViewController:UIViewController?{
        if let controllersOnNavStack = self.navigationController?.viewControllers{
            let n = controllersOnNavStack.count
            //if self is still on Navigation stack
            if controllersOnNavStack.last === self, n > 1{
                return controllersOnNavStack[n - 2]
            }else if n > 0{
                return controllersOnNavStack[n - 1]
            }
        }
        return nil
    }
    func pShowInputDialog(title:String? = nil,
                         subtitle:String? = nil,
                         actionTitle:String? = "Add",
                         cancelTitle:String? = "Cancel",
                         inputPlaceholder:String? = nil,
                         inputKeyboardType:UIKeyboardType = UIKeyboardType.default,
                         cancelHandler: ((UIAlertAction) -> Swift.Void)? = nil,
                         actionHandler: ((_ text: String?) -> Void)? = nil) {
        
        let alert = UIAlertController(title: title, message: subtitle, preferredStyle: .alert)
        alert.addTextField { (textField:UITextField) in
            textField.placeholder = inputPlaceholder
            textField.keyboardType = inputKeyboardType
        }
        alert.addAction(UIAlertAction(title: actionTitle, style: .destructive, handler: { (action:UIAlertAction) in
            guard let textField =  alert.textFields?.first else {
                actionHandler?(nil)
                return
            }
            actionHandler?(textField.text)
        }))
        alert.addAction(UIAlertAction(title: cancelTitle, style: .cancel, handler: cancelHandler))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    
    func pHeightForView(text:String, font:UIFont, width:CGFloat) -> CGFloat{
        let label:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = font
        label.text = text
        label.sizeToFit()
        return label.frame.height
    }
    
    func pRectForText(text: String, font: UIFont, maxSize: CGSize) -> CGSize {
        let attrString = NSAttributedString.init(string: text, attributes: [NSAttributedString.Key.font:font])
        let rect = attrString.boundingRect(with: maxSize, options: NSStringDrawingOptions.usesLineFragmentOrigin, context: nil)
        let size = CGSize(width: rect.size.width, height: rect.size.height)
        return size
    }
    
    func pGoScreen (storyBoardID: String) {
        DispatchQueue.main.async {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: storyBoardID)
            self.present(vc, animated: false, completion: nil)
        }
    }
    
    func pTakeConfirmation(title: String, message: String, buttonText: String, completionHandler: @escaping (_ response: Bool) -> ()) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: { action in
            completionHandler(false)
        }))
        alert.addAction(UIAlertAction(title: buttonText, style: .default, handler: { action in
            completionHandler(true)
        }))
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func pShowImage(image:UIImage) {
        let newImageView = UIImageView(image: image)
        newImageView.frame = UIScreen.main.bounds
        newImageView.backgroundColor = .black
        newImageView.contentMode = .scaleAspectFit
        newImageView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(pDismissFullscreenImage))
        newImageView.addGestureRecognizer(tap)
        self.view.addSubview(newImageView)
        self.navigationController?.isNavigationBarHidden = true
        self.tabBarController?.tabBar.isHidden = true
    }
    
    @objc func pDismissFullscreenImage(_ sender: UITapGestureRecognizer) {
        self.navigationController?.isNavigationBarHidden = false
        self.tabBarController?.tabBar.isHidden = false
        sender.view?.removeFromSuperview()
    }
    
    
    func pHexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    
    func pHideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.pDismissKeyboard1))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func pDismissKeyboard1() {
        view.endEditing(true)
    }
}

//MARK:- COLLECTION VIEW
extension Collection where Indices.Iterator.Element == Index {
    
    /// Returns the element at the specified index iff it is within bounds, otherwise nil.
    subscript (safe index: Index) -> Iterator.Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
//MARK:- FONTS
enum pThemeFonts : String
{
    case light = "Montserrat-Light"
    case bold = "Montserrat-Bold"
    case extraBold = "Montserrat-Black"
    case medium = "Montserrat-Medium"
    case regular = "Montserrat-Regular"
}
extension UIFont {
    static func pThemeFont(size : Float,fontname : pThemeFonts) -> UIFont {
        if UIScreen.main.bounds.width <= 320 {
            return UIFont(name: fontname.rawValue, size: CGFloat(size))! //CGFloat(size) - 2.0)
        }
        else {
            return UIFont(name: fontname.rawValue, size: CGFloat(size))!
        }
    }
}
//MARK:- UISegmentedControl
extension UISegmentedControl{
    func pRemoveBorder(){
        let backgroundImage = UIImage.pGetColoredRectImageWith(color: UIColor.white.cgColor, andSize: self.bounds.size)
        self.setBackgroundImage(backgroundImage, for: .normal, barMetrics: .default)
        self.setBackgroundImage(backgroundImage, for: .selected, barMetrics: .default)
        self.setBackgroundImage(backgroundImage, for: .highlighted, barMetrics: .default)
        
        let deviderImage = UIImage.pGetColoredRectImageWith(color: UIColor.white.cgColor, andSize: CGSize(width: 1.0, height: self.bounds.size.height))
        self.setDividerImage(deviderImage, forLeftSegmentState: .selected, rightSegmentState: .normal, barMetrics: .default)
        self.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.gray], for: .normal)
        self.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor(red: 67/255, green: 129/255, blue: 244/255, alpha: 1.0)], for: .selected)
    }
    
    func pAddUnderlineForSelectedSegment(){
        pRemoveBorder()
        let underlineWidth: CGFloat = self.bounds.size.width / CGFloat(self.numberOfSegments)
        let underlineHeight: CGFloat = 2.0
        let underlineXPosition = CGFloat(selectedSegmentIndex * Int(underlineWidth))
        let underLineYPosition = self.bounds.size.height - 1.0
        let underlineFrame = CGRect(x: underlineXPosition, y: underLineYPosition, width: underlineWidth, height: underlineHeight)
        let underline = UIView(frame: underlineFrame)
        underline.backgroundColor = UIColor(red: 67/255, green: 129/255, blue: 244/255, alpha: 1.0)
        underline.tag = 1
        self.addSubview(underline)
    }
    
    func pChangeUnderlinePosition(){
        guard let underline = self.viewWithTag(1) else {return}
        let underlineFinalXPosition = (self.frame.width / CGFloat(self.numberOfSegments)) * CGFloat(selectedSegmentIndex)
        UIView.animate(withDuration: 0.1, animations: {
            underline.frame.origin.x = underlineFinalXPosition
        })
    }
}
//MARK:- LAYER
extension CALayer {
    func pAddGradienBorder(colors:[UIColor],width:CGFloat = 1,radius:CGFloat = 0) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame =  CGRect(origin: .zero, size: self.bounds.size)
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        gradientLayer.colors = colors.map({$0.cgColor})
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.lineWidth = width
        shapeLayer.path = UIBezierPath(rect: self.bounds).cgPath
        shapeLayer.fillColor = nil
        shapeLayer.strokeColor = UIColor.black.cgColor
        gradientLayer.mask = shapeLayer
        gradientLayer.cornerRadius = radius
        self.addSublayer(gradientLayer)
    }
    
}

//MARK:- UIAPPLICATION
extension UIApplication {
    var pStatusBarView: UIView? {
        if responds(to: Selector(("statusBar"))) {
            return value(forKey: "statusBar") as? UIView
        }
        return nil
    }
    class func pTopViewController(controller: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) ->
        UIViewController! {
            if let navigationController = controller as? UINavigationController {
                return pTopViewController(controller: navigationController.visibleViewController)
            }
            if let tabController = controller as? UITabBarController {
                if let selected = tabController.selectedViewController {
                    return pTopViewController(controller: selected)
                }
            }
            if let presented = controller?.presentedViewController {
                return pTopViewController(controller: presented)
            }
         
            return controller
    }
    
    class func pTopViewControllerOptional(controller: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) ->
        UIViewController? {
            if let navigationController = controller as? UINavigationController {
                return pTopViewController(controller: navigationController.visibleViewController)
            }
            if let tabController = controller as? UITabBarController {
                if let selected = tabController.selectedViewController {
                    return pTopViewController(controller: selected)
                }
            }
            if let presented = controller?.presentedViewController {
                return pTopViewController(controller: presented)
            }
            return controller ?? nil
    }
}
//MARK:- NAVIGATION
extension UINavigationController {
//    func pushViewController(viewController: UIViewController, animated: Bool, completion:@escaping () -> ()) {
//        pushViewController(viewController, animated: animated)
//
//        if let coordinator = transitionCoordinator, animated {
//            coordinator.animate(alongsideTransition: nil) { _ in
//                completion()
//            }
//        } else {
//            completion()
//        }
//    }
    
    func pPopViewControllerWithHandler(completion: @escaping() -> Void) {
        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)
        self.popViewController(animated: true)
        CATransaction.commit()
    }
}

extension CAShapeLayer {
    func drawCircleAtLocation(location: CGPoint, withRadius radius: CGFloat, andColor color: UIColor, filled: Bool) {
        fillColor = filled ? color.cgColor : UIColor.white.cgColor
        strokeColor = color.cgColor
        let origin = CGPoint(x: location.x - radius, y: location.y - radius)
        path = UIBezierPath(ovalIn: CGRect(origin: origin, size: CGSize(width: radius * 2, height: radius * 2))).cgPath
    }
}

private var handle: UInt8 = 0

extension UIButton {
    private var pBadgeLayer: CAShapeLayer? {
        if let b: AnyObject = objc_getAssociatedObject(self, &handle) as AnyObject? {
            return b as? CAShapeLayer
        } else {
            return nil
        }
    }

    func pAddBadge(number: Int, withOffset offset: CGPoint = CGPoint.zero, andColor color: UIColor = UIColor.red, andFilled filled: Bool = true) {
        //guard let view = self.value(forKey: "view") as? UIButton else { return }

        pBadgeLayer?.removeFromSuperlayer()

        // Initialize Badge
        let badge = CAShapeLayer()
        let radius = CGFloat(10)
        let location = CGPoint(x: self.frame.width - (radius + offset.x), y: (radius + offset.y))
        badge.drawCircleAtLocation(location: location, withRadius: radius, andColor: color, filled: filled)
        self.layer.addSublayer(badge)
        // Initialiaze Badge's label
        let label = CATextLayer()
        label.string = "\(number)"
        label.font = UIFont.pThemeFont(size:10.0, fontname: .medium)
        label.alignmentMode = CATextLayerAlignmentMode.center
        label.fontSize = 10
        label.frame = CGRect(origin: CGPoint(x: location.x - 6, y: offset.y + 3), size: CGSize(width: 12, height: 16))
        label.foregroundColor = filled ? UIColor.white.cgColor : color.cgColor
        label.backgroundColor = UIColor.clear.cgColor
        label.contentsScale = UIScreen.main.scale
        badge.addSublayer(label)
        
        // Save Badge as UIBarButtonItem property
        objc_setAssociatedObject(self, &handle, badge, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        self.clipsToBounds = false
    }

    func pUpdateBadge(number: Int) {
        if let text = pBadgeLayer?.sublayers?.filter({ $0 is CATextLayer }).first as? CATextLayer {
            text.string = "\(number)"
        }
    }

    func pRemoveBadge() {
        pBadgeLayer?.removeFromSuperlayer()
    }
}

extension Sequence {
    func pGroup<GroupingType: Hashable>(by key: (Iterator.Element) -> GroupingType) -> [[Iterator.Element]] {
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
    // Add/remove error message
   
    func setError(_ string: String? = nil, show: Bool = true) {
        if let rightView = rightView, rightView.tag != 999 {
            rightViews.setObject(rightView, forKey: self)
        }

        // Remove message
        guard string != nil else {
            if let rightView = rightViews.object(forKey: self) {
                self.rightView = rightView
                rightViews.removeObject(forKey: self)
            } else {
                self.rightView = nil
            }

            if let errorView = errorViews.object(forKey: self) {
                errorView.isHidden = true
                errorViews.removeObject(forKey: self)
            }

            return
        }

        // Create container
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false

        // Create triangle
        let triagle = TriangleTop()
        triagle.backgroundColor = .clear
        triagle.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(triagle)

        // Create red line
        let line = UIView()
        line.backgroundColor = .red
        line.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(line)

        // Create message
        let label = UILabel()
        label.text = string
        label.textColor = .white
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 15)
        label.backgroundColor = .black
        label.setContentCompressionResistancePriority(UILayoutPriority(rawValue: 250), for: .horizontal)
        label.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(label)

        // Set constraints for triangle
        triagle.heightAnchor.constraint(equalToConstant: 10).isActive = true
        triagle.widthAnchor.constraint(equalToConstant: 15).isActive = true
        triagle.topAnchor.constraint(equalTo: container.topAnchor, constant: -10).isActive = true
        triagle.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -15).isActive = true

        // Set constraints for line
        line.heightAnchor.constraint(equalToConstant: 3).isActive = true
        line.topAnchor.constraint(equalTo: triagle.bottomAnchor, constant: 0).isActive = true
        line.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 0).isActive = true
        line.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: 0).isActive = true

        // Set constraints for label
        label.topAnchor.constraint(equalTo: line.bottomAnchor, constant: 0).isActive = true
        label.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: 0).isActive = true
        label.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 0).isActive = true
        label.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: 0).isActive = true

        if !show {
            container.isHidden = true
        }
        // superview!.superview!.addSubview(container)
        UIApplication.shared.keyWindow!.addSubview(container)

        // Set constraints for container
        container.widthAnchor.constraint(lessThanOrEqualTo: superview!.widthAnchor, multiplier: 1).isActive = true
        container.trailingAnchor.constraint(equalTo: superview!.trailingAnchor, constant: 0).isActive = true
        container.topAnchor.constraint(equalTo: superview!.bottomAnchor, constant: 0).isActive = true

        // Hide other error messages
        let enumerator = errorViews.objectEnumerator()
        while let view = enumerator!.nextObject() as! UIView? {
            view.isHidden = true
        }

        // Add right button to textField
        let errorButton = UIButton(type: .custom)
        errorButton.tag = 999
        errorButton.setImage(UIImage(named: "ic_error"), for: .normal)
        errorButton.frame = CGRect(x: 0, y: 0, width: frame.size.height, height: frame.size.height)
        errorButton.addTarget(self, action: #selector(errorAction), for: .touchUpInside)
        rightView = errorButton
        rightViewMode = .always

        // Save view with error message
        errorViews.setObject(container, forKey: self)
    }

    // Show error message
    @IBAction
    func errorAction(_ sender: Any) {
        let errorButton = sender as! UIButton
        let textField = errorButton.superview as! UITextField

        let errorView = errorViews.object(forKey: textField)
        if let errorView = errorView {
            errorView.isHidden.toggle()
        }

        let enumerator = errorViews.objectEnumerator()
        while let view = enumerator!.nextObject() as! UIView? {
            if view != errorView {
                view.isHidden = true
            }
        }

        // Don't hide keyboard after click by icon
      //  UIViewController.isCatchTappedAround = false
    }
}

class TriangleTop: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else {
            return
        }

        context.beginPath()
        context.move(to: CGPoint(x: (rect.maxX / 2.0), y: rect.minY))
        context.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        context.addLine(to: CGPoint(x: (rect.minX / 2.0), y: rect.maxY))
        context.closePath()

        context.setFillColor(UIColor.red.cgColor)
        context.fillPath()
    }
}
