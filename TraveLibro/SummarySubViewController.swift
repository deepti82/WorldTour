//
//  SummarySubViewController.swift
//  TraveLibro
//
//  Created by Midhet Sulemani on 27/07/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit


class SummarySubViewController: UIViewController, UIScrollViewDelegate {

   
    var labels: [JSON] = []
    var images = ["restaurantsandbars", "leaftrans", "hotels-1", "shopping-1", "nature_checkin", "sightstrans", "museumstrans", "zootrans", "religious-1", "cinematrans", "planetrans", "othersdottrans", "city_icon"]
    var journeyId = ""
    var tripCountData: JSON = []
    var cellSubview: VerticalLayout!
    var summaryTitle = NSMutableAttributedString()
    
    @IBOutlet weak var tripScroll: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getDarkBackGround(self)
        loader.showOverlay(self.view)
        createNavigation()
        tripScroll.delegate = self
        self.cellSubview = VerticalLayout(width: 300)
        tripScroll.addSubview(cellSubview)
        getCount()
        setTopNavigation("Summary")
        
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
        case "Sights & Landmarks":
            return images[5]
        case "Museums & Galleries":
            return images[6]
        case "Zoo & Aquariums":
            return images[7]
        case "Religious":
            return images[8]
        case "Cinema & Theatres":
            return images[9]
        case "Hotels & Accomodations":
            return images[10]
        case "Transportation":
            return images[10]
        case "City":
            return images[12]
        default:
            return images[11]
        }
    }
    
    func setTopNavigation(_ text: String) {
        let leftButton = UIButton()
        leftButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        leftButton.setImage(UIImage(named: "arrow_prev"), for: UIControlState())
        leftButton.addTarget(self, action: #selector(self.goBack(_:)), for: .touchUpInside)
        let rightButton = UIView()
        self.title = text
        self.navigationController?.navigationBar.titleTextAttributes = [ NSFontAttributeName: UIFont(name: "Avenir-Medium", size: 18)!]
        self.customNavigationBar(left: leftButton, right: rightButton)
    }
    
    
    
    func goBack(_ sender:AnyObject) {
        self.navigationController!.popViewController(animated: true)
    }

    
    func createNavigation() {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
        let leftButton = UIButton()
        leftButton.setImage(UIImage(named: "arrow_prev"), for: UIControlState())
        leftButton.addTarget(self, action: #selector(self.popVC(_:)), for: .touchUpInside)
        
        leftButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        
        self.customNavigationBar(left: leftButton, right: nil)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
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
                loader.hideOverlayView()
                print(response["data"])
                if response.error != nil {
                    print("error: \(response.error!.localizedDescription)")
                }
                else if response["value"].bool! {
                   
                    self.tripCountData = response["data"]
                    
                    self.createLayout()
                    
                    if response["data"]["checkInCount"] != nil {
                        self.labels = response["data"]["checkInCount"].array!
//                        self.dayCount.text = "\(response["data"]["checkInCount"].array!)"
                        print("whatisThis\(self.labels)")
                        
                        

                    }else {
                        
                    }
                   
                }
            })
        })
    }
    func scrollChange() {
        self.cellSubview.layoutSubviews()
        self.tripScroll.contentSize = CGSize(width: self.cellSubview.frame.width, height: self.cellSubview.frame.height)
    }
    
    func createMiddleView() {
        let tripMiddle = TripSummaryMiddle(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 106))

        var wid = tripMiddle.countryScroll.frame.width
        let cnt = CGFloat(tripCountData["checkInCount"].count)
        wid = wid - cnt * 70
        wid = wid / 2
        for (key, val) in tripCountData["checkInCount"] {
            
            if key != "0" {
                wid = 0
            }

            let tripfo = TripSummaryCell(frame: CGRect(x: wid, y: 0, width: 70, height: 106))
            let img = UIImage(named: getImageName(categoryLabel: val["name"].stringValue))
            tripfo.category.setImage(img, for: .normal)
            
            tripfo.name.text = val["name"].stringValue
            tripfo.count.text = val["count"].stringValue
            tripMiddle.countryLayout.addSubview(tripfo)
            
            
        }
        
        tripMiddle.refLayout()
        
        cellSubview.addSubview(tripMiddle)

    }
    
    func createFooterView() {
        let tripMiddle = TripSummaryFooter(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 94))
        if tripCountData["countryVisited"].count == 1 {
            tripMiddle.countryCount.text = String(tripCountData["countryVisited"].count) + " Country Visited"
        } else{
            tripMiddle.countryCount.text = String(tripCountData["countryVisited"].count) + " Countries Visited"
        }
        tripMiddle.countryCount.font = avenirFont
        var wid = tripMiddle.countryScroll.frame.width
        let cnt = CGFloat(tripCountData["countryVisited"].count)
        wid = wid - cnt * 70
        wid = wid / 2
        
        for (key, val) in tripCountData["countryVisited"] {
            if key != "0" {
                wid = 0
            }
            
            var imageView : UIImageView
            imageView  = UIImageView(frame: CGRect(x: 10, y: 5, width: 30, height: 20))
            imageView.hnk_setImageFromURL(getImageURL(val["country"]["flag"].stringValue, width: 30))
            imageView.contentMode = UIViewContentMode.scaleAspectFit
            imageView.clipsToBounds = true

            tripMiddle.countryLayout.addSubview(imageView)
            
            let countryText = UILabel(frame: CGRect(x: 8, y: 5, width: 40, height: 30))
            let attrtxt = NSMutableAttributedString()
            attrtxt.append(NSAttributedString(string: val["country"]["name"].stringValue, attributes: [NSFontAttributeName: UIFont(name: "Avenir-Roman", size: 14)!]))
            
            countryText.attributedText = attrtxt
            countryText.sizeToFit()
            print("width width")
            print(countryText.frame.width)
            tripMiddle.countryLayout.addSubview(countryText)

            
            
        }
        tripMiddle.refLayout()
        
        cellSubview.addSubview(tripMiddle)
    }
    
    func createList() {
        for (_, val) in tripCountData["checkIn"] {
            var cell = tripSummaryEach(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 119))
            
            
        
            summaryTitle = NSMutableAttributedString(string: "\(val["thoughts"].string!)", attributes: [NSFontAttributeName: UIFont(name: "Avenir-Heavy", size: 14)!])
            
            switch val["buddies"].array!.count {
            case 0:
                break
            case 1:
                summaryTitle.append(NSAttributedString(string: " with", attributes: [NSFontAttributeName: UIFont(name: "Avenir-Roman", size: 14)!]))
                summaryTitle.append(NSAttributedString(string: " \(val["buddies"][0]["name"].string!)", attributes: [NSFontAttributeName: UIFont(name: "Avenir-Heavy", size: 14)!]))
            default:
                summaryTitle.append(NSAttributedString(string: " \(val["buddies"][0]["name"].string!)", attributes: [NSFontAttributeName: UIFont(name: "Avenir-Heavy", size: 14)!]))
                summaryTitle.append(NSAttributedString(string: " and", attributes: [NSFontAttributeName: UIFont(name: "Avenir-Roman", size: 14)!]))
                summaryTitle.append(NSAttributedString(string: " \(val["buddies"].array!.count - 1)", attributes: [NSFontAttributeName: UIFont(name: "Avenir-Heavy", size: 14)!]))
                summaryTitle.append(NSAttributedString(string: " others", attributes: [NSFontAttributeName: UIFont(name: "Avenir-Roman", size: 14)!]))
            }
            summaryTitle.append(NSAttributedString(string: " at", attributes: [NSFontAttributeName: UIFont(name: "Avenir-Roman", size: 14)!]))
            summaryTitle.append(NSAttributedString(string: " \(val["location"].string!)", attributes: [NSFontAttributeName: UIFont(name: "Avenir-Heavy", size: 14)!]))
            cell.summaryTitle.attributedText = summaryTitle
//            cell.summaryTitle.sizeToFit()
//            cell.frame.size.height = 80.5 + cell.summaryTitle.frame.height
            
            let dateFormatter = DateFormatter()
            let timeFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSZ"
            let date = dateFormatter.date(from: val["UTCModified"].string!)
            dateFormatter.dateFormat = "dd MMM, yyyy"
            timeFormatter.dateFormat = "hh:mm a"
            cell.calendarText.text = "\(dateFormatter.string(from: date!))"
            cell.clockText.text = "\(timeFormatter.string(from: date!))"
            
            
            
            cellSubview.addSubview(cell)
        }
    }
    
    func createLayout() {
        //  TOP VIEW
        let tripView = TripSummaryView(frame: CGRect(x: 0, y: 50, width: self.view.frame.width, height: 144))
        tripView.allData = tripCountData
        tripView.likes.text = tripCountData["likeCount"].stringValue
        
        let dateFormatter = DateFormatter()
        let timeFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSZ"
        let date = dateFormatter.date(from: tripCountData["startTime"].string!)
        dateFormatter.dateFormat = "dd MMM yyyy"
        timeFormatter.dateFormat = "hh:mm a"
        tripView.tripDate.text = "\(dateFormatter.string(from: date!))"
        
        tripView.profilePic.hnk_setImageFromURL(URL(string:"\(adminUrl)upload/readFile?file=\(tripCountData["user"]["profilePicture"].stringValue)")!)
        tripView.profileName.text! = tripCountData["user"]["name"].stringValue
        cellSubview.addSubview(tripView)
        //  MIDDLE VIEW
        if tripCountData["checkInCount"] != nil && tripCountData["checkInCount"] != [] {
            createMiddleView()
        }
        
        //  FOOTER VIEW
        if tripCountData["countryVisited"] != nil && tripCountData["countryVisited"] != [] {
            createFooterView()
        }
        
        //  LIST TRIP SUMMARY EACH
        if tripCountData["checkIn"] != nil && tripCountData["checkIn"] != [] {
            createList()
        }
        

        scrollChange()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y == (scrollView.contentSize.height - scrollView.frame.size.height) {
            print("in load more of data.")
        }
    }
}
