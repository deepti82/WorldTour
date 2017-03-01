//
//  Styles.swift
//  TraveLibro
//
//  Created by Midhet Sulemani on 09/05/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit


func addShadow(_ myView: UIView, offset: CGSize, opacity: CGFloat, shadowRadius: CGFloat, cornerRadius: CGFloat) {
    
    myView.layer.shadowOffset = CGSize(width: 2, height: 1)
    myView.layer.shadowOpacity = 0.2
    myView.layer.shadowRadius = 1
    myView.layer.cornerRadius = 3
    myView.layer.shadowColor = UIColor.blue.cgColor
    
}

func makeButtonGreyTranslucent(_ button: UIButton, textData: String) -> Void {
    
    button.backgroundColor = UIColor(red: 189/255, green: 193/255, blue: 211/255, alpha: 0.3)
    button.layer.borderColor = UIColor.white.cgColor
    button.layer.borderWidth = 2
    button.layer.cornerRadius = 1.5
    //button.titleLabel?.text = "Hii Midhet"
    //button.titleLabel?.textColor = UIColor.whiteColor()
    button.setTitle(textData, for: UIControlState())
    button.titleLabel?.font = UIFont(name: "Avenir-Roman", size: 18)
    
}

func getBackGround(_ myVC: UIViewController) -> Void {
    
//    myVC.view.backgroundColor = UIColor(patternImage: UIImage(named: "bg")!)
    let bgImage = UIImageView(frame: myVC.view.frame)
    bgImage.image = UIImage(named: "bg")
    bgImage.layer.zPosition = -1
    bgImage.isUserInteractionEnabled = false
    myVC.view.addSubview(bgImage)
    
}

func segueFromPagerStrip(_ vc: UINavigationController, nextVC: UIViewController) {
    
    print("inside global fn")
//    let storyboard = UIStoryboard(name: "Main", bundle: nil)
//    let edVC = storyboard.instantiateViewControllerWithIdentifier("exploreDestinations") as! ExploreDestinationsViewController
    vc.pushViewController(nextVC, animated: true)
    
}


func getDarkBackGround(_ myVC: UIViewController) -> Void {
    
    let bgImage = UIImageView(frame: myVC.view.frame)
    bgImage.image = UIImage(named: "darkBgNew")
    bgImage.layer.zPosition = -1
    bgImage.isUserInteractionEnabled = false
    myVC.view.addSubview(bgImage)
    myVC.view.sendSubview(toBack: bgImage)
    
}

func getDarkBackGroundBlur(_ myVC: UIViewController) -> Void {
    
    let bgImage = UIImageView(frame: myVC.view.frame)
    bgImage.image = UIImage(named: "darkBg")
    bgImage.layer.zPosition = -1
    bgImage.isUserInteractionEnabled = false
    
    myVC.view.addSubview(bgImage)
    myVC.view.sendSubview(toBack: bgImage)
    
    //    myVC.view.backgroundColor = UIColor(patternImage: UIImage(named: "darkBg")!)
    
}

func getDarkBackGroundBlue(_ myVC: UIViewController) {
    
    let bgImage = UIImageView(frame: myVC.view.frame)
    bgImage.image = UIImage(named: "darkBgNew")
    bgImage.layer.zPosition = -1
    bgImage.isUserInteractionEnabled = false
    
//    bgImage.image = bgImage.image?.withRenderingMode(.alwaysTemplate)
//    bgImage.tintColor = UIColor(colorLiteralRed: 0/255, green: 0/255, blue: 0/255, alpha: 0.1)
    
    
    myVC.view.addSubview(bgImage)
    
    
    let blackView = UIView(frame: myVC.view.frame)
    blackView.backgroundColor = UIColor.black
    blackView.alpha = 0.3
    
    myVC.view.addSubview(blackView)
    
    //    myVC.view.backgroundColor = UIColor(patternImage: UIImage(named: "darkBg")!)
    
}

//func getBackGroundProfile(_ myVc: UIViewController) {
//    
//    //    myVC.view.backgroundColor = UIColor(patternImage: UIImage(named: "bg")!)
//   let ProfileViewController = CGRect(x: 0, y: 0, width: myVc.view.frame.width, height: myVc.view.frame.height)
//    myVc.addSubview(ProfileViewController)
//}


class LeftPaddedLabel:  UILabel {
    
    let padding = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 10)
    override func drawText(in rect: CGRect) {
        super.drawText(in: UIEdgeInsetsInsetRect(rect, padding))
    }
    // Override -intrinsicContentSize: for Auto layout code
    override var intrinsicContentSize : CGSize {
        let superContentSize = super.intrinsicContentSize
        let width = superContentSize.width + padding.left + padding.right
        let heigth = superContentSize.height + padding.top + padding.bottom
        return CGSize(width: width, height: heigth)
    }
    // Override -sizeThatFits: for Springs & Struts code
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        let superSizeThatFits = super.sizeThatFits(size)
        let width = superSizeThatFits.width + padding.left + padding.right
        let heigth = superSizeThatFits.height + padding.top + padding.bottom
        return CGSize(width: width, height: heigth)
    }
    
}


class LeftPaddedText:  UITextField {
    
    let padding = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 10)
    override func drawText(in rect: CGRect) {
        super.drawText(in: UIEdgeInsetsInsetRect(rect, padding))
    }
    // Override -intrinsicContentSize: for Auto layout code
    override var intrinsicContentSize : CGSize {
        let superContentSize = super.intrinsicContentSize
        let width = superContentSize.width + padding.left + padding.right
        let heigth = superContentSize.height + padding.top + padding.bottom
        return CGSize(width: width, height: heigth)
    }
    // Override -sizeThatFits: for Springs & Struts code
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        let superSizeThatFits = super.sizeThatFits(size)
        let width = superSizeThatFits.width + padding.left + padding.right
        let heigth = superSizeThatFits.height + padding.top + padding.bottom
        return CGSize(width: width, height: heigth)
    }
    
}


open class LoadingOverlay{
    
    var loader = UIView()
    var imageView1 = UIImageView()
    
    class var shared: LoadingOverlay {
        struct Static {
            static let instance: LoadingOverlay = LoadingOverlay()
        }
        return Static.instance
    }
    
    func showOverlay(_ view: UIView) {
        hideOverlayView()
        print("show loader")
        loader = UIView(frame:CGRect(x: 0, y: 0, width: 100, height: 100))
        view.addSubview(loader)
        loader.center = view.center
        let imageView1 = UIImageView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        imageView1.backgroundColor = UIColor.white
        imageView1.image = UIImage.gif(name: "loader")
        imageView1.contentMode = .scaleAspectFit
        loader.addSubview(imageView1)
        
    }
    
    func hideOverlayView() {
        
        print("hide overlay")
        if loader != nil {
            loader.removeFromSuperview()
        }else {
            //
        }
    }
}

func makeTLProfilePicture(_ image: UIImageView) {
    
    image.layer.cornerRadius = (37/100) * image.frame.width
    image.layer.borderWidth = 4.0
    image.layer.borderColor = UIColor.white.cgColor
    image.clipsToBounds = true
    image.contentMode = UIViewContentMode.scaleAspectFill
    
}
func makeTLProfilePicture(_ image: UIButton) {
    
    image.layer.cornerRadius = (37/100) * image.frame.width
    image.layer.borderWidth = 3.0
    image.layer.borderColor = endJourneyColor.cgColor
    image.clipsToBounds = true
    image.contentMode = UIViewContentMode.scaleAspectFit
    image.imageView?.contentMode = UIViewContentMode.scaleAspectFill
    
}

func makeTLProfilePictureBorderOrange(_ image: UIImageView) {
    
    image.layer.cornerRadius = (37/100) * image.frame.width
    image.layer.borderWidth = 2.0
    image.layer.borderColor = UIColor(hex: "FF6759").cgColor
    image.clipsToBounds = true
    image.contentMode = UIViewContentMode.scaleAspectFill
    
}


func makeTLProfilePictureBorderWhite(_ image: UIImageView) {
    
    image.layer.cornerRadius = (37/100) * image.frame.width
    image.layer.borderWidth = 2.0
    image.layer.borderColor = UIColor.white.cgColor
    image.clipsToBounds = true
    image.contentMode = UIViewContentMode.scaleAspectFill
    
}

func makeBuddiesTLProfilePicture(_ image: UIImageView) {
    
    image.layer.cornerRadius = (30/100) * image.frame.width
    image.layer.borderWidth = 1.0
    image.layer.borderColor = UIColor(colorLiteralRed: 86/255, green: 86/255, blue: 86/255, alpha: 0.8).cgColor
    image.clipsToBounds = true
    image.contentMode = UIViewContentMode.scaleAspectFill
    
}

func noColor(_ image: UIImageView) {
    
    image.layer.cornerRadius = (37/100) * image.frame.width
    image.clipsToBounds = true
    image.contentMode = UIViewContentMode.scaleAspectFill
    
}


func getThought (_ post:JSON) -> String {
    var retText = ""
    let location = post["checkIn"]["location"].string;
    let buddy = post["buddies"].arrayValue;
    if(post["thoughts"].stringValue != nil && post["thoughts"].stringValue != "") {
        retText = post["thoughts"].stringValue
        if(location != nil && location != "") {
            retText = retText + " at " + location!
            if(buddy.count == 1) {
                retText = retText + " with " + buddy[0]["name"].stringValue
            } else if (buddy.count == 2) {
                retText = retText + " with " + buddy[0]["name"].stringValue + " and " + buddy[1]["name"].stringValue
            } else if (buddy.count > 2) {
                let n = buddy.count - 1
                retText = retText + " with " + buddy[0]["name"].stringValue + " and " + String(n) + " others"
            }
        } else {
            if(buddy.count == 1) {
                retText = retText + " with " + buddy[0]["name"].stringValue
            } else if (buddy.count == 2) {
                retText = retText + " with " + buddy[0]["name"].stringValue + " and " + buddy[1]["name"].stringValue
            } else if (buddy.count > 2) {
                let n = buddy.count - 1
                retText = retText + " with " + buddy[0]["name"].stringValue + " and " + String(n) + " others"
            }
        }
    } else {
        if(location != nil && location != "") {
            retText = "At " + location!
            if(buddy.count == 1) {
                retText = retText + " with " + buddy[0]["name"].stringValue
            } else if (buddy.count == 2) {
                retText = retText + " with " + buddy[0]["name"].stringValue + " and " + buddy[1]["name"].stringValue
            } else if (buddy.count > 2) {
                let n = buddy.count - 1
                retText = retText + " with " + buddy[0]["name"].stringValue + " and " + String(n) + " others"
            }
        } else {
            if(buddy.count == 1) {
                retText = "With " + buddy[0]["name"].stringValue
            } else if (buddy.count == 2) {
                retText = "With " + buddy[0]["name"].stringValue + " and " + buddy[1]["name"].stringValue
            } else if (buddy.count > 2) {
                let n = buddy.count - 1
                retText = "With " + buddy[0]["name"].stringValue + " and " + String(n) + " others"
            }
        }
    }
    return retText
}


func getTypeOfPost(_ post:JSON) -> String {
    var str = ""
    if( post["checkIn"]["location"].stringValue != nil && post["checkIn"]["location"].stringValue != "" ) {
        str = "Location"
    } else if ( post["videos"].arrayValue.count > 0 ) {
        str = "Videos"
    } else if ( post["photos"].arrayValue.count > 0 ) {
        str = "Image"
    } else if ( post["thoughts"].string != nil && post["thoughts"].stringValue != "" ) {
        str = "Thoughts"
    }
    return str
}


func getImageURL(_ str: String,width:Int) -> URL {
    
    let isUrl = verifyUrl(str)
    var returnURL:URL!
    if isUrl {
        returnURL = URL(string:str)
    } else {
        let getImageUrl = adminUrl + "upload/readFile?file=" + str + "&width="+String(width)
        returnURL = URL(string:getImageUrl)
    }
    return returnURL
}

func darkBlur(_ view: UIView) {
    let darkBlur = UIBlurEffect(style: UIBlurEffectStyle.extraLight)
    let blurView = UIVisualEffectView(effect: darkBlur)
    blurView.frame.size.height = view.frame.height
    blurView.frame.size.width = view.frame.width
    blurView.layer.zPosition = -1
    blurView.alpha = 0.8
    view.backgroundColor = UIColor.lightText
    blurView.isUserInteractionEnabled = false
    view.addSubview(blurView)

}


func transparentCardWhite(_ view: UIView){
    view.backgroundColor = UIColor(colorLiteralRed: 255/255, green: 255/255, blue: 255/255, alpha: 0.8)
}


func transparentOrangeButton(_ button: UIButton) {
    button.backgroundColor = UIColor(colorLiteralRed: 255/255, green: 103/255, blue: 89/255, alpha: 0.8)
}

func transparentOrangeView(_ view: UIView) {
    view.backgroundColor = UIColor(colorLiteralRed: 255/255, green: 103/255, blue: 89/255, alpha: 0.8)
}

func transparentWhiteTextField(_ textField: UITextField){
    textField.backgroundColor = UIColor(colorLiteralRed: 255/255, green: 255/255, blue: 255/255, alpha: 0.8)
}

func transparentWhiteButton(_ button: UIButton){
    button.backgroundColor = UIColor(colorLiteralRed: 255/255, green: 255/255, blue: 255/255, alpha: 0.8)
}

func transparentCardWhiteImage(_ image: UIImageView){
    image.backgroundColor = UIColor(colorLiteralRed: 255/255, green: 255/255, blue: 255/255, alpha: 0.8)
}


func makeTLProfilePictureFollowers(_ image: UIImageView) {
    
    image.layer.cornerRadius = (37/100) * image.frame.width
//    image.layer.borderWidth = 4.0
    image.layer.borderColor = UIColor.white.cgColor
    image.clipsToBounds = true
    image.contentMode = UIViewContentMode.scaleAspectFill
    
}

func makeTLProfilePictureBorderWhiteCorner(_ image: UIImageView) {
    
    image.layer.cornerRadius = (50/100) * image.frame.width
    //image.layer.borderWidth = 2.0
    //image.layer.borderColor = UIColor.white.cgColor
    image.clipsToBounds = true
    image.contentMode = UIViewContentMode.scaleAspectFill
    
}

func makeSideNavigation(_ image: UIImageView) {
    
    image.layer.cornerRadius = (45/100) * image.frame.width
    //image.layer.borderWidth = 2.0
    //image.layer.borderColor = UIColor.white.cgColor
    image.clipsToBounds = true
    image.contentMode = UIViewContentMode.scaleAspectFill
    
}



func getDateFormat(_ date: String, format: String) -> String {
    
    let globalDateFormatter = DateFormatter()
    globalDateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSZ"
    let date = globalDateFormatter.date(from: date)
    
    let dayTimePeriodFormatter = DateFormatter()
    dayTimePeriodFormatter.dateFormat = format
    let goodDate = dayTimePeriodFormatter.string(from: date!)
    return goodDate
    
}

func getMonthFormat(_ date: String) -> String {
    
    let globalDateFormatter = DateFormatter()
    globalDateFormatter.dateFormat = "MM-yyyy"
    let date = globalDateFormatter.date(from: date)
    
    let dayTimePeriodFormatter = DateFormatter()
    dayTimePeriodFormatter.dateFormat = "MMMM yyyy"
    let goodDate = dayTimePeriodFormatter.string(from: date!)
    return goodDate
    
}

func loader(_ view: UIView) {
    let imageView1 = UIImageView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
    imageView1.backgroundColor = UIColor.white
    imageView1.image = UIImage.gif(name: "loader")
    imageView1.contentMode = UIViewContentMode.center
    view.addSubview(imageView1)
 
}

//func removeLoader(View: UIImage) {
//    
//}


func heightForView(text:String, font:UIFont, width:CGFloat) -> CGFloat{
    let label:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
    label.numberOfLines = 0
    label.lineBreakMode = NSLineBreakMode.byWordWrapping
    label.font = font
    label.text = text
    
    label.sizeToFit()
    return label.frame.height
}

func getWidthOfText(text:String, font:UIFont) -> CGFloat{
    let fontAttributes = [NSFontAttributeName: font]
    let size = (text as NSString).size(attributes: fontAttributes)
    return size.width
}

func getRegularString(string: String) -> NSMutableAttributedString {
    return NSMutableAttributedString(string: string, 
                              attributes: [NSFontAttributeName: UIFont(name: "Avenir-Medium", size: 14)!])
}

func getBoldString(string: String) -> NSMutableAttributedString {
    return NSMutableAttributedString(string: string, 
                              attributes: [NSFontAttributeName: UIFont(name: "Avenir-Black", size: 14)!])
}

func getRedString(string: String) -> NSMutableAttributedString {
    return NSMutableAttributedString(string: string, 
                                     attributes: [NSForegroundColorAttributeName: UIColor.red])
}

func convertDateFormate(dateStr : String) -> String{
    
    let globalDateFormatter = DateFormatter()
    globalDateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSZ"
    let date = globalDateFormatter.date(from: dateStr)
    
    // Day
    let calendar = Calendar.current
    let anchorComponents = calendar.dateComponents([.day, .month, .year], from: date!)
    
    // Formate    
    globalDateFormatter.dateFormat = "MMMM, yy"
    let newDate = globalDateFormatter.string(from: date!)
    
    var day  = "\(anchorComponents.day!)"
    switch (day) {
    case "1" , "21" , "31":
        day.append("st")
    case "2" , "22":
        day.append("nd")
    case "3" ,"23":
        day.append("rd")
    default:
        day.append("th")
    }
    return day + " " + newDate
}

func getPlainTextFromHTMLContentText(str : String?) -> String {
    
    if str != nil && str != "" {
        do {
            let regex =  "<[^>]+>"
            let expr = try NSRegularExpression(pattern: regex, options: NSRegularExpression.Options.caseInsensitive)
            let replacement = expr.stringByReplacingMatches(in: str!, options: [], range: NSMakeRange(0, (str!.characters.count)), withTemplate: "")
            return replacement
            //replacement is the result
        } catch {
            // regex was bad!
        }
    }
    return ""
}

//LoadingOverlay.shared.showOverlay(self.view)
////To to long tasks
//LoadingOverlay.shared.hideOverlayView()
