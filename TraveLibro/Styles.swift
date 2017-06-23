//
//  Styles.swift
//  TraveLibro
//
//  Created by Midhet Sulemani on 09/05/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit
import AVFoundation

func getDocumentsDirectory() -> URL {
    let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    let documentsDirectory = paths[0]
    return documentsDirectory
}

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
    bgImage.image = UIImage(named: "back_7_4")
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
//    bgImage.image = UIImage(named: "darkBgNew")
    bgImage.image = UIImage(named: "back_7_4")
//    bgImage.backgroundColor = UIColor.white
    bgImage.layer.zPosition = -1
    bgImage.isUserInteractionEnabled = false
    myVC.view.addSubview(bgImage)
    myVC.view.sendSubview(toBack: bgImage)
    
}

func getDarkBackGroundBlur(_ myVC: UIViewController) -> Void {
    
    let bgImage = UIImageView(frame: myVC.view.frame)
    bgImage.image = UIImage(named: "back_7_4")
    bgImage.layer.zPosition = -1
    bgImage.isUserInteractionEnabled = false
    
    myVC.view.addSubview(bgImage)
    myVC.view.sendSubview(toBack: bgImage)
    
    //    myVC.view.backgroundColor = UIColor(patternImage: UIImage(named: "darkBg")!)
    
}

func getDarkBackGroundBlue(_ myVC: UIViewController) {
    
    let bgImage = UIImageView(frame: myVC.view.frame)
    bgImage.image = UIImage(named: "back_7_4")
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
    bgImage.image = UIImage(named: "back_7_4")
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
open class BlurOnView{
    
    var loader: UIView?
    var imageView1 = UIImageView()
    
//    class var shared: BlurOnView {
//        struct Static {
//            static let instance: BlurOnView = BlurOnView()
//        }
//        return Static.instance
//    }
    
    func showBlur(_ view: UIView) {
        print("show loader : viewYPos : \(view.frame.origin.y)")
        
        let darkBlur = UIBlurEffect(style: UIBlurEffectStyle.dark)
        let blurView = UIVisualEffectView(effect: darkBlur)
        blurView.frame.size.height = view.frame.height + 50
        blurView.frame.size.width = view.frame.width + 50
        blurView.layer.zPosition = 6000000
        blurView.isUserInteractionEnabled = false
        
        loader = UIView(frame:CGRect(x: 0, y: 0, width: view.frame.size.width + 50, height: view.frame.size.height + 50))
        
        
        loader!.addSubview(blurView)
        view.addSubview(loader!)
        
    }
    
}

open class LoadingOverlay{
    
    var overlayView = UIView()
    var activityIndicator = UIActivityIndicatorView()
    var blurView: UIVisualEffectView!
    
    class var shared: LoadingOverlay {
        struct Static {
            static let instance: LoadingOverlay = LoadingOverlay()
            
        }
        return Static.instance
    }
    
    public func showOverlay(_ view: UIView) {
        hideOverlayView()
        overlayView.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        overlayView.center = CGPoint(x: (screenWidth/2), y: (view.frame.size.height/2))
        overlayView.backgroundColor = UIColor.clear
        overlayView.clipsToBounds = true
        overlayView.layer.cornerRadius = 10
        
        let darkBlur = UIBlurEffect(style: UIBlurEffectStyle.dark)
        blurView = UIVisualEffectView(effect: darkBlur)
        blurView.frame.size.height = view.frame.height
        blurView.frame.size.width = screenWidth
        blurView.isUserInteractionEnabled = false
        blurView.addSubview(overlayView)
        
        activityIndicator.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        activityIndicator.activityIndicatorViewStyle = .whiteLarge
        activityIndicator.center = CGPoint(x: overlayView.bounds.width / 2, y: overlayView.bounds.height / 2)
        activityIndicator.color = mainOrangeColor
        
        overlayView.addSubview(activityIndicator)
        view.addSubview(blurView)
        
        activityIndicator.startAnimating()
    }
    
    public func hideOverlayView() {
        if blurView != nil {
            activityIndicator.stopAnimating()
            blurView.removeFromSuperview()
            blurView = nil
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
  
    let retText = NSMutableAttributedString(string: "")
    let location = post["checkIn"]["location"].string;
    let buddy = post["buddies"].arrayValue;
    if(post["thoughts"].stringValue != "" && post["thoughts"].stringValue != "") {
//        retText = post["thoughts"].stringValue
        retText.append(getRegularString(string: post["thoughts"].stringValue.trimmingCharacters(in: CharacterSet.whitespaces), size: TL_REGULAR_FONT_SIZE))
        if(location != nil && location != "") {
//            retText = retText + " at " + location!
            retText.append(getRegularString(string: " at ", size: TL_REGULAR_FONT_SIZE))
            retText.append(getBoldString(string: location!.trimmingCharacters(in: CharacterSet.whitespaces), size: TL_REGULAR_FONT_SIZE))

            retText.append(getBuddiesString(buddies: buddy))            
        } else {
            retText.append(getBuddiesString(buddies: buddy))
        }
    } 
    else {
        if(location != nil && location != "") {
            retText.append(getRegularString(string: "At ", size: TL_REGULAR_FONT_SIZE))
            retText.append(getBoldString(string: location!.trimmingCharacters(in: CharacterSet.whitespaces), size: TL_REGULAR_FONT_SIZE))

            retText.append(getBuddiesString(buddies: buddy))
        }
        else {
            retText.append(getBuddiesString(buddies: buddy))
        }
    }
    
    return retText
}


func getThoughtForLocalPost (_ post: Post) ->  NSMutableAttributedString {
    
    let retText = NSMutableAttributedString(string: "")
    let location = post.post_location
    let buddy = post.buddyJson
    
    if(post.post_thoughts != "" ) {
        retText.append(getRegularString(string: post.post_thoughts.trimmingCharacters(in: CharacterSet.whitespaces), size: TL_REGULAR_FONT_SIZE))
        if(location != nil && location != "") {
            retText.append(getRegularString(string: " at ", size: TL_REGULAR_FONT_SIZE))
            retText.append(getBoldString(string: location!.trimmingCharacters(in: CharacterSet.whitespaces), size: TL_REGULAR_FONT_SIZE))
            
            retText.append(getBuddiesString(buddies: buddy))
        } else {
            retText.append(getBuddiesString(buddies: buddy))
        }
    } 
    else {
        if(location != nil && location != "") {            
            retText.append(getRegularString(string: "At ", size: TL_REGULAR_FONT_SIZE))
            retText.append(getBoldString(string: location!.trimmingCharacters(in: CharacterSet.whitespaces), size: TL_REGULAR_FONT_SIZE))
            
            retText.append(getBuddiesString(buddies: buddy))
        }
        else {
            retText.append(getBuddiesString(buddies: buddy))
        }
    }
    
    return retText
}

func getBuddiesString (buddies: [JSON]) -> NSMutableAttributedString {
    let buddyText = NSMutableAttributedString(string: "") 
   
    if buddies.isNotEmpty {
        if(buddies.count == 1) {
            //                retText = retText + " with " + buddy[0]["name"].stringValue
            buddyText.append(getRegularString(string: " with ", size: TL_REGULAR_FONT_SIZE))
            buddyText.append(getBoldString(string: buddies[0]["name"].stringValue, size: TL_REGULAR_FONT_SIZE))
        } else {
            buddyText.append(getRegularString(string: " with ", size: TL_REGULAR_FONT_SIZE))
            for i in 0..<buddies.count {
                let buddyVal = buddies[i]
                
                if i == (buddies.count - 2) {
                    buddyText.append(getBoldString(string: "\(buddyVal["name"].stringValue) and ", size: TL_REGULAR_FONT_SIZE))                            
                }
                else if i == (buddies.count-1) {
                    buddyText.append(getBoldString(string: "\(buddyVal["name"].stringValue)", size: TL_REGULAR_FONT_SIZE))
                }
                else {                        
                    buddyText.append(getBoldString(string: "\(buddyVal["name"].stringValue), ", size: TL_REGULAR_FONT_SIZE))
                }
            }
        }
    }
    
    return buddyText
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
        if width == 0 {
            let getImageUrl = adminUrl + "upload/readFile?file=" + str + "&width="+String(800)
            returnURL = URL(string:getImageUrl)
        }else{
            let getImageUrl = adminUrl + "upload/readFile?file=" + str + "&width="+String(width)
            returnURL = URL(string:getImageUrl)
        }
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

func makeTLProfilePictureBorder(_ image: UIImageView, borderColor: UIColor) {
    
    image.layer.cornerRadius = (50/100) * image.frame.width
    image.layer.borderWidth = 2.0
    image.layer.borderColor = borderColor.cgColor
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
    if date != nil && date != "" {

    let globalDateFormatter = DateFormatter()
    globalDateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSZ"
    let date = globalDateFormatter.date(from: date)
    
    let dayTimePeriodFormatter = DateFormatter()
    dayTimePeriodFormatter.dateFormat = format
    let goodDate = dayTimePeriodFormatter.string(from: date!)
        return goodDate
    }
    return ""
}

func getFormat(_ date: String, formate: String) -> String {
    
    if date != nil && date != "" {

        let globalDateFormatter = DateFormatter()
        globalDateFormatter.dateFormat = date
        let date = globalDateFormatter.date(from: date)
        
        let dayTimePeriodFormatter = DateFormatter()
        dayTimePeriodFormatter.dateFormat = formate
        let goodDate = dayTimePeriodFormatter.string(from: date!)
        return goodDate
    }
    return ""
}


func getMonthFormat(_ date: String) -> String {
    
    if date != nil && date != "" {
        let globalDateFormatter = DateFormatter()
        globalDateFormatter.dateFormat = "MM-yyyy"
        let date = globalDateFormatter.date(from: date)
        
        let dayTimePeriodFormatter = DateFormatter()
        dayTimePeriodFormatter.dateFormat = "MMMM, yyyy"
        let goodDate = dayTimePeriodFormatter.string(from: date!)
        return goodDate
    }
    return ""
    
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

func heightOfAttributedText(attributedString: NSMutableAttributedString, width: CGFloat) -> CGFloat {
    let rect = attributedString.boundingRect(with: CGSize(width: width, height: 10000), options: .usesLineFragmentOrigin, context: nil)
    return (rect.size.height + 10 )     //10 is offset
}

func getWidthOfText(text:String, font:UIFont) -> CGFloat{
    let fontAttributes = [NSFontAttributeName: font]
    let size = (text as NSString).size(attributes: fontAttributes)
    return size.width
}

func getTrimmedString(inputString: String) -> String {
    let trimmedString = inputString.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    return trimmedString
}

func getRegularStringWithColor(string: String, size: Int, color: UIColor) -> NSMutableAttributedString {
    return NSMutableAttributedString(string: string, 
                                     attributes: [NSFontAttributeName: UIFont(name: "Avenir-Medium", size: CGFloat(size))!, NSForegroundColorAttributeName: color])
}

func getBoldStringWithColor(string: String, size: Int, color: UIColor) -> NSMutableAttributedString {
    return NSMutableAttributedString(string: string, 
                                     attributes: [NSFontAttributeName: UIFont(name: "Avenir-Heavy", size: CGFloat(size))!, NSForegroundColorAttributeName: color])
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

func shouldShowBigImage(position: Int) -> Bool {
    if position == 0 || position % 4 == 0 {
        return true
    }
    else {
        return false
    }
}

//func resizeText(label:UILabel, width:Double, divider:Double) -> UIFont {
//    <#function body#>
//}

func setFollowButtonTitle(button:UIButton, followType: Int, otherUserID: String) {
    
    if otherUserID == "admin" || isSelfUser(otherUserID: otherUserID) {
        button.isHidden = true
    }
    else{
        button.isHidden = false
        
        if followType == 1 {
            button.setTitle("Following", for: .normal)
//            button.tag = 1
        }
        else if followType == 2 {
            button.setTitle("Requested", for: .normal)
//            button.tag = 2
        }
        else if followType == 0 {
            button.setTitle("Follow", for: .normal)
//            button.tag = 0
        }
    }
}

func setFollowButtonImage(button:UIButton, followType: Int, otherUserID: String) {
    
    if isSelfUser(otherUserID: otherUserID) {
        button.isHidden = true
    }
    else{
        button.isHidden = false
        
        if followType == 1 {
            button.tag = 1
            button.setImage(UIImage(named:"following"), for: .normal)
        }
        else if followType == 0 {
            button.tag = 0
            button.setImage(UIImage(named:"follow"), for: .normal)
        }
        else if followType == 2 {
            button.tag = 2
            button.setImage(UIImage(named:"requested"), for: .normal)
        }
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

func isLocalFeed(feed: JSON) -> Bool {
    if feed["user"].dictionaryValue.isEmpty {
        return true
    }
    return false
}


func changeDateFormat(_ givenFormat: String, getFormat: String, date: String, isDate: Bool) -> String {
    
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = givenFormat
    let date = dateFormatter.date(from: date)
    
    dateFormatter.dateFormat = getFormat
    
    if isDate {
        
        dateFormatter.dateStyle = .medium
        
    }
    var goodDate = "";
    if(date != nil) {
        goodDate = dateFormatter.string(from: date!)
    }
    return goodDate
}

//MARK: - Sort JSON Array

func sortJSONArray(inputArray:[JSON], key: String) -> [JSON] {
    
    let result = inputArray.sorted {
        switch ($0[key], $1[key]) {
        case (nil, nil), (_, nil):
            return true
        case (nil, _):
            return false
        case let (lhs as String, rhs as String):
            return lhs < rhs
        case let (lhs as Int, rhs as Int):
            return  lhs < rhs
        // Add more for Double, Date, etc.
        default:
            return true
        }
    }
    
    return result
}

//MARK: - PlaceHolder Image

func getPlaceholderImage() -> UIImage {
    return UIImage(named: "logo-default")!
}


//MARK: - Invite

func inviteToAppClicked(sender: UIView, onView:UIViewController) {
    
    if user.getExistingUser()  != "" {
        
        let newContent = "Hi, \((user.getUser(user.getExistingUser())).Name) thinks you'd love TraveLibro. Its a Travel Social Network that lets you Capture, Inspire and Relive your Travel Life | Local Life. It's really quick and easy! Download app to capture your entire life and inspire a world of travellers. \n\n  iOS : http://apple.co/1TYeGs5 \n Android : http://bit.ly/1WDUiCN  \n Web : http://travelibro.com "
        
        let objectsToShare = [newContent]
        let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
        
        //Excluded Activities Code
        activityVC.excludedActivityTypes = [UIActivityType.addToReadingList, UIActivityType.assignToContact, UIActivityType.copyToPasteboard, UIActivityType.saveToCameraRoll, UIActivityType.airDrop]
        
        activityVC.popoverPresentationController?.sourceView = sender            
        onView.present(activityVC, animated: true, completion: nil)
    }
    else {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "NO_LOGGEDIN_USER_FOUND"), object: nil)
    }
}


func sharingUrl(url: String, onView: UIViewController) {
    let content = url
    
    let objectsToShare = [content]
    let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
    
    //Excluded Activities Code
    activityVC.excludedActivityTypes = [UIActivityType.addToReadingList, UIActivityType.assignToContact, UIActivityType.copyToPasteboard, UIActivityType.saveToCameraRoll, UIActivityType.airDrop]
    
//    activityVC.popoverPresentationController?.sourceView = sender
    onView.present(activityVC, animated: true, completion: nil)
}


//MARK: - Current User Check

func isSelfUser(otherUserID: String) -> Bool {    
    if otherUserID == user.getExistingUser() {
        return true
    }
    else {
        return false
    }
}

func isSelfUserLoggedIn() -> Bool {
    if currentUser != nil {
        if isSelfUser(otherUserID: currentUser["_id"].stringValue) {
            return true
        }
        else {
            return false
        }
    }
    
    return false
}


//MARK: - Video thumbnail

func getThumbnailFromVideoURL(url : URL, onView: UIImageView) {
    DispatchQueue.global().async {
        onView.contentMode = UIViewContentMode.scaleAspectFill
        onView.clipsToBounds = true
        var image = UIImage(named: "logo-default")
        let asset = AVURLAsset(url: url, options: nil)
        let imgGenerator = AVAssetImageGenerator(asset: asset)
        do {
            let imageRef = try imgGenerator.copyCGImage(at: CMTimeMake(0, 1), actualTime: nil)
            image = UIImage(cgImage: imageRef)
            DispatchQueue.main.async(execute: {
                onView.image = image
            })
        } catch {
            print(error)
            DispatchQueue.main.async(execute: {
                onView.image = image
            })
        }
    }
}


//MARK:- Present Action View

func showPopover(optionsController:UIAlertController, sender:UIView, vc:UIViewController){
    if let popover = optionsController.popoverPresentationController{
        popover.sourceView = sender
        popover.sourceRect = sender.bounds
    }
    vc.present(optionsController, animated: true, completion: nil)
}

//MARK: - Helpers

func getURLSlug(slug: String) -> String {
    var myString = slug
    myString.remove(at: myString.startIndex)
    return myString
}

//MARK: - Location Error Handler

func handleRestrictedMode(onVC: UIViewController) {
    print("\n handle restricted mode")
    
    let errorAlert = UIAlertController(title: "Turn on Location Services", message: "1. Tap Settings \n 2. Tap Location \n Tap While Using the App", preferredStyle: UIAlertControllerStyle.alert)
    
    let cancelAction = UIAlertAction(title: "Not Now", style: .default, handler: nil)
    errorAlert.addAction(cancelAction)
    
    let settingsAction = UIAlertAction(title: "Settings", style: .default) { (_) -> Void in
        guard let settingsUrl = URL(string: UIApplicationOpenSettingsURLString) else {
            return
        }            
        if UIApplication.shared.canOpenURL(settingsUrl) {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                    print("Settings opened: \(success)") // Prints true
                })
            } else {
                // Fallback on earlier versions
            }
        }
    }
    errorAlert.addAction(settingsAction)
    
    
    onVC.navigationController?.present(errorAlert, animated: true, completion: nil)
}


//MARK: - TABLEVIEW CELL HELPERS

//MARK: Text for Header

func getTextHeader(feed: JSON, pageType: viewType) -> NSMutableAttributedString {
    
    var displayText = getRegularString(string: "", size: TL_REGULAR_FONT_SIZE)
    
    if feed["thoughts"].stringValue != "" {
        displayText = getThought(feed)
    }
    else {
        
        switch feed["type"].stringValue {
        case "on-the-go-journey":
            displayText = getRegularString(string: "Started a Journey - \(feed["name"].stringValue)", size: TL_REGULAR_FONT_SIZE)
            
        case "ended-journey":
            displayText = getRegularString(string: "\(feed["name"].stringValue) - (\(feed["duration"].stringValue) Days).", size: TL_REGULAR_FONT_SIZE)
            
        case "quick-itinerary":
            displayText = getBoldString(string: feed[isLocalFeed(feed: feed) ? "title" : "name"].stringValue, size: TL_REGULAR_FONT_SIZE)
            displayText.append(getRegularString(string: " - Quick Itinerary (\(feed["duration"].stringValue) Days).", size: TL_REGULAR_FONT_SIZE))
            
        case "detail-itinerary":
            if (pageType != viewType.VIEW_TYPE_ACTIVITY ||
                pageType == viewType.VIEW_TYPE_SHOW_SINGLE_POST) {
                displayText = getBoldString(string: feed["name"].stringValue, size: TL_REGULAR_FONT_SIZE)
                displayText.append(getRegularString(string: " (\(feed["duration"].stringValue) Days).", size: TL_REGULAR_FONT_SIZE))
            }
            else {
                displayText = getBoldString(string: feed["name"].stringValue, size: TL_REGULAR_FONT_SIZE)
                displayText.append(getRegularString(string: " - Itinerary (\(feed["duration"].stringValue) Days).", size: TL_REGULAR_FONT_SIZE))
            }
            
            
        default:
            displayText = getThought(feed)
        }
    }
    
    return displayText
}


//MARK: Footer Condition

func shouldShowFooterCountView(feed: JSON) -> Bool{
    
    if feed["likeCount"].intValue > 0 ||
        feed["commentCount"].intValue > 0 {
        return true
    }
    
    return false
}


//MARK: Check PostCell Type

func getHeightForMiddleViewPostType(feed:JSON, pageType: viewType) -> CGFloat{
    
    var middleViewHeight = CGFloat(0)
    
    let displayString = getTextHeader(feed: feed, pageType: viewType.VIEW_TYPE_ACTIVITY)       
    
    if displayString.string != "" || pageType == viewType.VIEW_TYPE_MY_LIFE {
        let textHeight = (heightOfAttributedText(attributedString: displayString, width: (screenWidth-21)) + 10)
        middleViewHeight += textHeight            
    }
    
    let prevHeight = middleViewHeight
    
    if(feed["videos"].count > 0) {
        middleViewHeight += screenWidth*0.9
    }
        
    else if(feed["photos"].count > 0) {        
        middleViewHeight += screenWidth*0.9
    }
        
    else{
        if ((feed["imageUrl"] != nil) && (feed["checkIn"]["location"].stringValue != "")) {            
            middleViewHeight += screenWidth*0.9
        }
    }
    
    var showImageIndexStart = 1
    if(feed["videos"].count > 0) {
        showImageIndexStart = 0
    }
    
    if(feed["photos"].count > showImageIndexStart) {
        middleViewHeight += 90
    }
    
    if prevHeight == middleViewHeight {
        middleViewHeight += 80
    }
    
    return middleViewHeight
    
}

//MARK: GoogleAnalytics function used in all controller.

func setAnalytics(name:String) {
    DispatchQueue.global().async {
        guard let tracker = GAI.sharedInstance().defaultTracker else {
            return
        }
        tracker.set(kGAIScreenName, value: name)
        
        guard let builder = GAIDictionaryBuilder.createScreenView() else { return }
        tracker.send(builder.build() as [NSObject : AnyObject])        
    }
}

