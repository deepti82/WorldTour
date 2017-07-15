import UIKit

class SelectGenderViewController: UIViewController {
    var dpVC: SetProfilePictureViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getDarkBackGroundBlur(self)
        
        dpVC = self.storyboard!.instantiateViewController(withIdentifier: "setDp") as! SetProfilePictureViewController
//        loader.showOverlay(self.view)
        
        
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setAnalytics(name: "Select Gender")
        let leftButton = UIButton()
        leftButton.setImage(UIImage(named: "arrow_prev"), for: UIControlState())
        leftButton.addTarget(self, action: #selector(self.popVC(_:)), for: .touchUpInside)
        leftButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        
        let rightButton = UIButton()
        rightButton.setImage(UIImage(named: "arrow_next_fa"), for: UIControlState())
        rightButton.addTarget(self, action: #selector(SelectGenderViewController.gotoDP(_:)), for: .touchUpInside)
        rightButton.frame = CGRect(x: 0, y: 8, width: 30, height: 30)
        
        self.customNavigationBar(left: leftButton, right: rightButton)

    }
    
    func gotoDP(_ sender: UIButton) {
        
        //Add edit data request here
        sender.isUserInteractionEnabled = false
        
        if genderValue == nil {
            loader.hideOverlayView()
            genderValue = ""
        }
        
        request.editUser(currentUser["_id"].string!, editField: "gender", editFieldValue: genderValue, completion: {(response) in
            
            DispatchQueue.main.async(execute: {
                loader.hideOverlayView()
                if response.error != nil {
                    print("response: \(String(describing: response.error?.localizedDescription))")
                }
                else if response["value"].bool! {
                    self.navigationController?.pushViewController(self.dpVC, animated: true)
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
