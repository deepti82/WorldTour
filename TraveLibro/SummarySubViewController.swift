//
//  SummarySubViewController.swift
//  TraveLibro
//
//  Created by Midhet Sulemani on 27/07/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit


class SummarySubViewController: UIViewController {

   
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

        createNavigation()

        self.cellSubview = VerticalLayout(width: 300)
        tripScroll.addSubview(cellSubview)
        getCount()
        
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
    func createLayout() {
        let tripView = TripSummaryView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 144))
        tripView.allData = tripCountData
        let tripFooter = TripSummaryFooter(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 138))
        let tripMiddle = TripSummaryMiddle(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 138))
        cellSubview.addSubview(tripView)
        cellSubview.addSubview(tripMiddle)
        cellSubview.addSubview(tripFooter)

        scrollChange()
    }
}
