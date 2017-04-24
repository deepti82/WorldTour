
import UIKit

class EmptyScreenView: UIView {

    @IBOutlet weak var viewBody: UILabel!
    @IBOutlet weak var viewHeading: UILabel!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var buttonText: UILabel!
    var whichView: String = ""
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib ()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func loadViewFromNib() {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "EmptyScreenView", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(view);
    }
    func setColor(life:String, buttonLabel:String) {
        if isSelfUser(otherUserID: currentUser["_id"].stringValue) {
            addButton.isHidden = false
            buttonText.isHidden = false
        }else{
            addButton.isHidden = true
            buttonText.isHidden = true
        }
        buttonText.text = buttonLabel
        if life == "locallife" {
            addButton.setImage(UIImage(named:"addCountries"), for: .normal)
        }else{
            addButton.setImage(UIImage(named:"tl"), for: .normal)
        }
    }
    @IBAction func addButtonClicked(_ sender: UIButton) {
        if whichView == "locallife" {
            let vc = storyboard?.instantiateViewController(withIdentifier: "localLife") as! LocalLifeRecommendationViewController
            self.setVC(newViewController: vc)
        }else{
        let vc = storyboard!.instantiateViewController(withIdentifier: "newTL") as! NewTLViewController
        vc.isJourney = false
        if(currentUser["journeyId"].stringValue == "-1") {
            isJourneyOngoing = false
            vc.showJourneyOngoing(journey: JSON(""))
        }
            self.setVC(newViewController: vc)
        }
        
    }
    
    func setVC(newViewController : UIViewController) {
        
        let nvc = UINavigationController(rootViewController: newViewController)
        leftViewController.mainViewController = nvc
        leftViewController.slideMenuController()?.changeMainViewController(leftViewController.mainViewController, close: true)
        
        UIViewController().customiseNavigation()
        nvc.delegate = UIApplication.shared.delegate as! UINavigationControllerDelegate?
    }

    
}
