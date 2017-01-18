//
//  LocalLifeRecommendationViewController.swift
//  TraveLibro
//
//  Created by Midhet Sulemani on 01/06/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit

class LocalLifeRecommendationViewController: UIViewController {

    @IBOutlet weak var thisScroll: UIScrollView!
    var layout:VerticalLayout!
    
    @IBOutlet weak var plusButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        getDarkBackGround(self)
        self.layout = VerticalLayout(width:screenWidth)
        self.setNavigationBarItemText("Local Life")
   
        self.thisScroll.addSubview(layout)
        
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 40))
        titleLabel.center = CGPoint(x: self.view.frame.width/2, y: 20)
        titleLabel.text = "Experience Mumbai like a local"
        titleLabel.font = UIFont(name: "Avenir-Roman", size: 16)
        titleLabel.textAlignment = .center
        titleLabel.textColor = UIColor.white
        layout.addSubview(titleLabel)
        

        let myView = LocalLifeRecommends(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 400))
        myView.photoTop.image = UIImage(named: "restaurantsLocalLife")
        myView.topLabel.text = "Restaurants and Bars"
        myView.photoBottom1.image = UIImage(named: "naturesLocalLife")
        myView.bottomLabel1.text = "Nature and Parks"
        myView.photoBottom2.image = UIImage(named: "sightsLocalLife")
        myView.bottomLabel2.text = "Sights and Landmarks"
        layout.addSubview(myView)
        
        let myView2 = LocalLifeRecommends(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 400))
        myView2.photoTop.image = UIImage(named: "museumsLocalLife")
        myView2.topLabel.text = "Museums and Galleries"
        myView2.photoBottom1.image = UIImage(named: "adventureLocalLife")
        myView2.bottomLabel1.text = "Adventure and Excursions"
        myView2.photoBottom2.image = UIImage(named: "bgzoosandaqua")
        myView2.bottomLabel2.text = "Zoos and Aquariums"
        layout.addSubview(myView2)
        
        let myView3 = LocalLifeRecommends(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 400))
        myView3.photoTop.image = UIImage(named: "bgeventsandfestival")
        myView3.topLabel.text = "Events and Festival"
        myView3.photoBottom1.image = UIImage(named: "bgshopping")
        myView3.bottomLabel1.text = "Shopping"
        myView3.photoBottom2.image = UIImage(named: "image1")
        myView3.bottomLabel2.text = "Beaches"
        layout.addSubview(myView3)
        
        let myView4 = LocalLifeRecommends(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 400))
        myView4.photoTop.image = UIImage(named: "bgreligious")
        myView4.topLabel.text = "Religious"
        myView4.photoBottom1.image = UIImage(named: "bgcinemasandtheatre")
        myView4.bottomLabel1.text = "Cinemas and Theatres"
        myView4.photoBottom2.image = UIImage(named: "bghotelsandaccom")
        myView4.bottomLabel2.text = "Hotels and accommodations"
        layout.addSubview(myView4)

        let footer = FooterViewNew(frame: CGRect(x: 0, y: self.view.frame.height - 60, width: self.view.frame.width, height: 60))
        self.view.addSubview(footer)
        
//        let myView5 = LocalLifeRecommends(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 400))
//        layout.addSubview(myView5)
        
        
        

        self.addHeightToLayout();
    }
    
    override func viewDidAppear(_ animated: Bool) {
        globalNavigationController = self.navigationController
    }
    
    func addHeightToLayout() {
        self.layout.layoutSubviews()
        self.thisScroll.contentSize = CGSize(width: self.layout.frame.width, height: self.layout.frame.height + 60)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func checkInTap(_ sender: UIButton) {
        
        print("checkInButtonWasTapped")
        let checkInOneVC = storyboard?.instantiateViewController(withIdentifier: "checkInSearch") as! CheckInSearchViewController
        self.navigationController?.pushViewController(checkInOneVC, animated: true)
        
    }
    
    @IBAction func addAction(_ sender: Any) {
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
