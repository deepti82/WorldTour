import UIKit

class QuickItineraryOne: UIView {

    @IBOutlet weak var tripTitle: UITextField!
    
    @IBOutlet weak var monthPickerView: UITextField!
  
    @IBOutlet weak var durationTextField: UITextField!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var yearPickerView: UITextField!
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib ()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func loadViewFromNib() {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "QuickItineraryOne", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(view);
    }

}
