//
//  EmptyTableViewCell.swift
//  TraveLibro
//
//  Created by Wohlig Technology on 28/02/17.
//  Copyright © 2017 Wohlig Technology. All rights reserved.
//

import UIKit

class EmptyTableViewCell: UITableViewCell {

    var popJourneyView = PopularJourneyView()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code       
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        createView(data: nil, helper: nil)
    }
    
    init(style: UITableViewCellStyle, reuseIdentifier: String, data: JSON, helper: PopularJourneysViewController?){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        createView(data: data, helper: helper)        
    }
    
    func createView(data: JSON, helper: PopularJourneysViewController?) {
        popJourneyView = PopularJourneyView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 550))        
        self.contentView.addSubview(popJourneyView)
    }
    
    func setData(data : JSON, helper: PopularJourneysViewController?) {
        
        popJourneyView.journeyCreatorLabel.text = data["journeyCreator"]["name"].stringValue
        popJourneyView.journeyCreatorImage.hnk_setImageFromURL(getImageURL("\(adminUrl)upload/readFile?file=\(data["journeyCreator"]["profilePicture"].stringValue)", width: 100))
        
        popJourneyView.journetStartDate.text = getDateFormat(data["updatedAt"].stringValue, format: "dd MMM, yyyy")
        popJourneyView.journeyStartTime.text = getDateFormat(data["updatedAt"].stringValue, format: "hh.mm a")
        
        let gen = data["journeyCreator"]["gender"].stringValue
        popJourneyView.journeyDescription.text = " Has started " + (gen == "male" ? "his" : "her") + " " + data["startLocation"].stringValue + " journey."
        
        popJourneyView.journeyTitleLabel.text = data["name"].stringValue
        
        var imageURL = data["coverPhoto"].string
        if imageURL == nil || imageURL == "" {
            imageURL = data["startLocationPic"].stringValue
        }
        popJourneyView.mainPhoto.hnk_setImageFromURL(getImageURL("\(adminUrl)upload/readFile?file=\(imageURL!)", width: 100))
        
    }

}
