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
    myVC.view.sendSubview(toBack: bgImage)
    
    let blackView = UIView(frame: myVC.view.frame)
    blackView.backgroundColor = UIColor.black
    blackView.alpha = 0.3
    myVC.view.addSubview(blackView)
    myVC.view.sendSubview(toBack: blackView)
    
    //    myVC.view.backgroundColor = UIColor(patternImage: UIImage(named: "darkBg")!)
    
}

func getDarkBackGroundNew(_ myVC: UIViewController) {
    
    let bgImage = UIImageView(frame: myVC.view.frame)
    bgImage.image = UIImage(named: "darkBgNew")
    bgImage.layer.zPosition = -1
    bgImage.isUserInteractionEnabled = false
    
    //    bgImage.image = bgImage.image?.withRenderingMode(.alwaysTemplate)
    //    bgImage.tintColor = UIColor(colorLiteralRed: 0/255, green: 0/255, blue: 0/255, alpha: 0.1)
    
    
    myVC.view.addSubview(bgImage)
//    myVC.view.sendSubview(toBack: bgImage)
    
    let blackView = UIView(frame: myVC.view.frame)
    blackView.backgroundColor = UIColor.black
    blackView.alpha = 0.3
    myVC.view.addSubview(blackView)
//    myVC.view.sendSubview(toBack: blackView)
    
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
        
        let darkBlur = UIBlurEffect(style: UIBlurEffectStyle.dark)
        let blurView = UIVisualEffectView(effect: darkBlur)
        blurView.frame.size.height = view.frame.height
        blurView.frame.size.width = screenWidth
        blurView.layer.zPosition = 6000000
        blurView.isUserInteractionEnabled = false

        loader = UIView(frame:CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height))
        
        let imageView1 = UIImageView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        imageView1.backgroundColor = UIColor.clear
        imageView1.image = UIImage.gif(name: "200_200")
        imageView1.contentMode = .scaleAspectFit
        imageView1.center = CGPoint(x: view.center.x, y: ((view.frame.size.height/2) - ( globalNavigationController != nil ? (globalNavigationController?.navigationBar.frame.size.height)! : 0) ))
        blurView.addSubview(imageView1)
         loader.addSubview(blurView)
//        loader.backgroundColor = UIColor(colorLiteralRed: 0/255, green: 0/255, blue: 0/255, alpha: 0.4)
        view.addSubview(loader)
        
    }
    
    func hideOverlayView() {
        if loader != nil {
            loader.removeFromSuperview()
        }else {
            //
        }
    }
}


func makeMenuProfilePicture(_ image: UIImageView) {
    
    image.layer.cornerRadius = (40/100) * image.frame.width
    image.layer.borderWidth = 2.0
    image.layer.borderColor = UIColor.white.cgColor
    image.clipsToBounds = true
    image.contentMode = UIViewContentMode.scaleAspectFill
    
}


func makeTLProfilePicture(_ image: UIImageView) {
    
    image.layer.cornerRadius = (37/100) * image.frame.width
    image.layer.borderWidth = 4.0
    image.layer.borderColor = UIColor.white.cgColor
    image.clipsToBounds = true
    image.contentMode = UIViewContentMode.scaleAspectFill
    
}

func makeTLProfilePictureNew(_ image: UIImageView) {
    
    image.layer.cornerRadius = (37/100) * image.frame.width
    image.layer.borderWidth = 2.0
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

func makeBuddiesTLProfilePicture1(_ image: UIImageView) {
    
    image.layer.cornerRadius = (25/100) * image.frame.width
//    image.layer.borderWidth = 1.0
//    image.layer.borderColor = UIColor(hex: "#868686").cgColor
    image.clipsToBounds = true
    image.contentMode = UIViewContentMode.scaleAspectFill
    
}


func makeBuddiesTLProfilePicture(_ image: UIImageView) {
    
    image.layer.cornerRadius = (37/100) * image.frame.width
    image.layer.borderWidth = 1.0
    image.layer.borderColor = UIColor(hex: "#868686").cgColor
    image.clipsToBounds = true
    image.contentMode = UIViewContentMode.scaleAspectFill
    
}

func HiBye(_ image: UIImageView) {
    
    image.layer.cornerRadius = (35/100) * image.frame.width
    image.layer.borderWidth = 2.0
    image.layer.borderColor = UIColor(hex: "#868686").cgColor
    image.clipsToBounds = true
    image.contentMode = UIViewContentMode.scaleAspectFill
    
}


func noColor(_ image: UIImageView) {
    
    image.layer.cornerRadius = (37/100) * image.frame.width
    image.clipsToBounds = true
    image.contentMode = UIViewContentMode.scaleAspectFill
    
}


func getThought (_ post:JSON) ->  NSMutableAttributedString {
  
    var retText = NSMutableAttributedString(string: "")
    let location = post["checkIn"]["location"].string;
    let buddy = post["buddies"].arrayValue;
    if(post["thoughts"].stringValue != nil && post["thoughts"].stringValue != "") {
//        retText = post["thoughts"].stringValue
        retText.append(getRegularString(string: post["thoughts"].stringValue, size: 15))
        if(location != nil && location != "") {
//            retText = retText + " at " + location!
            retText.append(getRegularString(string: " at ", size: 15))
            retText.append(getBoldString(string: location!, size: 15))
            
            if(buddy.count == 1) {
//                retText = retText + " with " + buddy[0]["name"].stringValue
                retText.append(getRegularString(string: " with ", size: 15))
                retText.append(getBoldString(string: buddy[0]["name"].stringValue, size: 15))
            } else if (buddy.count == 2) {
//                retText = retText + " with " + buddy[0]["name"].stringValue + " and " + buddy[1]["name"].stringValue
                retText.append(getRegularString(string: " with ", size: 15))
                retText.append(getBoldString(string: buddy[0]["name"].stringValue, size: 15))
                retText.append(getRegularString(string: " and ", size: 15))
                 retText.append(getBoldString(string: buddy[1]["name"].stringValue, size: 15))

            } else if (buddy.count > 2) {
                let n = buddy.count - 1
//                retText = retText + " with " + buddy[0]["name"].stringValue + " and " + String(n) + " others"
                retText.append(getRegularString(string: " with ", size: 15))
                retText.append(getBoldString(string: buddy[0]["name"].stringValue, size: 15))
                retText.append(getRegularString(string: " and ", size: 15))
                retText.append(getRegularString(string: " String(n) ", size: 15))
                retText.append(getRegularString(string: " others", size: 15))
            }
        } else {
            if(buddy.count == 1) {
//                retText = retText + " with " + buddy[0]["name"].stringValue
                retText.append(getRegularString(string: " with ", size: 15))
                retText.append(getBoldString(string: buddy[0]["name"].stringValue, size: 15))

            } else if (buddy.count == 2) {
//                retText = retText + " with " + buddy[0]["name"].stringValue + " and " + buddy[1]["name"].stringValue
                retText.append(getRegularString(string: " with ", size: 15))
                retText.append(getBoldString(string: buddy[0]["name"].stringValue, size: 15))
                retText.append(getRegularString(string: " and ", size: 15))
                retText.append(getBoldString(string: buddy[1]["name"].stringValue, size: 15))
            } else if (buddy.count > 2) {
                let n = buddy.count - 1
//                retText = retText + " with " + buddy[0]["name"].stringValue + " and " + String(n) + " others"
                retText.append(getRegularString(string: " with ", size: 15))
                retText.append(getBoldString(string: buddy[0]["name"].stringValue, size: 15))
                retText.append(getRegularString(string: " and ", size: 15))
                retText.append(getRegularString(string: " String(n) ", size: 15))
                retText.append(getRegularString(string: " others", size: 15))
            }
        }
    } else {
        if(location != nil && location != "") {
//            retText = "At " + location!
            retText.append(getRegularString(string: "At ", size: 15))
            retText.append(getBoldString(string: location!, size: 15))

            if(buddy.count == 1) {
//                retText = retText + " with " + buddy[0]["name"].stringValue
                retText.append(getRegularString(string: " with ", size: 15))
                retText.append(getBoldString(string: buddy[0]["name"].stringValue, size: 15))

            } else if (buddy.count == 2) {
//                retText = retText + " with " + buddy[0]["name"].stringValue + " and " + buddy[1]["name"].stringValue
                retText.append(getRegularString(string: " with ", size: 15))
                retText.append(getBoldString(string: buddy[0]["name"].stringValue, size: 15))
                retText.append(getRegularString(string: " and ", size: 15))
                retText.append(getBoldString(string: buddy[1]["name"].stringValue, size: 15))
            } else if (buddy.count > 2) {
                let n = buddy.count - 1
//                retText = retText + " with " + buddy[0]["name"].stringValue + " and " + String(n) + " others"
                retText.append(getRegularString(string: " with ", size: 15))
                retText.append(getBoldString(string: buddy[0]["name"].stringValue, size: 15))
                retText.append(getRegularString(string: " and ", size: 15))
                retText.append(getRegularString(string: " String(n) ", size: 15))
                retText.append(getRegularString(string: " others", size: 15))

            }
        } else {
            if(buddy.count == 1) {
//                retText = "With " + buddy[0]["name"].stringValue
                retText.append(getRegularString(string: "With ", size: 15))
                retText.append(getBoldString(string: buddy[0]["name"].stringValue, size: 15))

            } else if (buddy.count == 2) {
//                retText = "With " + buddy[0]["name"].stringValue + " and " + buddy[1]["name"].stringValue
                retText.append(getRegularString(string: "With ", size: 15))
                retText.append(getBoldString(string: buddy[0]["name"].stringValue, size: 15))
                retText.append(getRegularString(string: " and ", size: 15))
                retText.append(getBoldString(string: buddy[1]["name"].stringValue, size: 15))

            } else if (buddy.count > 2) {
                let n = buddy.count - 1
//              retText = "With " + buddy[0]["name"].stringValue + " and " + String(n) + " others"
                retText.append(getRegularString(string: "With ", size: 15))
                retText.append(getBoldString(string: buddy[0]["name"].stringValue, size: 15))
                retText.append(getRegularString(string: " and ", size: 15))
                retText.append(getRegularString(string: " String(n) ", size: 15))
                retText.append(getRegularString(string: " others", size: 15))

                
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
    image.layer.borderWidth = 2.0
    image.layer.borderColor = UIColor.white.cgColor
    image.clipsToBounds = true
    image.contentMode = UIViewContentMode.scaleAspectFill
    
}

func makeFlagBorderWhiteCorner(_ image: UIImageView) {
    
    image.layer.cornerRadius = (50/100) * image.frame.width
    image.layer.borderWidth = 2.0
    image.layer.borderColor = UIColor.white.cgColor
    image.clipsToBounds = true
    image.contentMode = UIViewContentMode.scaleAspectFill
    
}

func makeSideNavigation(_ image: UIImageView) {
    
    image.layer.cornerRadius = (41/100) * image.frame.width
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
    dayTimePeriodFormatter.dateFormat = "dd MMM, yyyy"
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

func heightForView(text:String, font:UIFont, width:CGFloat) -> CGFloat{
    let label:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
    label.numberOfLines = 0
    label.lineBreakMode = .byWordWrapping
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

func getRegularString(string: String, size: Int) -> NSMutableAttributedString {
    return NSMutableAttributedString(string: string, 
                              attributes: [NSFontAttributeName: UIFont(name: "Avenir-Medium", size: CGFloat(size))!, NSForegroundColorAttributeName: mainBlueColor])
}

func getRegularRomanString(string: String, size: Int) -> NSMutableAttributedString {
    return NSMutableAttributedString(string: string, 
                                     attributes: [NSFontAttributeName: UIFont(name: "Avenir-Roman", size: CGFloat(size))!, NSForegroundColorAttributeName: UIColor.black])
}

func getBoldString(string: String, size: Int) -> NSMutableAttributedString {
    return NSMutableAttributedString(string: string, 
                              attributes: [NSFontAttributeName: UIFont(name: "Avenir-Heavy", size: CGFloat(size))!, NSForegroundColorAttributeName: mainBlueColor])
}

func getRedString(string: String) -> NSMutableAttributedString {
    return NSMutableAttributedString(string: string, 
                                     attributes: [NSForegroundColorAttributeName: UIColor.red])
}

func getHyperlinkedString(string: String, size: Int, hyperlink: String, color:UIColor ) -> NSMutableAttributedString {
    return NSMutableAttributedString(string: string, 
                                     attributes: [NSFontAttributeName: UIFont(name: "Avenir-Roman", size: CGFloat(size))!,                                                  
                                                  NSUnderlineStyleAttributeName: NSUnderlineStyle.styleSingle.rawValue,
                                                  NSForegroundColorAttributeName: color])
}

func addImage(imageName: String) -> NSMutableAttributedString {
    let attachment:NSTextAttachment = NSTextAttachment()    
    attachment.image = UIImage(named: imageName)
    attachment.bounds = CGRect(x: 0, y: 0, width: 25, height: 25)
    return NSAttributedString(attachment: attachment) as! NSMutableAttributedString
}

func getColorString(string: String, font: UIFont, color: UIColor) -> NSMutableAttributedString {
    return NSMutableAttributedString(string: string, 
                                     attributes: [NSFontAttributeName: font, NSForegroundColorAttributeName: color])
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

func shouldShowBigImage(position: Int) -> Bool {
    if position == 0 || position % 4 == 0 {
        return true
    }
    else {
        return false
    }
}

func setFollowButtonTitle(button:UIButton, followType: Int) {
    if followType == 1 {
        button.setTitle("Following", for: .normal)
        button.tag = 1
    }
    else if followType == 2 {
        button.setTitle("Requested", for: .normal)
        button.tag = 2
    }
    else if followType == 0 {
        button.setTitle("Follow", for: .normal)
        button.tag = 0
    }
}

func getFirstLetterCapitalizedString(nameOfString : String) -> String {
    if nameOfString.characters.count > 1 {
        let index = nameOfString.index(nameOfString.startIndex, offsetBy: 0)
        return "\(String(nameOfString[index]).uppercased())\(String(nameOfString.characters.dropFirst()))"
    }
    return nameOfString
}

func getDigitWithCommaStandards(originalDigitStr : String) -> String {
    
    let numberFormatter = NumberFormatter()
    numberFormatter.numberStyle = .decimal
    let currency = numberFormatter.string(from: NSNumber(value: (Int64(originalDigitStr))!))
    if currency != nil {
        return currency!
    }
    return ""
}

//MARK: - Invite

func inviteToAppClicked(sender: UIView, onView:UIViewController) {
    
    let newContent = "Hi, \((user.getUser(user.getExistingUser())).Name) thinks you'd love TraveLibro. Its a Travel Social Network that lets you Capture, Inspire and Relive your Travel Life | Local Life. It's really quick and easy! Download app to capture your entire life and inspire a world of travellers. \n\n  iOS : http://apple.co/1TYeGs5 \n Android : http://bit.ly/1WDUiCN  \n Web : http://travelibro.com "
    
    let objectsToShare = [newContent]
    let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)

    //Excluded Activities Code
    activityVC.excludedActivityTypes = [UIActivityType.addToReadingList, UIActivityType.assignToContact, UIActivityType.copyToPasteboard, UIActivityType.saveToCameraRoll, UIActivityType.airDrop]
    
    activityVC.popoverPresentationController?.sourceView = sender            
    onView.present(activityVC, animated: true, completion: nil)   
}




func sharingUrl(url: String, onView:UIViewController) {
    let content = url
    
    let objectsToShare = [content]
    let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
    
    //Excluded Activities Code
    activityVC.excludedActivityTypes = [UIActivityType.addToReadingList, UIActivityType.assignToContact, UIActivityType.copyToPasteboard, UIActivityType.saveToCameraRoll, UIActivityType.airDrop]
    
//    activityVC.popoverPresentationController?.sourceView = sender
    onView.present(activityVC, animated: true, completion: nil)
}




//LoadingOverlay.shared.showOverlay(self.view)
////To to long tasks
//LoadingOverlay.shared.hideOverlayView()
