
import UIKit

class EmptyScreenView: UIView {

    @IBOutlet weak var LL: UIImageView!
    @IBOutlet weak var TL: UIImageView!
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib ()
        
        TL.tintColor = UIColor(red: 241/255, green: 242/255, blue: 242/255, alpha: 1)
        LL.tintColor = UIColor(red: 241/255, green: 242/255, blue: 242/255, alpha: 1)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func loadViewFromNib() {
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: "EmptyScreenView", bundle: bundle)
        let view = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
        view.frame = bounds
        view.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        self.addSubview(view);
    }

}
