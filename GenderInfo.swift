
import UIKit
import SwiftyJSON

var genderValue: String!

class GenderInfo: UIView {
    
    @IBOutlet weak var sheButton: UIButton!
    @IBOutlet weak var heButton: UIButton!
    
    @IBAction func sheButtonTap(sender: AnyObject?) {
        
        genderValue = "female"
        heButton.tintColor = UIColor.lightGrayColor()
        sheButton.tintColor = UIColor(red: 75/255, green: 203/255, blue: 187/255, alpha: 1)
    }
    
    @IBAction func heButtonTap(sender: AnyObject?) {
        
        genderValue = "male"
        sheButton.tintColor = UIColor.lightGrayColor()
        heButton.tintColor = mainOrangeColor
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        loadViewFromNib ()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func loadViewFromNib() {
        
        print("\(currentUser["gender"])")
        
//        if currentUser["gender"].string! == "female" {
//            
//            sheButtonTap(nil)
//            
//        }
//            
//        else {
//            
//            heButtonTap(nil)
//            
//        }
        
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: "GenderInfo", bundle: bundle)
        let view = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
        view.frame = bounds
        view.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        self.addSubview(view);
        
    }

}
