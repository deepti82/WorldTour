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
    @IBOutlet weak var countryStackView: UIStackView!
    @IBOutlet weak var startDate: UILabel!
    @IBOutlet weak var dayCount: UILabel!
    @IBOutlet weak var mileageText: UILabel!
    
    var labels: [JSON] = []
    var images = ["restaurantsandbars", "leaftrans", "hotels-1", "shopping-1", "nature_checkin", "sightstrans", "museumstrans", "zootrans", "religious-1", "cinematrans", "planetrans", "othersdottrans"]
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
        
        tripSummaryView.layer.cornerRadius = 5
        
        cellSubview = VerticalLayout(width: self.view.frame.width - 20)
        cellSubview.clipsToBounds = true
        cellView.addSubview(cellSubview)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return labels.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! TripStatsCollectionViewCell
        cell.statImage.setImage(UIImage(named: getImageName(categoryLabel: labels[indexPath.item]["name"].string!)), for: .normal)
        let title = NSMutableAttributedString(string: labels[indexPath.item]["name"].string!, attributes: [NSFontAttributeName: UIFont(name: "Avenir-Roman", size: 10)!])
        let count = NSMutableAttributedString(string: "\(labels[indexPath.item]["count"].int!) ", attributes: [NSFontAttributeName: UIFont(name: "Avenir-Heavy", size: 10)!])
        count.append(title)
        cell.statLabel.attributedText = title
        return cell
        
    }
    
    func getImageName(categoryLabel: String) -> String {
        
        switch categoryLabel {
        case "Restaurants & Bars":
            return images[0]
        case "Shopping":
            return images[3]
        case "Hotels":
            return images[2]
        case "Nature & Parks":
            return images[1]
        case "Sights and Landmarks":
            return images[5]
        case "Museums and Galleries":
            return images[6]
        case "Zoo and Aquariums":
            return images[7]
        case "Religious":
            return images[8]
        case "Cinema and Theatres":
            return images[9]
        case "Hotels and Accomodations":
            return images[10]
        case "Transportation":
            return images[10]
        default:
            return images[11]
        }
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
                    if response["data"]["checkInCount"] != nil {
                        self.labels = response["data"]["checkInCount"].array!
                    }
                    self.checkInCollectionView.reloadData()
//                    self.getCountView()
                }
            })
        })
    }
}

class TripStatsCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var statImage: UIButton!
    @IBOutlet weak var statLabel: UILabel!
    
}
