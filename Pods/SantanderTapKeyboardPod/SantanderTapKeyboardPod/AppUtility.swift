//
//  AppUtility.swift
//  Teclado
//
//  Created by Darshan Bagmar on 15/04/20.
//  Copyright © 2020 IDmission. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

class AppUtility{
    
    static func sortArrayHistory(array:[History]) -> [History]{
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
            let sortedArray = array.sorted{[dateFormatter] one, two in
                return dateFormatter.date(from:one.date )! > dateFormatter.date(from: two.date)! }
            return sortedArray
    }
    
    static func formatDate(mainDate:String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
        let convertDate:Date = dateFormatter.date(from: mainDate) ?? Date.init()
        
        let dateFormatterforMonth = DateFormatter()
        dateFormatterforMonth.dateFormat = "MMMM"
        let month:String = dateFormatterforMonth.string(from: convertDate)
        
        let showdateFormatter = DateFormatter()
        showdateFormatter.dateFormat = "dd/MMMM/yyyy"
        let spainshMonth:String = SpanishString.init(rawValue: month)?.DisplayString ?? " "
        var showDate = showdateFormatter.string(from: convertDate)
        showDate = showDate.replacingOccurrences(of: month, with: spainshMonth)
        
        //let showDate = SpanishString.init(rawValue: showdateFormatter.string(from: convertDate) )?.DisplayString ?? " "
        return showDate
        
    }
    
    static func formatDate(mainDate:String,showDateFormat:String) -> String {
           let dateFormatter = DateFormatter()
           dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
           let convertDate:Date = dateFormatter.date(from: mainDate) ?? Date.init()
           
           let dateFormatterforMonth = DateFormatter()
           dateFormatterforMonth.dateFormat = "MMMM"
           let month:String = dateFormatterforMonth.string(from: convertDate)
           
           let showdateFormatter = DateFormatter()
           showdateFormatter.dateFormat = showDateFormat//"dd/MMMM/yyyy"
           let spainshMonth:String = SpanishString.init(rawValue: month)?.DisplayString ?? " "
           var showDate = showdateFormatter.string(from: convertDate)
           showDate = showDate.replacingOccurrences(of: month, with: spainshMonth)
           
           //let showDate = SpanishString.init(rawValue: showdateFormatter.string(from: convertDate) )?.DisplayString ?? " "
           return showDate
           
       }
    
    
    static func dateFromString(mainDate:String,dateFormat:String) -> Date {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
    let convertDate:Date = dateFormatter.date(from: mainDate) ?? Date.init()
    return convertDate
    }
    
    static func dateToString(mainDate:Date,showDateFormat:String,currentDateFormat:String = " ") -> String {
        let dateFormatter = DateFormatter()
        if currentDateFormat != " "{
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
        }else{
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
        }
        let showdateFormatter = DateFormatter()
        showdateFormatter.dateFormat = showDateFormat//"dd/MMMM/yyyy"
        return showdateFormatter.string(from: mainDate)
    }
    
    
    
    static func heightForView(text:String, font:UIFont, width:CGFloat) -> CGFloat{
        let label:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = font
        label.text = text
        label.sizeToFit()
        return label.frame.height
    }
    
    
    static func jsonString(json:Data) -> String {
        
        if !(json.isEmpty)//try? JSONSerialization.data(withJSONObject: self, options: [])
        {
            let decoded = String(data: json, encoding: .utf8)!
            return decoded
        }
        return ""
    }
    
   
    
    
    
}


extension UIInputView : UIInputViewAudioFeedback {

    public var enableInputClicksWhenVisible: Bool {
        return true
    }

}


extension Dictionary {
    func jsonRepresentation() -> String {
        if let jsonData : Data = try? JSONSerialization.data(withJSONObject: self, options: [])
        {
            let decoded = String(data: jsonData, encoding: .utf8)!
            return decoded
        }
        return ""
    }
    
    func jsonData() -> Data {
        
        if let jsonData : Data = try? JSONSerialization.data(withJSONObject: self, options: []){
          return jsonData
        }
        return Data.init()
    }
}



extension Bundle {
    var releaseVersionNumber: String? {
        return infoDictionary?["CFBundleShortVersionString"] as? String
    }
    var buildVersionNumber: String? {
        return infoDictionary?["CFBundleVersion"] as? String
    }
}


extension UIView{
    
    func removeChildView(){
        self.subviews.forEach { $0.removeFromSuperview() }
    }
    
    func showActivityIndicatory() {
        let view = UIView.init()
       /* view.frame = self.bounds
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.hidesWhenStopped = true
        if #available(iOSApplicationExtension 13.0, *) {
            if #available(iOS 13.0, *) {
                activityIndicator.style = UIActivityIndicatorView.Style.large
            } else {
                activityIndicator.style = UIActivityIndicatorView.Style.whiteLarge
                // Fallback on earlier versions
            }
        } else {
            activityIndicator.style = UIActivityIndicatorView.Style.whiteLarge
            // Fallback on earlier versions
        }
        activityIndicator.color = .red
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.transform = CGAffineTransform(scaleX: 2, y: 2)
        activityIndicator.startAnimating()
        view.addSubview(activityIndicator)
        printLog("view frame:\(view.frame)....view bounds\(view.bounds)")
        let label = UILabel(frame: CGRect(x: self.bounds.size.width/2, y: 0, width: 200, height: 21))
        label.center = CGPoint(x: (self.bounds.size.width/2), y:160)
        label.textAlignment = .center
        label.text = "Procesando..."
        label.font = UIFont(name: "SantanderText-Bold", size: 25.0)
        label.textColor = .darkGray
        self.fadeViewInThenOut(view: label, delay: 0)
        view.addSubview(label)
        
        self.addSubview(view)
        activityIndicator.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true*/
        
        var customLoader = UIImageView(frame: CGRect(x: self.bounds.size.width/2, y: 0, width: 200, height: 200))
        customLoader.center = CGPoint(x: (self.bounds.size.width/2), y:100)
      guard let confettiImageView = UIImageView.fromGif(frame: customLoader.frame, resourceName: "Archivo") else { return }
        view.addSubview(confettiImageView)
        confettiImageView.startAnimating()
        self.addSubview(view)
        
       }
    
    func fadeViewInThenOut(view : UIView, delay: TimeInterval) {
        let animationDuration = 0.5
        UIView.animate(withDuration: animationDuration, delay: delay, options: [UIView.AnimationOptions.autoreverse, UIView.AnimationOptions.repeat], animations: {
            view.alpha = 0.75
        }, completion: nil)
    }
}


extension NSMutableAttributedString {
    var fontSize:CGFloat { return 25 }
    var boldFont:UIFont { return UIFont(name: "SantanderText-Bold", size: fontSize) ?? UIFont.boldSystemFont(ofSize: fontSize) }
    var normalFont:UIFont { return UIFont(name: "SantanderText-Regular", size: fontSize) ?? UIFont.systemFont(ofSize: fontSize)}

    func setfontSize(font:CGFloat) {
        
    }
    
    
    func bold(_ value:String) -> NSMutableAttributedString {

        let attributes:[NSAttributedString.Key : Any] = [
            .font : boldFont
        ]

        self.append(NSAttributedString(string: value, attributes:attributes))
        return self
    }
    
    func bold(_ value:String,fontSizes:CGFloat) -> NSMutableAttributedString {

       var boldFonts:UIFont { return UIFont(name: "SantanderText-Bold", size: fontSizes) ?? UIFont.boldSystemFont(ofSize: fontSizes) }
        
        let attributes:[NSAttributedString.Key : Any] = [
            .font : boldFonts
        ]

        self.append(NSAttributedString(string: value, attributes:attributes))
        return self
    }

    func normal(_ value:String) -> NSMutableAttributedString {

        let attributes:[NSAttributedString.Key : Any] = [
            .font : normalFont,
        ]

        self.append(NSAttributedString(string: value, attributes:attributes))
        return self
    }
    
    func normal(_ value:String,fontSizes:CGFloat) -> NSMutableAttributedString {
        
        var normalFonts:UIFont { return UIFont(name: "SantanderText-Regular", size: fontSizes) ?? UIFont.systemFont(ofSize: fontSizes)}

        let attributes:[NSAttributedString.Key : Any] = [
            .font : normalFonts,
        ]

        self.append(NSAttributedString(string: value, attributes:attributes))
        return self
    }
    
    /* Other styling methods */
    func orangeHighlight(_ value:String) -> NSMutableAttributedString {

        let attributes:[NSAttributedString.Key : Any] = [
            .font :  normalFont,
            .foregroundColor : UIColor.white,
            .backgroundColor : UIColor.orange
        ]

        self.append(NSAttributedString(string: value, attributes:attributes))
        return self
    }

    func blackHighlight(_ value:String) -> NSMutableAttributedString {

        let attributes:[NSAttributedString.Key : Any] = [
            .font :  normalFont,
            .foregroundColor : UIColor.white,
            .backgroundColor : UIColor.black

        ]

        self.append(NSAttributedString(string: value, attributes:attributes))
        return self
    }

    func underlined(_ value:String) -> NSMutableAttributedString {

        let attributes:[NSAttributedString.Key : Any] = [
            .font :  normalFont,
            .underlineStyle : NSUnderlineStyle.single.rawValue

        ]

        self.append(NSAttributedString(string: value, attributes:attributes))
        return self
    }
}


//MARK:- Date extension

extension TimeZone {
    static let gmt = TimeZone(secondsFromGMT: 0)!
}
extension Formatter {
    static let date = DateFormatter()
}

extension Date {
    func localizedDescription(dateStyle: DateFormatter.Style = .medium,
                              timeStyle: DateFormatter.Style = .medium,
                           in timeZone : TimeZone = .current,
                              locale   : Locale = .current) -> String {
        Formatter.date.locale = locale
        Formatter.date.timeZone = timeZone
        Formatter.date.dateStyle = dateStyle
        Formatter.date.timeStyle = timeStyle
        return Formatter.date.string(from: self)
    }
    var localizedDescription: String { localizedDescription() }
    
    
    static var yesterday: Date { return Date().dayBefore }
    static var tomorrow:  Date { return Date().dayAfter }
    
    
    
    func dayBefores(day:Int) -> Date {
         return Calendar.current.date(byAdding: .day, value: -day, to: noon)!
    }
    
    var dayBefore: Date {
        return Calendar.current.date(byAdding: .day, value: -1, to: noon)!
    }
    var dayAfter: Date {
        return Calendar.current.date(byAdding: .day, value: 1, to: noon)!
    }
    var noon: Date {
        return Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: self)!
    }
    var month: Int {
        return Calendar.current.component(.month,  from: self)
    }
    var isLastDayOfMonth: Bool {
        return dayAfter.month != month
    }
}



extension UIViewController {
    static func loadFromNib() -> Self {
        func instantiateFromNib<T: UIViewController>() -> T {
            return T.init(nibName: String(describing: T.self), bundle: nil)
        }

        return instantiateFromNib()
    }
    
    /**
        The view's default nib in the main bundle.
        */
       static var defaultNib: UINib {
           return defaultNib()
       }
       
       /**
        The view's default nib name.
        */
       static var defaultNibName: String {
           return String(describing: self)
       }
       
       /**
        Get the view's default nib in a certain bundle.
        */
       static func defaultNib(in bundle: Bundle = .main) -> UINib {
           return UINib(nibName: defaultNibName, bundle: bundle)
       }
    
    static func fromNib(
        owner: Any,
        named nibName: String = defaultNibName,
        in bundle: Bundle = .main) -> Self {
        return fromNibTyped(owner: owner)
    }
    
    
     static func fromNibTyped<T: UIViewController>(
            owner: Any,
            named nibName: String = T.defaultNibName,
            in bundle: Bundle = .main) -> T {
            let bundle = Bundle(for: self.classForCoder())
            let nibs = bundle.loadNibNamed(nibName, owner: nil, options: nil)?.first
            guard let nib = nibs as? T else { fatalError("initWithDefaultNib failed") }
            return nib

            
            
    //        let nibs = bundle.loadNibNamed(nibName, owner: owner, options: nil)
    //        guard let nib = nibs?[0] as? T else { fatalError("initWithDefaultNib failed") }
    //        return nib
        }
}


extension UIImageView {
    static func fromGif(frame: CGRect, resourceName: String) -> UIImageView? {
         let frameworkBundlePath = Bundle(for: DemoButton.self).bundlePath
        let bundle = Bundle(path: frameworkBundlePath)
        guard let path = bundle!.path(forResource: resourceName, ofType: "gif") else {
            print("Gif does not exist at that path")
            return nil
        }
        let url = URL(fileURLWithPath: path)
        guard let gifData = try? Data(contentsOf: url),
            let source =  CGImageSourceCreateWithData(gifData as CFData, nil) else { return nil }
        var images = [UIImage]()
        let imageCount = CGImageSourceGetCount(source)
        for i in 0 ..< imageCount {
            if let image = CGImageSourceCreateImageAtIndex(source, i, nil) {
                images.append(UIImage(cgImage: image))
            }
        }
        let gifImageView = UIImageView(frame: frame)
        gifImageView.animationImages = images
        return gifImageView
    }
}
