
import UIKit

class AddActivityNew: UIView {

    @IBOutlet weak var locationView: UIView!
    @IBOutlet weak var photosIntialView: UIView!
    @IBOutlet weak var photosFinalView: UIView!
    @IBOutlet weak var videosInitialView: UIView!
    @IBOutlet weak var videosFinalView: UIView!
    @IBOutlet weak var thoughtsInitalView: UIView!
    @IBOutlet weak var thoughtsFinalView: UIView!
    @IBOutlet weak var tagFriendsView: UIView!
    
    @IBOutlet weak var addLocationButton: UIButton!
    @IBOutlet weak var locationTag: UIImageView!
    
    @IBOutlet weak var photosButton: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib ()
        
        let darkBlur = UIBlurEffect(style: UIBlurEffectStyle.Light)
        let blurView = UIVisualEffectView(effect: darkBlur)
        blurView.frame.size.height = self.frame.height
        blurView.frame.size.width = self.frame.width
        blurView.layer.zPosition = -1
        blurView.userInteractionEnabled = false
        self.addSubview(blurView)
        
        photosFinalView.hidden = true
        videosFinalView.hidden = true
        thoughtsFinalView.hidden = true
        
    }
    
    func getStylesOn(view: UIView) {
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func loadViewFromNib() {
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: "AddActivityNew", bundle: bundle)
        let view = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
        view.frame = bounds
        view.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        self.addSubview(view);
    }

}
