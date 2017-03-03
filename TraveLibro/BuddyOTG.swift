
import UIKit

class BuddyOTG: UIView {

    @IBOutlet weak var lineSeparator: UIView!
    @IBOutlet weak var clockTime: UILabel!
    @IBOutlet weak var clockLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var joinJourneytext: UILabel!
    @IBOutlet weak var timestamp: UILabel!
    @IBOutlet weak var infoview: UIView!
    @IBOutlet weak var calendarLabel: UILabel!
    
    @IBOutlet weak var drawLine: drawLine!
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib ()
        
        infoview.layer.cornerRadius = 20
        infoview.clipsToBounds = true
        drawLine.backgroundColor = UIColor.clear
        
        timestamp.shadowColor = UIColor.black
        timestamp.shadowOffset = CGSize(width: 1, height: 1)
        timestamp.layer.masksToBounds = true
       
        

        
        clockTime.shadowColor = UIColor.black
        clockTime.shadowOffset = CGSize(width: 1, height: 1)
        clockTime.layer.masksToBounds = true
        
        

        lineSeparator.layer.zPosition = 10
        calendarLabel.text = String(format: "%C", faicon["clock"]!)
        clockLabel.text = String(format: "%C", faicon["calendar"]!)
        timestamp.layer.zPosition = 10
        clockTime.layer.zPosition = 10
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
    }

}
