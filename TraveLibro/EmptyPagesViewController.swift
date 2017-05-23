import UIKit

class EmptyPagesViewController: UIViewController {
    
    var whichView: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let leftButton = UIButton()
        leftButton.setImage(UIImage(named: "arrow_prev"), for: UIControlState())
        leftButton.addTarget(self, action: #selector(self.gotoProfile(_:)), for: .touchUpInside)
        leftButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        self.customNavigationBar(left: leftButton, right: nil)
        
        let nocountries = NoCountriesVisited(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 109))
        nocountries.center = self.view.center
        self.view.addSubview(nocountries)
        
        nocountries.addCountriesButton.addTarget(self, action: #selector(EmptyPagesViewController.addCountries(_:)), for: .touchUpInside)
        
        if whichView == "BucketList" {
            self.title = "Bucket List"
            nocountries.countriesVisitedLabel.text = "Add Countries To Your Bucket List Here"
        }
            
        else if whichView == "CountriesVisited" {
            self.title = "Countries Visited"
            nocountries.countriesVisitedLabel.text = "Add Countries To Your Countries Visited Here"
        }
    }
    
    func addCountries(_ sender: UIButton) {
        let nextVC = storyboard?.instantiateViewController(withIdentifier: "SelectCountryVC") as! SelectCountryViewController
        nextVC.whichView = whichView
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func gotoProfile(_ sender: UIButton?) {
        
        let allControllers = self.navigationController?.viewControllers
        print("\n allControllers : \(allControllers)")
        var found = false
        let count = ((allControllers?.count)!-1)
        
        for i in stride(from: count, through: 0, by: -1) {
            let vc = allControllers?[i]
            
            if (vc?.isKind(of: TLProfileViewController.self))! {                
                found = true
                self.navigationController!.popToViewController(vc!, animated: true)
                break
            }
        }
        
        if !found {
            print("\n please check")
            leftViewController.profileTap(nil)
        }
    }
    
}
