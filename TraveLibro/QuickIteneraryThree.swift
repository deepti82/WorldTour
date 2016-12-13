//
//  QuickIteneraryThree.swift
//  TraveLibro
//
//  Created by Pranay Joshi on 07/12/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit

class QuickIteneraryThree: UIViewController, UITextFieldDelegate,  UITableViewDelegate  {

    @IBOutlet weak var cityTableTitle: UILabel!
    @IBOutlet weak var countryTableTitle: UILabel!
    @IBOutlet weak var cityTableView: UITableView!
    @IBOutlet weak var countryTableView: UITableView!
    @IBOutlet weak var showCountryCityVisited: UIView!
    @IBOutlet weak var cityVisitedButton: UIButton!
    @IBOutlet weak var countryVisitedButton: UIButton!
    @IBOutlet weak var addCountry: UIButton!
    @IBOutlet weak var cityVisited: UITextField!
    @IBOutlet weak var countryVisited: UITextField!
    let verticalLayout = VerticalLayout(width: 360)
    override func viewDidLoad() {
        super.viewDidLoad()
        print("demo checking checking")
        print(quickItinery)
        getCountry()
        addCountry.layer.cornerRadius = 5
        addCountry.addTarget(self, action: #selector(addCountryFunction(_:)), for: .touchUpInside)
        showCountryCityVisited.addSubview(verticalLayout)
        cityVisited.delegate = self
        countryVisited.delegate = self
        countryVisitedButton.isHidden = true
        cityVisitedButton.isHidden = true
        // Do any additional setup after loading the view.
    }
    
    func getCountry() {
        request.getAllCountries({(request) in
            print(request)
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func addCountryFunction(_ sender: UIButton) {
        
        let showCountryButton = UIButton(frame: CGRect(x: 0, y: 0, width: 150, height: 20))
        //showCountryButton.backgroundColor = UIColor.yellow
        showCountryButton.layoutIfNeeded()
        showCountryButton.titleLabel?.textAlignment = NSTextAlignment.left
        showCountryButton.setTitleColor(UIColor.black, for: .normal)
        verticalLayout.addSubview(showCountryButton)
        let cancelLabel = UILabel(frame: CGRect(x: 5, y: 5, width: 10, height: 10))
        cancelLabel.font = UIFont(name: "FontAwesome", size: 15)
        cancelLabel.text = String(format: "%C", faicon["close"]!)
        cancelLabel.textColor = UIColor(colorLiteralRed: 35/255, green: 45/255, blue: 74/255, alpha: 1)
        showCountryButton.addSubview(cancelLabel)
        
        showCountryButton.addTarget(self, action: #selector(removeCountryCity(_:)), for: .touchUpInside)
        //increaseHeight(buttonHeight: 20)
        if countryVisited != nil && cityVisited != nil {
            styleHorizontalButton(showCountryButton, buttonTitle: "\(countryVisited.text!), \(cityVisited.text!)")
        }
    }
    
    
    func styleHorizontalButton(_ button: UIButton, buttonTitle: String) {
        
        //        print("inside the style horizontal button")
        //button.backgroundColor = UIColor.clear
        button.titleLabel!.font = avenirFont
        // button.titleLabel?.backgroundColor = UIColor.black
        button.setTitle(buttonTitle, for: UIControlState())
        button.setTitleColor(mainBlueColor, for: UIControlState())
        button.layer.cornerRadius = 5
        button.layer.borderColor = UIColor.darkGray.cgColor
        button.layer.borderWidth = 1.0
        
    }
    
    func removeCountryCity(_ sender: UIButton){
        sender.removeFromSuperview()
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        cityVisited.resignFirstResponder()
        countryVisited.resignFirstResponder()
        return true
        
    }
    
    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        
//        return names.count
//        
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        
//        let cell = self.tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! AddFriendsViewCell
//        
//        cell.friendImage.image = images[(indexPath as NSIndexPath).row]
//        cell.friendName.text = names[(indexPath as NSIndexPath).row]
//        
//        return cell
//    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
