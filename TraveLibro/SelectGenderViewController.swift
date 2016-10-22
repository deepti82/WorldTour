import UIKit

class SelectGenderViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        getDarkBackGroundBlur(self)
        
        let leftButton = UIButton()
        leftButton.setImage(UIImage(named: "arrow_prev"), for: UIControlState())
        leftButton.addTarget(self, action: #selector(self.popVC(_:)), for: .touchUpInside)
        leftButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        
        let rightButton = UIButton()
        rightButton.setImage(UIImage(named: "arrow_next_fa"), for: UIControlState())
        rightButton.addTarget(self, action: #selector(SelectGenderViewController.gotoDP(_:)), for: .touchUpInside)
        rightButton.frame = CGRect(x: 0, y: 8, width: 30, height: 30)
        
        self.customNavigationBar(left: leftButton, right: rightButton)
        
        print("current gender: \(currentUser["gender"])")
        
        let f = GenderInfo() 
        f.setNeedsDisplay()
        
        let gender = GenderInfo(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 300))
        gender.center = CGPoint(x: self.view.frame.width/2, y: self.view.frame.height/2)
        if currentUser["gender"] != nil {
            
            if currentUser["gender"] == "female" {
                
                gender.sheButtonTap(nil)
                
            }
            
            else {
                
                gender.heButtonTap(nil)
                
            }

        }
        self.view.addSubview(gender)
        
    }
    
    func gotoDP(_ sender: UIButton) {
        
        //Add edit data request here
        
        if genderValue == nil {
            
            genderValue = ""
        }
        
        request.editUser(currentUser["_id"].string!, editField: "gender", editFieldValue: genderValue, completion: {(response) in
            
            DispatchQueue.main.async(execute: {
                
                if response.error != nil {
                    
                    print("response: \(response.error?.localizedDescription)")
                }
                else if let abc = response["value"].string {
                    
                    print("response arrived!")
                    let dpVC = self.storyboard!.instantiateViewController(withIdentifier: "setDp") as! SetProfilePictureViewController
                    self.navigationController?.pushViewController(dpVC, animated: true)
                    
                }
                else {
                    
                    print("response error: \(response["data"])")
                    
                }
            })
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
