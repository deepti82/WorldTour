import UIKit

class SelectGenderViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        getDarkBackGroundBlur(self)
        
        let leftButton = UIButton()
        leftButton.setImage(UIImage(named: "arrow_prev"), forState: .Normal)
        leftButton.addTarget(self, action: #selector(self.popVC(_:)), forControlEvents: .TouchUpInside)
        leftButton.frame = CGRectMake(0, 0, 30, 30)
        
        let rightButton = UIButton()
        rightButton.setImage(UIImage(named: "arrow_next_fa"), forState: .Normal)
        rightButton.addTarget(self, action: #selector(SelectGenderViewController.gotoDP(_:)), forControlEvents: .TouchUpInside)
        rightButton.frame = CGRectMake(0, 8, 30, 30)
        
        self.customNavigationBar(leftButton, right: rightButton)
        
        print("current gender: \(currentUser["gender"].string!)")
        
        let f = GenderInfo() 
        f.setNeedsDisplay()
        
        let gender = GenderInfo(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 300))
        gender.center = CGPointMake(self.view.frame.width/2, self.view.frame.height/2)
        if currentUser["gender"].string! == "female" {

            gender.sheButtonTap(nil)

        }

        else {

            gender.heButtonTap(nil)
            
        }
        self.view.addSubview(gender)
        
    }
    
    func gotoDP(sender: UIButton) {
        
        //Add edit data request here
        
        let dpVC = storyboard?.instantiateViewControllerWithIdentifier("setDp") as! SetProfilePictureViewController
        self.navigationController?.pushViewController(dpVC, animated: true)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
