
import UIKit

class MoreAboutMeScrollForProfile: UIView {

    @IBOutlet weak var MAMView: UIView!
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib ()
        
        let myView = MoreAboutMe(frame: CGRect(x: 0, y: 0, width: MAMView.frame.width - 20, height: MAMView.frame.height))
        MAMView.addSubview(myView)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func loadViewFromNib() {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "MoreAboutMeScrollForProfile", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(view);
    }

}
