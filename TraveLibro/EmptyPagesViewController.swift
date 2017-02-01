import UIKit

class EmptyPagesViewController: UIViewController {
    
    var whichView: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let leftButton = UIButton()
        leftButton.setImage(UIImage(named: "arrow_prev"), for: UIControlState())
        leftButton.addTarget(self, action: #selector(self.popToProfile(_:)), for: .touchUpInside)
        leftButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        self.customNavigationBar(left: leftButton, right: nil)
        
        let nocountries = NoCountriesVisited(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 109))
        nocountries.center = self.view.center
        self.view.addSubview(nocountries)
        
        nocountries.addCountriesButton.addTarget(self, action: #selector(EmptyPagesViewController.addCountries(_:)), for: .touchUpInside)
        
        if whichView == "BucketList" {
            self.title = "Bucket List"
            self.navigationController?.navigationBar.titleTextAttributes = [ NSFontAttributeName: UIFont(name: "Avenir-Medium", size: 18)!]

            nocountries.countriesVisitedLabel.text = "Add Countries To Your Bucket List Here"
        }
            
        else if whichView == "CountriesVisited" {
            self.title = "Countries Visited"
            self.navigationController?.navigationBar.titleTextAttributes = [ NSFontAttributeName: UIFont(name: "Avenir-Medium", size: 18)!]

            nocountries.countriesVisitedLabel.text = "Add Countries To Your Countries Visited Here"
        }
    }
    
    func popToProfile(_ sender: UIButton) {
        let prevVC = storyboard?.instantiateViewController(withIdentifier: "ProfileVC") as! ProfileViewController
        self.navigationController?.pushViewController(prevVC, animated: false)
    }
    
    func addCountries(_ sender: UIButton) {
        let nextVC = storyboard?.instantiateViewController(withIdentifier: "SelectCountryVC") as! SelectCountryViewController
        nextVC.whichView = whichView
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
