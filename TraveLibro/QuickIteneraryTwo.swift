import UIKit
import Spring
class QuickIteneraryTwo: UIViewController {
    @IBOutlet var typeButton: [UIButton]!
    @IBOutlet weak var adventureAnimation: SpringButton!
    @IBOutlet weak var blurBG: UIView!
    @IBOutlet weak var businessAnimation: SpringButton!
    var eachButton: [String] = []
    
    var itineraryTypes:JSON!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let array = ["adventure", "business", "family", "budget", "backpacking", "romance", "friends", "religious", "luxury", "solo", "shopping", "festival"]
        if quickItinery["itineraryType"] == nil {
            quickItinery["itineraryType"] = JSON(eachButton)
        }
        for eachButton in typeButton {
            eachButton.addTarget(self, action: #selector(typeButtonPressed(_:)), for: .touchUpInside)
        }
        for button in typeButton {
            let index = typeButton.index(of: button)
            button.setTitle(array[index!], for: .application)
        }
        transparentCardWhite(blurBG)
        if(self.itineraryTypes != nil) {
            print(self.itineraryTypes);
            var arr = self.itineraryTypes.array
            
            for eachButton in typeButton {
                for text in arr! {
                    if(text.stringValue == eachButton.titleLabel?.text) {
                        self.typeButtonPressed(eachButton);
                    }
                }
            }
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        print(quickItinery)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    func typeButtonPressed(_ sender: UIButton!){
        if sender.tag == 0 {
            sender.setBackgroundImage(UIImage(named: "orangebox"), for: .normal)
            eachButton.append(sender.title(for: .application)!)
            sender.tag = 1
        }
        else {
            sender.setBackgroundImage(UIImage(named: "bluebox"), for: .normal)
            eachButton = eachButton.filter({$0 != sender.currentTitle})
            sender.tag = 0
        }
        quickItinery["itineraryType"] = JSON(eachButton)
    }
}
