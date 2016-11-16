//
//  SummarySubViewController.swift
//  TraveLibro
//
//  Created by Midhet Sulemani on 27/07/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit


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
    @IBOutlet weak var mileageText: UILabel!
    
    var labels: [JSON] = []
    var images = ["martini_icon", "nature_checkin", "palm_trees_icon", "martini_icon", "nature_checkin", "palm_trees_icon"]
    var journeyId = ""
    var tripCountData: JSON = []
    var cellSubview: VerticalLayout!
    var summaryTitle = NSMutableAttributedString()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getCount()
        
        userName.text = currentUser["name"].string!
        DispatchQueue.main.async(execute: {
            self.profilePicture.image = UIImage(data: try! Data(contentsOf: URL(string: "\(adminUrl)upload/readFile?file=\(currentUser["profilePicture"])")!))
            makeTLProfilePicture(self.profilePicture)
        })
        
        print("cell view: \(tripSummaryEach(frame: CGRect(x: 0, y: 0, width: cellView.frame.width, height: 100)))")
        
        print("cell view Two: \(cellView)")
        
        tripSummaryView.layer.cornerRadius = 5
//        tripSummaryView.clipsToBounds = true
        
        cellSubview = VerticalLayout(width: self.view.frame.width - 20)
//        cellSubview.backgroundColor = UIColor.whiteColor()
//        cellSubview.frame.size.height = cellView.frame.height
        cellSubview.clipsToBounds = true
        cellView.addSubview(cellSubview)
        
//        let cellOne = tripSummaryEach(frame: CGRect(x: 0, y: 0, width: cellSubview.frame.width, height: 75))
//        cellOne.layer.cornerRadius = 5
//        cellOne.clipsToBounds = true
//        cellSubview.addSubview(cellOne)
//
//        let cellTwo = tripSummaryEach(frame: CGRect(x: 0, y: 20, width: cellSubview.frame.width, height: 75))
//        cellTwo.layer.cornerRadius = 5
//        cellTwo.clipsToBounds = true
//        cellSubview.addSubview(cellTwo)
//        
//        let cellThree = tripSummaryEach(frame: CGRect(x: 0, y: 20, width: cellSubview.frame.width, height: 75))
//        cellThree.layer.cornerRadius = 5
//        cellThree.clipsToBounds = true
//        cellSubview.addSubview(cellThree)
//        
//        let cellFour = tripSummaryEach(frame: CGRect(x: 0, y: 20, width: cellSubview.frame.width, height: 75))
//        cellFour.layer.cornerRadius = 5
//        cellFour.clipsToBounds = true
//        cellSubview.addSubview(cellFour)
//        
//        let cellFive = tripSummaryEach(frame: CGRect(x: 0, y: 20, width: cellSubview.frame.width, height: 75))
//        cellFive.layer.cornerRadius = 5
//        cellFive.clipsToBounds = true
//        cellSubview.addSubview(cellFive)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return labels.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! TripStatsCollectionViewCell
        cell.statImage.setImage(UIImage(named: images[(indexPath as NSIndexPath).item]), for: UIControlState())
        cell.statLabel.text = labels[indexPath.item]["name"].string!
        return cell
        
    }
    
    func getCountView() {
        
        switch tripCountData["countryVisited"].array!.count {
        case 1:
            stackFlags[0].image = UIImage(data: try! Data(contentsOf: URL(string: "\(adminUrl)upload/readFile?file=\(tripCountData["countryVisited"][0]["country"]["flag"])")!))
            stackCountryNames[0].text = tripCountData["countryVisited"][0]["country"]["name"].string!
            stackFlags[1].isHidden = true
            stackFlags[2].isHidden = true
            stackCountryNames[1].isHidden = true
            stackCountryNames[2].isHidden = true
            remainingCountries.isHidden = true
        
        case 2:
            stackFlags[0].image = UIImage(data: try! Data(contentsOf: URL(string: "\(adminUrl)upload/readFile?file=\(tripCountData["countryVisited"][0]["country"]["flag"])")!))
            stackCountryNames[0].text = tripCountData["countryVisited"][0]["country"]["name"].string!
            stackFlags[1].image = UIImage(data: try! Data(contentsOf: URL(string: "\(adminUrl)upload/readFile?file=\(tripCountData["countryVisited"][1]["country"]["flag"])")!))
            stackCountryNames[1].text = tripCountData["countryVisited"][1]["country"]["name"].string!
            stackFlags[2].isHidden = true
            stackCountryNames[2].isHidden = true
            remainingCountries.isHidden = true
        
        case 3:
            stackFlags[0].image = UIImage(data: try! Data(contentsOf: URL(string: "\(adminUrl)upload/readFile?file=\(tripCountData["countryVisited"][0]["country"]["flag"])")!))
            stackCountryNames[0].text = tripCountData["countryVisited"][0]["country"]["name"].string!
            stackFlags[1].image = UIImage(data: try! Data(contentsOf: URL(string: "\(adminUrl)upload/readFile?file=\(tripCountData["countryVisited"][1]["country"]["flag"])")!))
            stackCountryNames[1].text = tripCountData["countryVisited"][1]["country"]["name"].string!
            stackFlags[2].image = UIImage(data: try! Data(contentsOf: URL(string: "\(adminUrl)upload/readFile?file=\(tripCountData["countryVisited"][2]["country"]["flag"])")!))
            stackCountryNames[2].text = tripCountData["countryVisited"][2]["country"]["name"].string!
            remainingCountries.isHidden = true
            
        default:
            for flag in stackFlags {
                
                flag.image = UIImage(data: try! Data(contentsOf: URL(string: "\(adminUrl)upload/readFile?file=\(tripCountData["countryVisited"][stackFlags.index(of: flag)!]["country"]["flag"])")!))
            }
            for flagName in stackCountryNames {
                
                flagName.text = tripCountData["countryVisited"][stackCountryNames.index(of: flagName)!]["country"]["name"].string!
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
        let date = Date()
//        date.toGlobalTime()
        dayCount.text = "\(getDays(tripCountData["startTime"].string!, postDate: "\(date)")) Days"
        mileageText.text = "0 km"
        
        print("sacsacdasd \(tripCountData["checkIn"].array!.count)")
        
        for i in 0..<tripCountData["checkIn"].array!.count {
            let drawView = drawLine(frame: CGRect(x: 0, y: 0, width: 3, height: 35))
            drawView.center.x = cellSubview.frame.width / 2
            drawView.backgroundColor = UIColor.clear
            let cell = tripSummaryEach(frame: CGRect(x: 0, y: 0, width: cellSubview.frame.width, height: 75))
            cell.layer.cornerRadius = 5
            cell.clipsToBounds = true
            summaryTitle = NSMutableAttributedString(string: "\(tripCountData["checkIn"][i]["thoughts"].string!)", attributes: [NSFontAttributeName: UIFont(name: "Avenir-Heavy", size: 14)!])
            summaryTitle.append(NSAttributedString(string: " with", attributes: [NSFontAttributeName: UIFont(name: "Avenir-Roman", size: 14)!]))
            switch tripCountData["checkIn"][i]["buddies"].array!.count {
            case 0:
                break
            case 1:
                summaryTitle.append(NSAttributedString(string: " \(tripCountData["checkIn"][i]["buddies"][0]["name"].string!)", attributes: [NSFontAttributeName: UIFont(name: "Avenir-Heavy", size: 14)!]))
            default:
                summaryTitle.append(NSAttributedString(string: " \(tripCountData["checkIn"][i]["buddies"][0]["name"].string!)", attributes: [NSFontAttributeName: UIFont(name: "Avenir-Heavy", size: 14)!]))
                summaryTitle.append(NSAttributedString(string: " and", attributes: [NSFontAttributeName: UIFont(name: "Avenir-Roman", size: 14)!]))
                summaryTitle.append(NSAttributedString(string: " \(tripCountData["checkIn"][i]["buddies"].array!.count - 1)", attributes: [NSFontAttributeName: UIFont(name: "Avenir-Heavy", size: 14)!]))
                summaryTitle.append(NSAttributedString(string: " others", attributes: [NSFontAttributeName: UIFont(name: "Avenir-Roman", size: 14)!]))
            }
            summaryTitle.append(NSAttributedString(string: " at", attributes: [NSFontAttributeName: UIFont(name: "Avenir-Roman", size: 14)!]))
            summaryTitle.append(NSAttributedString(string: " \(tripCountData["checkIn"][i]["location"].string!)", attributes: [NSFontAttributeName: UIFont(name: "Avenir-Heavy", size: 14)!]))
            cell.summaryTitle.attributedText = summaryTitle
            
            let dateFormatter = DateFormatter()
            let timeFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSZ"
            let date = dateFormatter.date(from: tripCountData["checkIn"][i]["UTCModified"].string!)
            dateFormatter.dateFormat = "dd MMM, yyyy"
            timeFormatter.dateFormat = "hh:mm a"
            cell.calendarText.text = "\(dateFormatter.string(from: date!))"
            cell.clockText.text = "\(timeFormatter.string(from: date!))"
            
            cellSubview.addSubview(drawView)
            cellSubview.addSubview(cell)
        }
    }
    
    func changeDateFormat(_ givenFormat: String, getFormat: String, date: String, isDate: Bool) -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = givenFormat
        let date = dateFormatter.date(from: date)
        
        dateFormatter.dateFormat = getFormat
        
        if isDate {
            
            dateFormatter.dateStyle = .medium
            
        }
        
        let goodDate = dateFormatter.string(from: date!)
        return goodDate
        
    }
    
    func getDays(_ startDate: String, postDate: String) -> Int {
        
        print("to date: \(postDate)")
        
        let DFOne = DateFormatter()
        DFOne.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSZ"
        let DFTwo = DateFormatter()
        DFTwo.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
        
        let start = DFOne.date(from: startDate)
        let post = DFTwo.date(from: postDate)
        
        let calendar = Calendar.current
        
        // Replace the hour (time) of both dates with 00:00
        let date1 = calendar.startOfDay(for: start!)
        let date2 = calendar.startOfDay(for: post!)
        
        let flags = NSCalendar.Unit.day
        let components = (calendar as NSCalendar).components(flags, from: date1, to: date2, options: [])
        print("days: \(components.day)")
        return components.day!
        
    }

    func getCount() {
        
        request.getTripSummaryCount("tripSummary", journeyId: journeyId, userId: currentUser["_id"].string!, completion: {(response) in
            
            DispatchQueue.main.async(execute: {
                
                if response.error != nil {
                    
                    print("error: \(response.error!.localizedDescription)")
                }
                else if response["value"].bool! {
                    
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
