import UIKit

var checkBoxNumber: Int!

class SignupCardsViewController: UIViewController {
    
    var pageIndex = 0
    var cardTitle: String = ""
    var cardDescription: String = "Lorem Ipsum is simply dummy text of the printing and typesetting industry"
    var checkBoxes: CGFloat =  6
    var cardViewHeight: CGFloat!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        getUser()
        
        checkBoxNumber = Int(checkBoxes)
        
        let theScrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        theScrollView.delaysContentTouches = false
        self.view.addSubview(theScrollView)
        
//        let view = TutorialCards()
//        view.cardDescription.text = "Lorem Ipsum is simply dummy"
        
        if checkBoxes < 6 {
            
            cardViewHeight = checkBoxes * 125 + 75
            
        }
        
        else if checkBoxes == 8 {
            
            cardViewHeight = checkBoxes * 100 - 50
            
        }
            
        else if checkBoxes == 11 {
            
            cardViewHeight = checkBoxes * 100 - 80
            
        }
        
        else {
            
            cardViewHeight = checkBoxes * 125 - 75
            
        }
        
        
        let cardView = TutorialCards(frame: CGRect(x: 25, y: 125, width: self.view.frame.width - 50, height: cardViewHeight))
        cardView.cardTitle.text = cardTitle
        cardView.cardDescription.text = cardDescription
        theScrollView.addSubview(cardView)
        
        if checkBoxes > 6 {
            
            theScrollView.contentSize.height = cardView.frame.height + 50
        }
    }
    
    func getUser() {
        
        request.getUser(currentUser["_id"].string!, completion: {(response) in
            
            dispatch_async(dispatch_get_main_queue(), {
                
                if response.error != nil {
                    
                    print("response: \(response.error?.localizedDescription)")
                    
                }
                else if response["value"] {
                    
                    //                    currentUser = response
                }
                else {
                    
                    print("response error: \(response["error"])")
                }
            })
            
        })
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
