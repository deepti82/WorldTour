
import UIKit

class BuddyOTG: UIView {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var joinJourneytext: UILabel!
    @IBOutlet weak var timestamp: UILabel!
    @IBOutlet weak var infoview: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib ()
        
        infoview.layer.cornerRadius = 5
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func loadViewFromNib() {
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: "BuddyOTG", bundle: bundle)
        let view = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
        view.frame = bounds
        view.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        self.addSubview(view);
    }

}
