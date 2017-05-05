//
//  TLTravelLocalLifeTableViewCell.swift
//  TraveLibro
//
//  Created by Wohlig Technology on 04/05/17.
//  Copyright © 2017 Wohlig Technology. All rights reserved.
//

import UIKit

class TLTravelLocalLifeTableViewCell: UITableViewCell {

    var FBackground = NotificationBackground()
    var FProfileHeader: ActivityProfileHeader!
    var FMImageView: UIImageView?
    var FMCollectionView: UICollectionView?
    var FMTextView: UITextView?
    var FFooterView: ActivityFeedFooter!
    
    var totalHeight = CGFloat(0)
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    init(style: UITableViewCellStyle, reuseIdentifier: String, feedData: JSON, helper: TLMainFeedsViewController){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        createView(feedData: feedData, helper: helper)        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)        
        createView(feedData: nil, helper: nil)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.FMImageView?.removeFromSuperview()
        self.FMTextView?.removeFromSuperview()
        self.FMCollectionView?.removeFromSuperview()
        
        self.FMImageView = nil
        self.FMTextView = nil
        self.FMCollectionView = nil
    }
    
    
    //MARK: - Create View
    
    func createView(feedData: JSON?, helper: TLMainFeedsViewController?) {
        
        FProfileHeader = ActivityProfileHeader(frame: CGRect(x: 0, y: 0, width: screenWidth, height: FEEDS_HEADER_HEIGHT))
        self.contentView.addSubview(FProfileHeader)
        
        FFooterView = ActivityFeedFooter(frame: CGRect.zero)
        self.contentView.addSubview(FFooterView)
        
        FBackground = NotificationBackground(frame: CGRect.zero)
        self.contentView.addSubview(FBackground)
        self.contentView.sendSubview(toBack: FBackground)
        
        if feedData != nil {
            setData(feedData: feedData!, helper: helper!, pageType: nil)            
        }
    }    
    
    func setData(feedData: JSON, helper: TLMainFeedsViewController, pageType: viewType?) {        
        
        print("\n CellData: \(feedData)")
        
        totalHeight = CGFloat(0)
        
        FProfileHeader.frame = CGRect(x: 0, y: 0, width: screenWidth, height: FEEDS_HEADER_HEIGHT)        
        FProfileHeader.parentController = helper
        FProfileHeader.fillProfileHeader(feed: feedData, pageType: pageType, cellType: feedCellType.CELL_POST_TYPE)
        totalHeight += FEEDS_HEADER_HEIGHT
        
        self.setMiddleView(feedData: feedData, helper: helper, pageType: pageType)
        
        FFooterView.parentController = helper
        FFooterView.fillFeedFooter(feed: feedData, pageType: pageType)
        if shouldShowFooterCountView(feed: feedData) {
            FFooterView.lowerViewHeightConstraint.constant = 40
            FFooterView.frame = CGRect(x: 0, y: totalHeight, width: screenWidth, height: 90)
            totalHeight += 90
        }
        else {
            FFooterView.lowerViewHeightConstraint.constant = 0
            FFooterView.frame = CGRect(x: 0, y: totalHeight, width: screenWidth, height: 50)
            totalHeight += 50
        }
        
        FBackground.frame = CGRect(x: 0, y: 0, width: screenWidth, height: totalHeight)
    }
    
    private func setMiddleView(feedData: JSON, helper: UIViewController, pageType: viewType?) {
        
        if feedData["thoughts"].stringValue != "" ||
            feedData["imageUrl"].stringValue != "" {
            
            if FMTextView == nil {
                FMTextView = UITextView()
                FMTextView?.isScrollEnabled = false
                FMTextView?.isEditable = false
                FMTextView?.backgroundColor = UIColor.clear
                self.contentView.addSubview(FMTextView!)
            }
            FMTextView?.attributedText = getThought(feedData)
            FMTextView?.textAlignment = .left
            let textHeight = (heightOfAttributedText(attributedString: FMTextView?.attributedText.mutableCopy() as! NSMutableAttributedString, width: screenWidth)) + 15
            FMTextView?.frame = CGRect(x: 0, y: totalHeight, width: screenWidth, height: textHeight)
            totalHeight += textHeight
            
            if feedData["imageUrl"].stringValue != "" {
                if FMImageView == nil {
                    FMImageView = UIImageView(frame: CGRect(x: 0, y: totalHeight, width: screenWidth, height: screenWidth*0.9))
                    FMImageView?.contentMode = .scaleAspectFill
                    FMImageView?.clipsToBounds = true
                    FMImageView?.image = UIImage(named: "logo-default")
                    self.contentView.addSubview(FMImageView!)
                }
                FMImageView?.hnk_setImageFromURL(URL(string: feedData["imageUrl"].stringValue)!)
                totalHeight += screenWidth*0.9
            }
        }
        
    }
    
   /* func videosAndPhotosLayout(feed:JSON) {
        self.feeds = feed
        //Image generation only
        if(feed["videos"].count > 0) {
            self.videoContainer = VideoView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.width))
            
            self.videoContainer.isUserInteractionEnabled = true
            let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(self.openSingleVideo(_:)))
            self.videoContainer.addGestureRecognizer(tapGestureRecognizer)
            self.videoContainer.tag = 0
            
            self.player = Player()
            self.player.delegate = self
            self.player.view.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.width)
            self.player.view.clipsToBounds = true
            self.player.playbackLoops = true
            self.player.muted = true
            self.player.fillMode = "AVLayerVideoGravityResizeAspectFill"
            self.player.playbackFreezesAtEnd = true
            self.videoContainer.player = self.player
            self.videoContainer.bringSubview(toFront: videoContainer.playBtn)
            
            
            var videoUrl = URL(string:self.feeds["videos"][0]["name"].stringValue)
            if(videoUrl == nil) {
                videoUrl = URL(string:self.feeds["videos"][0]["localUrl"].stringValue)
            }
            
            getThumbnailFromVideoURL(url: videoUrl!, onView: self.videoContainer.videoHolder)
            
            if feeds["type"].stringValue == "travel-life" {
                videoContainer.tagText.text = "Travel Life"
                videoContainer.tagView.backgroundColor = mainOrangeColor
                videoContainer.playBtn.tintColor = mainOrangeColor
            }
            else{
                videoContainer.tagText.text = "  Local Life"
                videoContainer.tagText.textColor = UIColor(hex: "#303557")
                videoContainer.tagView.backgroundColor = endJourneyColor
                videoContainer.playBtn.tintColor = endJourneyColor
            }
            self.videoContainer.videoHolder.addSubview(self.player.view)
            self.addSubview(self.videoContainer)
            
        } 
        else if(feed["photos"].count > 0) {
            self.mainPhoto = UIImageView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.width))
            self.addSubview(self.mainPhoto)
            self.mainPhoto.contentMode = UIViewContentMode.scaleAspectFill
            self.mainPhoto.clipsToBounds = true
            self.mainPhoto.image = UIImage(named: "logo-default")
            
            let headerTag = ActivityHeaderTag(frame: CGRect(x: 0, y: 30, width: screenWidth, height: 30))
            headerTag.tagParent.backgroundColor = UIColor.clear
            headerTag.colorTag(feed: feed)
            headerTag.tagLine.isHidden = true
            
            self.mainPhoto.addSubview(headerTag)
            //            if headerTag.tagText.text == "Travel Life"{
            //                profileHeader.category.imageView?.tintColor = UIColor.white
            //            } else {
            //                profileHeader.category.imageView?.tintColor = UIColor(hex: "#303557")
            //            }
            
            
            
            self.addSubview(mainPhoto)
            
            let imgStr = getImageURL(feed["photos"][0]["name"].stringValue, width: 0)
            
            cache.fetch(URL: imgStr).onSuccess({ (data) in
                self.mainPhoto.image = UIImage(data: data as Data)
                
                let image = self.mainPhoto.image
                
                let widthInPixels =  image?.cgImage?.width
                let heightInPixels =  image?.cgImage?.height
                
                if((heightInPixels) != nil) {
                    let finalHeight =  CGFloat(heightInPixels!) / CGFloat(widthInPixels!) * self.frame.width;
                    
                    
                    let maxheight = screenHeight - ( 60 + 113 )
                    //                    if(finalHeight > maxheight) {
                    //                        self.mainPhoto.frame.size.height = maxheight
                    //                    } else {
                    //                        self.mainPhoto.frame.size.height = finalHeight
                    //                    }
                }
                
                self.mainPhoto.frame.size.width = self.frame.width
                if feed["photos"][0]["name"].stringValue == "" {
                    self.mainPhoto.image = UIImage(named: "logo-default")
                }else{
                    self.mainPhoto.hnk_setImageFromURL(imgStr)
                }
                self.mainPhoto.isUserInteractionEnabled = true
                let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(PhotosOTG2.openSinglePhoto(_:)))
                self.mainPhoto.addGestureRecognizer(tapGestureRecognizer)
                self.mainPhoto.tag = 0
                
                self.layoutSubviews()
                if(self.activityFeed != nil) {
                    self.activityFeed.addHeightToLayout()
                }
                
            })
        }
            
        else{
            if feed["imageUrl"] != nil {
                self.mainPhoto = UIImageView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.width))
                self.addSubview(self.mainPhoto)
                
                self.mainPhoto.contentMode = UIViewContentMode.scaleAspectFill
                self.mainPhoto.clipsToBounds = true
                
                
                if feed["thoughts"] == nil || feed["thoughts"].stringValue == "" || feed["imageUrl"] != nil{
                    let headerTag = ActivityHeaderTag(frame: CGRect(x: 0, y: 30, width: screenWidth, height: 28))
                    headerTag.tagParent.backgroundColor = UIColor.clear
                    headerTag.tagLine.isHidden = true
                    headerTag.colorTag(feed: feed)
                    
                    self.mainPhoto.addSubview(headerTag)
                    //                    if headerTag.tagText.text == "Travel Life"{
                    //                        profileHeader.category.imageView?.tintColor = UIColor.white
                    //                    } else {
                    //                        profileHeader.category.imageView?.tintColor = UIColor(hex: "#303557")
                    //                    }
                    
                    
                    
                }
                
                mainPhoto.hnk_setImageFromURL(URL(string: feed["imageUrl"].stringValue)!)
                
            }
        }
        
        
        //End of Image
        var showImageIndexStart = 1
        if(feed["videos"].count > 0) {
            showImageIndexStart = 0
        }
        //Center Generation Only
        if(feed["photos"].count > showImageIndexStart) {
            centerView = PhotosOTGView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: 91 ))
            addPhotoToLayout(feed,startIndex:showImageIndexStart)
            self.addSubview(centerView)
            //            centerView.centerLineView.isHidden = true
        }
        //End of Center
    }*/

}
