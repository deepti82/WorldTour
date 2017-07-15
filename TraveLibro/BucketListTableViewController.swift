

import UIKit
import Toaster

class BucketListTableViewController: UITableViewController  {
    
    var whichView: String!
    var bucket: [JSON] = []
    var result: [JSON] = []
    //    var countriesVisited: [JSON] = []
    var isComingFromEmptyPages = false
    var otherUser: String = ""
    var loader = LoadingOverlay()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loader.showOverlay(self.view)
        getDarkBackGround(self)
        
        self.updateNavigationBar()
        
        if whichView == "BucketList" {
            self.title = "Bucket List"
            getBucketList()
        }
        
        if whichView == "CountriesVisited" {
            self.title = "Countries Visited"
            getCountriesVisited()
        }
        
        tableView.separatorColor = UIColor.white
    }
    
    func updateNavigationBar(){
        
        let leftButton = UIButton()
        leftButton.setImage(UIImage(named: "arrow_prev"), for: UIControlState())
        leftButton.addTarget(self, action: #selector(self.gotoProfile(_:)), for: .touchUpInside)
        leftButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        
        let rightButton = UIButton()
        rightButton.setImage(UIImage(named: "add_fa_icon"), for: UIControlState())
        rightButton.addTarget(self, action: #selector(BucketListTableViewController.addCountriesVisited(_:)), for: .touchUpInside)
        rightButton.frame = CGRect(x: 0, y: 8, width: 30, height: 30)
        if otherUser == "search" {
            self.customNavigationBar(left: leftButton, right: nil)
        }else{
            if whichView == "CountriesVisited" {
                if self.result.count > 0 {
                    self.customNavigationBar(left: leftButton, right: rightButton)
                }
                else {
                    self.customNavigationBar(left: leftButton, right: nil)
                }
            }
            else {
                self.customNavigationBar(left: leftButton, right: rightButton)
            }
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setAnalytics(name: "Bucket List")

        if isComingFromEmptyPages {
            
            print("has come here")
            
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func gotoProfile(_ sender: UIButton?) {
        
        let allControllers = self.navigationController?.viewControllers
        print("\n allControllers : \(String(describing: allControllers))")
        var found = false
        let count = ((allControllers?.count)!-1)
        
        for i in stride(from: count, through: 0, by: -1) {
            let vc = allControllers?[i]
            
            if (vc?.isKind(of: TLProfileViewController.self))! {                
                found = true
                self.navigationController!.popToViewController(vc!, animated: true)
                break
            }
        }
       
        if !found {
            print("\n please check")
            leftViewController.profileTap(nil)
        }
    }
    
    func getBucketList() {
        
        request.getBucketList(currentUser["_id"].string!, completion: {(response) in
            
            DispatchQueue.main.async(execute: {
                self.loader.hideOverlayView()
                if response.error != nil {
                    print("error - \(String(describing: response.error?.code)): \(String(describing: response.error?.localizedDescription))")
                }
                else if response["value"].bool! {
                    
                    self.bucket = response["data"]["bucketList"].array!
                    print(self.bucket);
                    if self.bucket.count == 0 {
                        print("bucket list is empty")
                        let emptyBucket = self.storyboard?.instantiateViewController(withIdentifier: "emptyPages") as! EmptyPagesViewController
                        emptyBucket.whichView = self.whichView
                        self.navigationController?.pushViewController(emptyBucket, animated: false)
                    }
                    self.tableView.reloadData()
                    
                }
                else {
                    
                    print("response error: \(response["data"])")
                    
                }
            })
            
        })
        
        
        //        }
        
    }
    
    
    func getCountriesVisited() {
        
        request.getCountriesVisited(currentUser["_id"].string!, completion: {(response) in
            
            DispatchQueue.main.async(execute: {
                self.loader.hideOverlayView()
                if response.error != nil {
                    print("error - \(String(describing: response.error?.code)): \(String(describing: response.error?.localizedDescription))")
                }
                else if response["value"].bool! {
                    
                    self.result = response["data"]["countriesVisited"].array!
                    getCountries = self.result
                    
                    if self.result.count == 0 {
                        
                        print("bucket list is empty")
                        let emptyBucket = self.storyboard?.instantiateViewController(withIdentifier: "emptyPages") as! EmptyPagesViewController
                        emptyBucket.whichView = "CountriesVisited"
                        self.navigationController?.pushViewController(emptyBucket, animated: false)
                        
                    }
                    else {
                        self.updateNavigationBar()
                    }
                    self.tableView.reloadData()
                    
                }
                else {
                    
                    print("response error: \(response["data"])")
                    
                }
            })
            
        })
        
        
        //        }
        
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        if whichView == "BucketList" {
            
            return 1
            
        }
            
        else if whichView == "CountriesVisited" {
            
            return self.result.count
            
        }
        
        
        return 1
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if whichView == "BucketList" {
            
            return self.bucket.count
            
        }
            
        else if whichView == "CountriesVisited" {
            
            //            let countries =
            return self.result[section]["countries"].array!.count
            
        }
        
        
        return 0
        
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if whichView == "BucketList" {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! BucketListTableViewCell
            cell.countryName.layer.zPosition = 100
            cell.yearOfVisit.layer.zPosition = 100
            cell.countryId =  bucket[(indexPath as NSIndexPath).row]["_id"].string!
            cell.countryName.text = bucket[(indexPath as NSIndexPath).row]["name"].string!
            cell.countryPicture.hnk_setImageFromURL(getImageURL(bucket[indexPath.row]["countryCoverPhoto"].stringValue,width: BIG_PHOTO_WIDTH))
            cell.countryPicture.alpha = 1
            cell.yearOfVisit.isHidden = true
            return cell
        }
            
        else if whichView == "CountriesVisited" {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! BucketListTableViewCell
            cell.countryName.layer.zPosition = 100
            cell.yearOfVisit.layer.zPosition = 100
            cell.countryName.text = self.result[(indexPath as NSIndexPath).section]["countries"][(indexPath as NSIndexPath).row]["countryId"]["name"].string!
            cell.countryId =  self.result[(indexPath as NSIndexPath).section]["countries"][(indexPath as NSIndexPath).row]["countryId"]["_id"].string!
            if self.result[indexPath.section]["year"].stringValue == "-1" {
                cell.yearOfVisit.text = "-"
            }else{
            cell.yearOfVisit.text = "\(self.result[(indexPath as NSIndexPath).section]["countries"][(indexPath as NSIndexPath).row]["year"])"
            }
            cell.countryPicture.hnk_setImageFromURL(getImageURL(self.result[indexPath.section]["countries"][indexPath.row]["countryId"]["countryCoverPhoto"].stringValue,width: BIG_PHOTO_WIDTH))
            cell.countryPicture.alpha = 1

            return cell
        }
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! BucketListTableViewCell
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! BucketListTableViewCell
        self.view.bringSubview(toFront: cell.tintView)
        self.view.sendSubview(toBack: cell.countryPicture)
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if otherUser == "search" {
            return false
        }else{
            return true
        }
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let cell = tableView.cellForRow(at: indexPath) as! BucketListTableViewCell
        print(self.whichView);
        let delete = UITableViewRowAction(style: .destructive , title: "Delete") { (action, indexPath) in
            if self.whichView == "BucketList" {
                let alert = UIAlertController(title: "", message: "Are you sure you want to delete \(cell.countryName.text!) from BucketList?", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.default, handler: nil))
                alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.destructive, handler: { action in
                    request.removeBucketList(cell.countryId,completion: { (response) in
                        if(response["value"].boolValue) {
                            self.getBucketList();
                        } else {
                            let tstr = Toast(text: "Error Deleting the \(cell.countryName.text!) from Bucketlist")
                            tstr.show()
                        }
                    });
                }))

                self.present(alert, animated: true, completion: nil)
            } else if self.whichView == "CountriesVisited" {
                let alert = UIAlertController(title: "", message: "Are you sure you want to delete \(cell.countryName.text!) from Countries Visited?", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.default, handler: nil))
                alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.destructive, handler: { action in
                    request.removeCountriesVisited(cell.countryId,year:Int(cell.yearOfVisit.text!)!,completion: { (response) in
                        if(response["value"].boolValue) {
                            self.getCountriesVisited();
                        } else {
                            let tstr = Toast(text: "Error Deleting the \(cell.countryName.text!) from Countries Visited")
                            tstr.show()
                        }
                    });
                }))

                self.present(alert, animated: true, completion: nil)
            }
        }
        delete.backgroundColor = UIColor(hex: "#ff6759")
        
        return [delete]
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if whichView == "BucketList" {
            
            return 0
        }
        
        return 35
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        if whichView == "CountriesVisited" {
            if self.result[section]["year"].stringValue == "-1" {
                return "-"
            }else{
            return "\(self.result[section]["year"])"
            }
        }
        
        return nil
    }
    
    func addCountriesVisited(_ sender: UIButton) {
        
        if whichView == "BucketList" {
            
            let nextVC = storyboard?.instantiateViewController(withIdentifier: "SelectCountryVC") as! SelectCountryViewController
            nextVC.whichView = "BucketList"
            print("bucket list \(bucket)")
            nextVC.alreadySelected = bucket
            self.navigationController?.pushViewController(nextVC, animated: true)
        }
        else {
           
            let nextVC = storyboard?.instantiateViewController(withIdentifier: "SelectCountryVC") as! SelectCountryViewController
            nextVC.whichView = "CountriesVisited"
            self.navigationController?.pushViewController(nextVC, animated: true)
        }
        
    }
    
}

class BucketListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var countryPicture: UIImageView!
    @IBOutlet weak var countryName: UILabel!
    @IBOutlet weak var yearOfVisit: UILabel!
    @IBOutlet weak var tintView: UIView!
    var countryId:String = ""
    
}

class NoViewTableViewCell: UITableViewCell {
    
    
    
}
