import UIKit
import Spring
class QuickIteneraryTwo: UIViewController {
    @IBOutlet var typeButton: [UIButton]!
    @IBOutlet weak var adventureAnimation: SpringButton!
    @IBOutlet weak var blurBG: UIView!
    @IBOutlet weak var businessAnimation: SpringButton!
    var eachButton: [String] = []
    
    @IBOutlet var allLabel: [UILabel]!
    @IBOutlet weak var firstStack: UIStackView!
    var itineraryTypes:JSON?
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.firstStack.spacing = firstStack.width
        let array = ["adventure", "business", "family", "budget", "backpacking", "romance", "friends", "religious", "luxury", "solo", "shopping", "festival"]
        
        if itineraryTypes != nil {
            quickItinery["itineraryType"] = itineraryTypes!
        }
        
        if quickItinery["itineraryType"] == nil {
            quickItinery["itineraryType"] = JSON(eachButton)
        }
       
        
        for eachButton in typeButton {
//            eachButton.imageView?.contentMode = .scaleAspectFit
//            eachButton.clipsToBounds = true
            eachButton.addTarget(self, action: #selector(typeButtonPressed(_:)), for: .touchUpInside)
        }
        
        for button in typeButton {
            let index = typeButton.index(of: button)
            button.setTitle(array[index!], for: .application)
        }
        transparentCardWhite(blurBG)
        
        if(self.itineraryTypes != nil) {            
            let arr = self.itineraryTypes?.arrayValue
            
            for eachButton in typeButton {
                for text in arr! {
                    if(text.stringValue.lowercased() == eachButton.titleLabel?.text?.lowercased()) {
                        self.typeButtonPressed(eachButton)                        
                    }
                }
            }
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        setAnalytics(name: "Quickitinerary page Two")
        print("0000000000\(screenWidth)000\(screenWidth/35)")
        for lbl in allLabel {
            lbl.font = lbl.font.withSize(screenWidth/35)
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func typeButtonPressed(_ sender: UIButton!){
        if sender.tag == 0 {
            sender.setBackgroundImage(UIImage(named: "orangebox"), for: .normal)
//            sender.imageView?.contentMode = .scaleAspectFit
//            sender.clipsToBounds = true
            eachButton.append(sender.currentTitle!)
            sender.tag = 1
        }
        else {
            sender.setBackgroundImage(UIImage(named: "bluebox"), for: .normal)
            eachButton = eachButton.filter { $0 != sender.currentTitle }
            sender.tag = 0
//            sender.imageView?.contentMode = .scaleAspectFit
//            sender.clipsToBounds = true
        }
        quickItinery["itineraryType"] = JSON(eachButton)
    }
}
