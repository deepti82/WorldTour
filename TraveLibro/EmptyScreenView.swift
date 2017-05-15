
import UIKit

class EmptyScreenView: UIView {

    @IBOutlet weak var viewBody: UILabel!
    @IBOutlet weak var viewHeading: UILabel!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var buttonText: UILabel!
    var whichView: String = ""
    var parentController: UIViewController?
    
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
        whichView = life
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
            
            let vc = storyboard!.instantiateViewController(withIdentifier: "localLife") as! LocalLifeRecommendationViewController
            vc.isBack = true
            parentController?.navigationController?.setNavigationBarHidden(false, animated: true)
            parentController?.navigationController?.pushViewController(vc, animated: true)


        }else{
            let vc = storyboard!.instantiateViewController(withIdentifier: "newTL") as! NewTLViewController
            vc.isJourney = false
            vc.insideView = "journey"
            parentController?.navigationController?.setNavigationBarHidden(false, animated: true)
            parentController?.navigationController?.pushViewController(vc, animated: true)

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
