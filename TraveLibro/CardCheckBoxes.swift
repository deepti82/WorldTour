import UIKit

import SwiftHTTP

class CardCheckBoxes: UIView {

    @IBOutlet weak var labelRight: UILabel!
    @IBOutlet weak var labelLeft: UILabel!
    @IBOutlet weak var buttonRight: UIButton!
    @IBOutlet weak var buttonLeft: UIButton!
    @IBOutlet weak var rightButtonStack: UIStackView!
    @IBOutlet weak var leftButtonStack: UIStackView!
    
    var flag = 0
//    var isRadio = false
    
    
    @IBAction func checkBoxTap(_ sender: UIButton) {
        
        if sender.currentBackgroundImage == UIImage(named: "halfnhalfbgGray") {
            
            print("sender title: \(sender.titleLabel?.text)")
            sender.setBackgroundImage(UIImage(named: "halfnhalfbgGreen"), for: UIControlState())
            
            print("cardTitle: \(cardTitle)")
            
//            if flag == 0 && cardTitle == "holidayType" {
//                
//                selectedOptions = []
//                flag = 1
//            }
            
            if !selectedOptions.contains(sender.titleLabel!.text!) {
                
                selectedOptions.append(sender.titleLabel!.text!)
                
            }
        }
        
        else {
            
            print("sender title: \(sender.titleLabel?.text)")
            sender.setBackgroundImage(UIImage(named: "halfnhalfbgGray"), for: UIControlState())
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib ()
        
//        print("is radio: \(isRadio)")
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func loadViewFromNib() {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "CardCheckBoxes", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(view);
    }

}
