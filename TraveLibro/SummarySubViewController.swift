//
//  SummarySubViewController.swift
//  TraveLibro
//
//  Created by Midhet Sulemani on 27/07/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit
import SwiftyJSON

class SummarySubViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var tripSummaryView: UIView!
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var remainingCountries: UILabel!
    @IBOutlet var stackCountryNames: [UILabel]!
    @IBOutlet var stackFlags: [UIImageView]!
    @IBOutlet weak var countriesVisitedLabel: UILabel!
    @IBOutlet weak var likesNumber: UILabel!
    @IBOutlet weak var checkInCollectionView: UICollectionView!
    @IBOutlet weak var startDate: UILabel!
    @IBOutlet weak var dayCount: UILabel!
    
    var labels: [JSON] = []
    var images = ["martini_icon", "nature_checkin", "palm_trees_icon", "martini_icon", "nature_checkin", "palm_trees_icon"]
    var journeyId = ""
    var tripCountData: JSON = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getCount()
        
        userName.text = currentUser["name"].string!
        profilePicture.image = UIImage(data: NSData(contentsOfURL: NSURL(string: "\(adminUrl)upload/readFile?file=\(currentUser["profilePicture"])")!)!)
        makeTLProfilePicture(profilePicture)
        
        print("cell view: \(tripSummaryEach(frame: CGRect(x: 0, y: 0, width: cellView.frame.width, height: 100)))")
        
        print("cell view Two: \(cellView)")
        
        tripSummaryView.layer.cornerRadius = 5
//        tripSummaryView.clipsToBounds = true
        
        let cellSubview = VerticalLayout(width: self.view.frame.width - 55)
//        cellSubview.backgroundColor = UIColor.whiteColor()
//        cellSubview.frame.size.height = cellView.frame.height
        cellSubview.clipsToBounds = true
        cellView.addSubview(cellSubview)

        let cellOne = tripSummaryEach(frame: CGRect(x: 0, y: 0, width: cellSubview.frame.width, height: 75))
        cellOne.layer.cornerRadius = 5
        cellOne.clipsToBounds = true
        cellSubview.addSubview(cellOne)

        let cellTwo = tripSummaryEach(frame: CGRect(x: 0, y: 20, width: cellSubview.frame.width, height: 75))
        cellTwo.layer.cornerRadius = 5
        cellTwo.clipsToBounds = true
        cellSubview.addSubview(cellTwo)
        
        let cellThree = tripSummaryEach(frame: CGRect(x: 0, y: 20, width: cellSubview.frame.width, height: 75))
        cellThree.layer.cornerRadius = 5
        cellThree.clipsToBounds = true
        cellSubview.addSubview(cellThree)
        
        let cellFour = tripSummaryEach(frame: CGRect(x: 0, y: 20, width: cellSubview.frame.width, height: 75))
        cellFour.layer.cornerRadius = 5
        cellFour.clipsToBounds = true
        cellSubview.addSubview(cellFour)
        
        let cellFive = tripSummaryEach(frame: CGRect(x: 0, y: 20, width: cellSubview.frame.width, height: 75))
        cellFive.layer.cornerRadius = 5
        cellFive.clipsToBounds = true
        cellSubview.addSubview(cellFive)
        
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return labels.count
        
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! TripStatsCollectionViewCell
        cell.statImage.setImage(UIImage(named: images[indexPath.item]), forState: .Normal)
        cell.statLabel.text = labels[indexPath.item]["name"].string!
        return cell
        
    }
    
    func getCountView() {
        
        switch tripCountData["countryVisited"].array!.count {
        case 1:
            stackFlags[0].image = UIImage(data: NSData(contentsOfURL: NSURL(string: "\(adminUrl)upload/readFile?file=\(tripCountData["countryVisited"][0]["country"]["flag"])")!)!)
            stackCountryNames[0].text = tripCountData["countryVisited"][0]["country"]["name"].string!
            stackFlags[1].hidden = true
            stackFlags[2].hidden = true
            stackCountryNames[1].hidden = true
            stackCountryNames[2].hidden = true
            remainingCountries.hidden = true
        
        case 2:
            stackFlags[0].image = UIImage(data: NSData(contentsOfURL: NSURL(string: "\(adminUrl)upload/readFile?file=\(tripCountData["countryVisited"][0]["country"]["flag"])")!)!)
            stackCountryNames[0].text = tripCountData["countryVisited"][0]["country"]["name"].string!
            stackFlags[1].image = UIImage(data: NSData(contentsOfURL: NSURL(string: "\(adminUrl)upload/readFile?file=\(tripCountData["countryVisited"][1]["country"]["flag"])")!)!)
            stackCountryNames[1].text = tripCountData["countryVisited"][1]["country"]["name"].string!
            stackFlags[2].hidden = true
            stackCountryNames[2].hidden = true
            remainingCountries.hidden = true
        
        case 3:
            stackFlags[0].image = UIImage(data: NSData(contentsOfURL: NSURL(string: "\(adminUrl)upload/readFile?file=\(tripCountData["countryVisited"][0]["country"]["flag"])")!)!)
            stackCountryNames[0].text = tripCountData["countryVisited"][0]["country"]["name"].string!
            stackFlags[1].image = UIImage(data: NSData(contentsOfURL: NSURL(string: "\(adminUrl)upload/readFile?file=\(tripCountData["countryVisited"][1]["country"]["flag"])")!)!)
            stackCountryNames[1].text = tripCountData["countryVisited"][1]["country"]["name"].string!
            stackFlags[2].image = UIImage(data: NSData(contentsOfURL: NSURL(string: "\(adminUrl)upload/readFile?file=\(tripCountData["countryVisited"][2]["country"]["flag"])")!)!)
            stackCountryNames[2].text = tripCountData["countryVisited"][2]["country"]["name"].string!
            remainingCountries.hidden = true
            
        default:
            for flag in stackFlags {
                
                flag.image = UIImage(data: NSData(contentsOfURL: NSURL(string: "\(adminUrl)upload/readFile?file=\(tripCountData["countryVisited"][stackFlags.indexOf(flag)!]["country"]["flag"])")!)!)
            }
            for flagName in stackCountryNames {
                
                flagName.text = tripCountData["countryVisited"][stackCountryNames.indexOf(flagName)!]["country"]["name"].string!
            }
            remainingCountries.text = "\(tripCountData["countryVisited"].array!.count - 3)"
            
        }
        
        likesNumber.text = "\(tripCountData["likeCount"])"
        
        if tripCountData["countryVisited"].array!.count > 1 {
            countriesVisitedLabel.text = "\(tripCountData["countryVisited"].array!.count) Countries Visited"
        }
        else if tripCountData["countryVisited"].array!.count == 1 {
            countriesVisitedLabel.text = "\(tripCountData["countryVisited"].array!.count) Country Visited"
        }
        
        countriesVisitedLabel.text = "\(tripCountData["countryVisited"].array!.count) Countries Visited"
        startDate.text = changeDateFormat("yyyy-MM-dd'T'HH:mm:ss.SSZ", getFormat: "dd-MM-yyyy", date: tripCountData["startTime"].string!, isDate: true)
        let date = NSDate()
//        date.toGlobalTime()
        dayCount.text = "\(getDays(tripCountData["startTime"].string!, postDate: "\(date)")) Days"
    }
    
    func changeDateFormat(givenFormat: String, getFormat: String, date: String, isDate: Bool) -> String {
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = givenFormat
        let date = dateFormatter.dateFromString(date)
        
        dateFormatter.dateFormat = getFormat
        
        if isDate {
            
            dateFormatter.dateStyle = .MediumStyle
            
        }
        
        let goodDate = dateFormatter.stringFromDate(date!)
        return goodDate
        
    }
    
    func getDays(startDate: String, postDate: String) -> Int {
        
        print("to date: \(postDate)")
        
        let DFOne = NSDateFormatter()
        DFOne.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSZ"
        let DFTwo = NSDateFormatter()
        DFTwo.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
        
        let start = DFOne.dateFromString(startDate)
        let post = DFTwo.dateFromString(postDate)
        
        let calendar = NSCalendar.currentCalendar()
        
        // Replace the hour (time) of both dates with 00:00
        let date1 = calendar.startOfDayForDate(start!)
        let date2 = calendar.startOfDayForDate(post!)
        
        let flags = NSCalendarUnit.Day
        let components = calendar.components(flags, fromDate: date1, toDate: date2, options: [])
        print("days: \(components.day)")
        return components.day
        
    }

    func getCount() {
        
        request.getTripSummaryCount("tripSummary", journeyId: journeyId, userId: currentUser["_id"].string!, completion: {(response) in
            
            dispatch_async(dispatch_get_main_queue(), {
                
                if response.error != nil {
                    
                    print("error: \(response.error!.localizedDescription)")
                }
                else if response["value"] {
                    
                    self.tripCountData = response["data"]
                    self.labels = response["data"]["checkInCount"].array!
                    self.checkInCollectionView.reloadData()
                    self.getCountView()
                    
                }
                else {
                    
                }
                
            })
        })
        
        
    }

}

class TripStatsCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var statImage: UIButton!
    @IBOutlet weak var statLabel: UILabel!
    
}
