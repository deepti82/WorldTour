
import UIKit

class BuddyOTG: UIView {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var joinJourneytext: UILabel!
    @IBOutlet weak var timestamp: UILabel!
    @IBOutlet weak var infoview: UIView!
    @IBOutlet weak var drawHeaderLine: drawLine!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib ()
        
        infoview.layer.cornerRadius = 5
        infoview.clipsToBounds = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func loadViewFromNib() {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "BuddyOTG", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(view);
        drawHeaderLine.backgroundColor = UIColor.clear
    }

}
