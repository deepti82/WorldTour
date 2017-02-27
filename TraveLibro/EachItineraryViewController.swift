//
//  EachItineraryViewController.swift
//  TraveLibro
//
//  Created by Midhet Sulemani on 11/06/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit
import Toaster
//fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
//  switch (lhs, rhs) {
//  case let (l?, r?):
//    return l < r
//  case (nil, _?):
//    return true
//  default:
//    return false
//  }
//}

var globalDetailedItineraryViewController: EachItineraryViewController!
class EachItineraryViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var prevSelectedTab: UIButton?
    var editJson: JSON?
    var currentShowingCountry: JSON?
    var fromOutSide: String!

    var loader = LoadingOverlay()

    @IBOutlet weak var photosButton: UIButton!
    @IBOutlet weak var theTableView: UITableView!
    
    @IBOutlet weak var countryButtonsStackWidthConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var tab_0: UIButton!
    @IBOutlet weak var tab_1: UIButton!
    @IBOutlet weak var tab_2: UIButton!
    @IBOutlet weak var tab_3: UIButton!
    @IBOutlet weak var tab_4: UIButton!
    @IBOutlet weak var tab_more: UIButton!
    
    var selectedCountry = 0
    var cityLabels = [""]
    var dayLabels = [""]
    var isSelectedIndex: Int?
    var isExpanded = false
    let childCells = 4
    let childCellArray = ["Stayed At", "Ate At", "Must Do's", "little more"]
    var allButtons : [UIButton] = []
    
    //MARK: - Button Actions
    
    @IBAction func TapPhotos(_ sender: UIButton) {
        
        if editJson != nil {
            let modalContent = self.storyboard?.instantiateViewController(withIdentifier: "itineraryPhotos") as! EachItineraryPhotosViewController
            modalContent.selectedItinerary = editJson!
            modalContent.modalPresentationStyle = .fullScreen
            _ = modalContent.popoverPresentationController
            
            self.present(modalContent, animated: true, completion: nil)
        }        
    }
    
    @IBAction func panOnButton(_ sender: AnyObject) {
        
        if editJson != nil {
            let modalContent = self.storyboard?.instantiateViewController(withIdentifier: "itineraryPhotos") as! EachItineraryPhotosViewController
            modalContent.selectedItinerary = editJson!
            modalContent.modalPresentationStyle = .fullScreen
            _ = modalContent.popoverPresentationController
            
            self.present(modalContent, animated: true, completion: nil)
        }
        
    }

    @IBAction func tabTap(_ sender: UIButton) {
       
        if sender != prevSelectedTab {
            selectedCountry = sender.tag
            prevSelectedTab?.backgroundColor = mainBlueColor
            sender.backgroundColor = mainOrangeColor
            prevSelectedTab = sender
            
            setItineraryFor(countryIndex: selectedCountry)
        }        
    }
    
    
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        photosButton.layer.cornerRadius = 5
        
        cityLabels = [" "]
        dayLabels = [" "]        
        
        let inset = photosButton.imageEdgeInsets        
        photosButton.imageEdgeInsets = UIEdgeInsets(top: inset.top, left: 10, bottom: inset.bottom, right: (photosButton.frame.size.width - (photosButton.frame.size.height - (inset.top + inset.bottom))) - 15)        
        request.getItinerary(fromOutSide, completion: { (json) in
            DispatchQueue.main.async(execute: {
                if(json["value"].boolValue) {
                    self.editJson = json["data"];
                    self.allButtons = [self.tab_0, self.tab_1, self.tab_2, self.tab_3, self.tab_4, self.tab_more]
                    self.setCountryTabs()
                }
            })
        })
    
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        globalNavigationController = self.navigationController
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK: - Tableview Datasource and Delegates
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if editJson == nil {
            return 0
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {        
        return cityLabels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if (indexPath as NSIndexPath).row == 0 {
            
            let firstPostCell = tableView.dequeueReusableCell(withIdentifier: "firstPost") as! EachItineraryPostTableViewCell
            
            let itineraryView = Itineraries(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 400))
            itineraryView.feedbackStack.removeFromSuperview()
            itineraryView.reviewStack.removeFromSuperview()
            itineraryView.likeStack.removeFromSuperview()
            itineraryView.separatorView.removeFromSuperview()
            itineraryView.options.removeFromSuperview()
            itineraryView.setItineraryData(editJson: editJson!)
            firstPostCell.myView.addSubview(itineraryView)
            firstPostCell.selectionStyle = .none
            return firstPostCell
            
        }
        
        else if cityLabels[(indexPath as NSIndexPath).row] == "Stayed At" ||  cityLabels[(indexPath as NSIndexPath).row] == "Ate At" || cityLabels[(indexPath as NSIndexPath).row] == "Must Do's" {
            
            let childCell = tableView.dequeueReusableCell(withIdentifier: "childCellOne") as! ItineraryAccordionChildCellTableViewCell            
            let selectedCity = (currentShowingCountry?["cityVisited"].arrayValue)?[isSelectedIndex! - 1]
            
            switch cityLabels[(indexPath as NSIndexPath).row] {
            case "Stayed At":
                childCell.titleIcon.image = UIImage(named: "stayed_at")
                childCell.title.text = "Stayed At"
                childCell.value.text = getValueFor(showing: "stay", data: (selectedCity?["days"].array?.first())!)
                break
                
            case "Ate At":
                childCell.titleIcon.image = UIImage(named: "ate_at")
                childCell.title.text = "Ate At"
                childCell.value.text = getValueFor(showing: "ate", data: (selectedCity?["days"].array?.first())!)
                break
                
            case "Must Do's":
                childCell.titleIcon.image = UIImage(named: "must_do")
                childCell.title.text = "Must Do's"
                childCell.value.text = getValueFor(showing: "mustDo", data: (selectedCity?["days"].array?.first())!)
                break
                
            default:
                break
            }
            
            childCell.value.sizeToFit()
            return childCell
            
        }
        
        else if cityLabels[(indexPath as NSIndexPath).row] == "little more" {
            let selectedCity = (currentShowingCountry?["cityVisited"].arrayValue)?[isSelectedIndex! - 1]
            
            let childCellTwo = tableView.dequeueReusableCell(withIdentifier: "childCellTwo") as! ItineraryAccordionChildCellDescriptionTableViewCell
            let sub = MoreAboutTrip(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 300))
            sub.dayNumberLabel.removeFromSuperview()
            sub.dayDescription.text = getPlainTextFromHTMLContentText(str: selectedCity?["description"].stringValue)
            childCellTwo.descriptionCell.addSubview(sub)
            childCellTwo.selectionStyle = .none
            return childCellTwo
            
        }
        
        
        let parentCell = tableView.dequeueReusableCell(withIdentifier: "parentCell") as!
        ItineraryAccordionParentCellTableViewCell
        parentCell.cityName.text = cityLabels[(indexPath as NSIndexPath).row]
        parentCell.dayLabel.text = dayLabels[(indexPath as NSIndexPath).row]
        return parentCell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if (indexPath as NSIndexPath).row == 0 {
            
            return 400
            
        }
            
        else if cityLabels[(indexPath as NSIndexPath).row] == "Stayed At" ||  cityLabels[(indexPath as NSIndexPath).row] == "Ate At" || cityLabels[(indexPath as NSIndexPath).row] == "Must Do" {
            
            return 60
        }
        
        else if cityLabels[(indexPath as NSIndexPath).row] == "little more" {
            let selectedCity = (currentShowingCountry?["cityVisited"].arrayValue)?[isSelectedIndex! - 1]
            let height = heightForView(text: (selectedCity?["description"].stringValue)!, font: UIFont(name: "Avenir-Medium", size: 14)!, width: screenWidth)
            return height + 70
        }
        
        return 45
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            
        if (indexPath as NSIndexPath).row != 0 && cityLabels[(indexPath as NSIndexPath).row] != "little more" && cityLabels[(indexPath as NSIndexPath).row] != "Ate At" && cityLabels[(indexPath as NSIndexPath).row] != "Stayed At" && cityLabels[(indexPath as NSIndexPath).row] != "Must Do's" && cityLabels[(indexPath as NSIndexPath).row] != "little more" {
            
            if (isExpanded == true) {
                if(isSelectedIndex == (indexPath as NSIndexPath).row) {
                    
                    isExpanded = false
                    print("in if statement 1")
                    expandParent(isExpanded, index: isSelectedIndex!)
                    
                }
                    
                else {
                    let prevIndex = isSelectedIndex
                    expandParent(false, index: isSelectedIndex!)
                    isExpanded = true
                    if(prevIndex! < (indexPath as NSIndexPath).row) {
                        isSelectedIndex = (indexPath as NSIndexPath).row - childCells
                        print("in if statement 2")
                    } else {
                        isSelectedIndex = (indexPath as NSIndexPath).row
                        print("in if statement 4")
                    }
                    
                    expandParent(isExpanded, index: isSelectedIndex!)
                    
                }
                
                
            }
                
        else {
            isExpanded = true
            isSelectedIndex = (indexPath as NSIndexPath).item
            print("in if statement 3")
            expandParent(isExpanded, index: (indexPath as NSIndexPath).item)
        }
            
        }
        
//        if cityLabels[(indexPath as NSIndexPath).row] == "Ate At" || cityLabels[(indexPath as NSIndexPath).row] == "Stayed At" || cityLabels[(indexPath as NSIndexPath).row] == "Must Do" {
//            
//            let exploreHotelsVC = storyboard?.instantiateViewController(withIdentifier: "eachCityPagerStripVC") as! EachCityPagerViewController
//            exploreHotelsVC.whichView = cityLabels[(indexPath as NSIndexPath).row]
//            self.navigationController?.pushViewController(exploreHotelsVC, animated: true)
//            
//        }
        
    }
    
    func expandParent(_ isExpanded: Bool, index: Int) -> Void {
        
        if(isExpanded == true) {
            
            for j in 0 ..< childCells {
                cityLabels.insert(childCellArray[j], at: index + 1 + j)
                dayLabels.insert(childCellArray[j], at: index + 1 + j)
            }
            print("city labels: \(cityLabels)")
            print("day labels: \(dayLabels)")
            theTableView.reloadData()
            
            
        }
            
        else if(isExpanded == false) {
            
            for _ in 0 ..< childCells {
                if index ==  cityLabels.count {
                    
                    cityLabels.remove(at: index)
                    dayLabels.remove(at: index)
                }
                
                else {
                    
                    cityLabels.remove(at: index+1)
                    dayLabels.remove(at: index+1)
                }
                
            }
            theTableView.reloadData()
            
        }
    }
    

    func makeTabs(_ myTab: UIButton) -> Void {
        
        myTab.layer.cornerRadius = 7
        self.view.bringSubview(toFront: myTab)
        
    }
    
    
    //MARK: - Set Itinerari Data
    
    func setCountryTabs() {
        
        photosButton.setTitle((editJson?["name"].stringValue)! + " Photos", for: .normal)
        
        for button in allButtons {
            button.isHidden = true
        }
        
        let allCountries = editJson?["countryVisited"].arrayValue        
        countryButtonsStackWidthConstraint.constant = CGFloat((allCountries?.count)!) * (screenWidth * 0.2 - (CGFloat((allCountries?.count)!) * 5.0))        
        
        if (allCountries?.count)! > 0 {
            
            //Countries are there in itinerary
            for i in 0...((allCountries?.count)!-1){
                
                let country = allCountries?[i]
                
                allButtons[i].isHidden = false
                allButtons[i].setTitle(country?["country"]["name"].stringValue.capitalized, for: .normal)
                allButtons[i].tag = i
                makeTabs(allButtons[i])
            }
            
            //Show first country data by default
            tabTap(allButtons[0])
            prevSelectedTab = allButtons[0]
        }
            
        else {
            //No contries available please go back
            Toast(text: "No countries founf under \(editJson?["name"].stringValue) itinerary").show()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                _ = self.navigationController?.popViewController(animated: true)                
            })
        }
    }
    
    
    func setItineraryFor(countryIndex : Int) {
        
        if editJson != nil {
            
            currentShowingCountry = (editJson?["countryVisited"].arrayValue)?[countryIndex]
             
            print("\n CountryData : \(currentShowingCountry) \n")
            
            cityLabels = [" "]
            dayLabels = [" "]
            
            for city in (currentShowingCountry?["cityVisited"].arrayValue)! {                
                
                cityLabels.append(city["city"]["name"].stringValue)
                
                dayLabels.append("Day \(city["from"].stringValue) to Day \(city["to"].stringValue)")
            }
            
            theTableView.reloadData()            
        }
        
    }
    
    func getValueFor(showing: String, data: JSON) -> String {
        
        var value = ""
        let options = data[showing].arrayValue
        for item in options {
            value = value + " | " + item["name"].stringValue
         }
        if value.characters.count > 3 {
            let index = value.index(value.startIndex, offsetBy: 3)
            value = value.substring(from: index)
        }
        return value
    }

}


class ItineraryAccordionParentCellTableViewCell: UITableViewCell {
    
    @IBOutlet weak var cityName: UILabel!
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var buttonLabel: UIButton!
    
    @IBAction func buttonTap(_ sender: AnyObject) {
    
        sender.setTitle("-", for: .selected)
        
    }
    
}

class ItineraryAccordionChildCellTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleIcon: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var value: UILabel!
    
    
}

class ItineraryAccordionChildCellDescriptionTableViewCell: UITableViewCell {
    
    @IBOutlet weak var descriptionCell: UIView!
    
    
}

class EachItineraryPostTableViewCell : UITableViewCell {
    
    @IBOutlet weak var myView: UIView!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        print("In the cell init function \(myView)")
        
        
    }
    
}
