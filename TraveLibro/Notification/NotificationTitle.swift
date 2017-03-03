//
//  NotificationTitle.swift
//  TraveLibro
//
//  Created by Wohlig Technology on 15/02/17.
//  Copyright © 2017 Wohlig Technology. All rights reserved.
//

import UIKit

class NotificationTitle: UIView {
    
    
    @IBOutlet weak var NFMessageLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib ()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func loadViewFromNib() {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "notificationTitleView", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(view);
    }
    
    func setMessageLabel(data: JSON) -> CGFloat {
        
        NFMessageLabel.text = ""
        
        let message = NSMutableAttributedString(string: "")        
        let firstName = data["userFrom"]["name"].stringValue        
        message.append(getBoldString(string: firstName))
        
        let notificationType = data["type"].stringValue
        
        var str2 = ""
        
        switch notificationType {
           
        case "postFirstTime":
            str2 = " has started a "
            
        case "postTag":
            print("\n\n Data : \(data) ")
            str2 = " has checked-in with you in an "
            if (data["data"]["type"].string == "photo") {
                str2 = " has uploaded a photo to "
            }
            else if (data["data"]["type"].string == "video") {
                str2 = " has uploaded a video to "
            }
            else if ((data["data"]["videos"].array?.count)! > 0) {
                str2 = " has uploaded a video to "
            }
            else if ((data["data"]["photos"].array?.count)! > 0) {
                str2 = " has uploaded a photo to "
            }        
            else if data["data"]["showMap"].boolValue && data["data"]["checkIn"]["location"] != "" {
                let gen = data["userFrom"]["gender"].stringValue
                str2 = " has checked-in with you at \(data["data"]["checkIn"]["location"].stringValue) in \((gen == "male" ? "his" : "her")) "                
            }
            else if (data["thoughts"].stringValue != "") {
                //Showing img for thought
                str2 = " has tagged you in a thought in an "
            }
//            str2 = " has checked-in with you in an "
            else if checkIfComment(notificationData: data) {
                str2 = " has tagged you in a thought in an "
            }
            
        case "postLike":
            str2 = " has liked your "
            
        case "postComment":
            str2 = " has commented on your "
            
        case "photoComment":
            str2 = " has commented on a photo in your "
            
        case "photoLike":
            str2 = " has liked photo in your "
            
        case "userFollowing":
            str2 = " has started following you."
            
        case "userFollowingResponse":
            str2 = " has accepted your follow request. "
            
        case "userFollowingRequest":
            str2 = " has requested to follow your travel and local activities. "
            
        case "journeyAccept":
            str2 = " has accepted your On The Go Journey - "
            
        case "journeyLeft":
            let gen = data["userFrom"]["gender"].stringValue
            str2 = " has ended " + (gen == "male" ? "his" : "her") + " On The Go Journey - "
            
        case "journeyRequest":
            let gen = data["userFrom"]["gender"].stringValue
            str2 = " wants to tag you in " + (gen == "male" ? "his" : "her") + " On The Go Journey - "
            
        case "journeyMentionComment":
            str2 = " has mentioned you in a comment On The Go Journey -  "
            
        case "journeyComment": 
            fallthrough
        case "itineraryComment":
            str2 = " has commented on the "
            
        case "journeyLike":
            str2 = " has liked the On The Go Journey - "
            
        case "journeyReject":
            str2 = " has rejected your request to join the "
            
        case "itineraryRequest":
            let gen = data["userFrom"]["gender"].stringValue
            str2 = " wants to tag you in " + (gen == "male" ? "his" : "her") + " itinerary - "
            
        case "itineraryMentionComment":
            str2 = " has mentioned you in a comment On "
            
        case "itineraryLike":
            str2 = " has liked "
            
        default:
            str2 = " wants to tag you in her On The Go Journey"
            break
        }        
        
        message.append(getRegularString(string: str2))
        
        
        var str3 = ""
        if notificationType != "userFollowing" && 
            notificationType != "userFollowingRequest" &&
            notificationType != "userFollowingResponse" &&
            notificationType != "journeyMentionComment" && 
            notificationType != "journeyComment" &&
            notificationType != "journeyLike" &&
            notificationType != "journeyReject" &&
            notificationType != "journeyAccept" &&
            notificationType != "photoLike" &&
            notificationType != "journeyRequest" &&
            notificationType != "itineraryMentionComment" &&
            notificationType != "itineraryLike" &&
            notificationType != "itineraryComment"{ 
            //Travel type
            let travelType = data["data"]["type"].string
            if travelType != nil {
                if travelType == "local-life" {
                    str3 = "Local Life Activity "
                }
                else if travelType == "on_the_go" {
                    str3 = "On The Go Activity "
                }
                else if travelType == "travel-life" {
                    str3 = "Travel Life Activity "
                }
            }
            
            message.append(getBoldString(string: str3))
        }
        
        
        var str4 = "" 
        
        if notificationType == "journeyComment" {
            str4 = "On Go Journey "
        }
        else if notificationType == "journeyReject" {
            str4 = "On Go Activity - "
        }
        else if notificationType == "journeyComment" ||
            notificationType == "photoLike" {
            str4 = "Local Life Activity. "
        }
        else if notificationType == "itineraryMentionComment" ||
            notificationType == "itineraryLike" ||
            notificationType == "itineraryComment" {
            str4 = data["data"]["type"].stringValue.capitalized + " - "
        }
        
        message.append(getBoldString(string: str4))
        
        if notificationType == "postFirstTime" {
            str4 = " for first time "
            message.append(getRegularString(string: str4))
        }
        
        var str5 = ""
        if notificationType == "journeyMentionComment" ||
            notificationType == "journeyComment" ||
            notificationType == "journeyLike" ||
            notificationType == "journeyLeft" ||
            notificationType == "journeyReject" ||
            notificationType == "journeyRequest" ||
            notificationType == "journeyAccept" ||
            notificationType == "itineraryMentionComment" ||
            notificationType == "itineraryLike" ||
            notificationType == "itineraryComment" ||
            notificationType == "itineraryRequest" {
            str5 = data["data"]["name"].stringValue
            
            message.append(getRedString(string: str5))
        }
        
        
        NFMessageLabel.attributedText = message
        NFMessageLabel.frame = CGRect(x: NFMessageLabel.frame.origin.x, y: NFMessageLabel.frame.origin.y, width: NFMessageLabel.frame.size.width,
                                      height: heightForView(text: (firstName + str2 + str3 + str4 + str5 + "offset  ") , font: NFMessageLabel.font, width: NFMessageLabel.frame.size.width) + 10)
        
        return (NFMessageLabel.frame.size.height+CGFloat(10))   //10 is Offset hence added
    }
    
    func checkIfComment(notificationData: JSON) -> Bool {
        
        var shouldLoadCommentCell = true
        if (notificationData["data"]["type"].string == "photo") {
            shouldLoadCommentCell = false
        }
        else if (notificationData["data"]["type"].string == "video") {
            shouldLoadCommentCell = false
        }
        else if (notificationData["data"]["photos"].array?.count)! > 0 || (notificationData["data"]["videos"].array?.count)! > 0 {
            shouldLoadCommentCell = false
        }
        
        return shouldLoadCommentCell
    }
}

