import UIKit

import CoreLocation

class SearchLocationTableViewController: UITableViewController, UISearchBarDelegate, UISearchResultsUpdating, UIPickerViewDelegate, CLLocationManagerDelegate {
    
    var places: [JSON] = []
    var searchController: UISearchController!
    var shouldShowSearchResults = false
    var location: CLLocationCoordinate2D!
    var searchString = "Loha"
    private var requestId = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTopNavigation("Add Activity")
        tableView.tableFooterView = UIView()
        configureSearchController()
        searchController.searchBar.placeholder = "Search Places"
//        self.navigationItem.backBarButtonItem!.title = ""
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setAnalytics(name: "Search Location")
        UIApplication.shared.statusBarView?.backgroundColor = NAVIGATION_BAR_CLEAR_COLOR
        self.navigationController?.navigationBar.isTranslucent = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.statusBarView?.backgroundColor = NAVIGATION_BAR_COLOR
        self.navigationController?.navigationBar.isTranslucent = false
    }
    
    func getSearchText() {
        
        print("in the search text \(searchString.characters.count)")

        self.requestId += 1
        
        DispatchQueue.global().async {
            
            request.getGoogleSearchNearby(self.location.latitude, long: self.location.longitude, searchText: self.searchString, requestId: self.requestId, completion: {(response, responseId) in
                
                if self.requestId == responseId {
                    
                    DispatchQueue.main.async(execute: {
                        
                        if response.error != nil {                            
                            print("error: \(String(describing: response.error?.localizedDescription))")
                        }
                        else if response["value"].bool! {
                            self.filteredArray = response["data"].array!
                            self.tableView.reloadData()
                        }
                        else {
                            print("response error")
                        }
                    })
                }
            })
        }
    }
    
    func setTopNavigation(_ text: String) {
        let leftButton = UIButton()
        leftButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        leftButton.setImage(UIImage(named: "arrow_prev"), for: UIControlState())
        leftButton.addTarget(self, action: #selector(self.goBack(_:)), for: .touchUpInside)
        let rightButton = UIView()
        self.title = text
        self.customNavigationBar(left: leftButton, right: rightButton)
    }
    
    
    func goBack(_ sender:AnyObject) {
        self.navigationController!.popViewController(animated: true)
    }

    
    func configureSearchController() {
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = true
        searchController.searchBar.delegate = self
        searchController.searchBar.sizeToFit()
        tableView.tableHeaderView = searchController.searchBar
        
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        
        print("search begin editing")
        searchController.dimsBackgroundDuringPresentation = true
        shouldShowSearchResults = true
//        tableView.reloadData()
        
    }
    
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        print("search cancelled")
        shouldShowSearchResults = false
        tableView.reloadData()
        
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        print("search button clicked")
        
        if !shouldShowSearchResults {
            
            shouldShowSearchResults = true
            tableView.reloadData()
            
        }
        
        searchController.dimsBackgroundDuringPresentation = true
        searchController.searchBar.resignFirstResponder()
    }
    
    var filteredArray: [JSON] = []
    
    func updateSearchResults(for searchController: UISearchController) {
        
        searchController.dimsBackgroundDuringPresentation = false
        searchString = searchController.searchBar.text!
        
        getSearchText()
        
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    
    //MARK: - TableView Datasource & Delegates

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if shouldShowSearchResults {            
            return filteredArray.count
        }
        
        return places.count
        
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! searchLocationsTableViewCell
        
        if shouldShowSearchResults {            
            cell.placeName.text = filteredArray[(indexPath as NSIndexPath).row]["terms"].string!
            cell.vicinityLabel.text = filteredArray[(indexPath as NSIndexPath).row]["description"].string!
            return cell
        }
        
        cell.placeName.text = places[(indexPath as NSIndexPath).row]["name"].string!
        cell.vicinityLabel.text = places[(indexPath as NSIndexPath).row]["vicinity"].string!
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        var myId = ""
        var locName = ""
        
        if shouldShowSearchResults {
            
            searchController.searchBar.resignFirstResponder()
            searchController.isActive = false
            
            myId = filteredArray[indexPath.row]["place_id"].stringValue
            locName = filteredArray[indexPath.row]["terms"].stringValue 
        }
        
        else {
            myId = places[indexPath.row]["place_id"].stringValue
            locName = places[indexPath.row]["name"].stringValue
        }
        
        globalAddActivityNew.putLocationName(locName, placeId: myId)
        _ = self.navigationController?.popViewController(animated: true)
    }

}

class searchLocationsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var placeName: UILabel!
    @IBOutlet weak var vicinityLabel: UILabel!
    
}
