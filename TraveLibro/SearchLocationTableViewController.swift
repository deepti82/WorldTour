import UIKit

import CoreLocation

class SearchLocationTableViewController: UITableViewController, UISearchBarDelegate, UISearchResultsUpdating, UIPickerViewDelegate, CLLocationManagerDelegate {
    
    var places: [JSON] = []
    var searchController: UISearchController!
    var shouldShowSearchResults = false
    var location: CLLocationCoordinate2D!
    var searchString = "Loha"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.tableFooterView = UIView()
        configureSearchController()
        searchController.searchBar.placeholder = "Search Places"
//        self.navigationItem.backBarButtonItem!.title = ""
        
    }
    
    func getSearchText() {
        
        print("in the search text \(searchString.characters.count)")
        
//        if searchString.characters.count > 2 {
        
            request.getGoogleSearchNearby(location.latitude, long: location.longitude, searchText: searchString, completion: {(response) in
                
                if response.error != nil {
                    
                    print("error: \(response.error?.localizedDescription)")
                    
                }
                else if response["value"].bool! {
                    
                    self.filteredArray = response["data"].array!
                    self.tableView.reloadData()
                    
                }
                else {
                    
                    print("response error")
                }
                
            })
            
//        }
        
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
        print("\(shouldShowSearchResults)")
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
        
//        filteredArray = places.filter({(country) -> Bool in
//            
//            let text: NSString = country["name"].string!
//            return (text.rangeOfString(searchString, options: .CaseInsensitiveSearch).location) != NSNotFound
//            
//        })
        
//        print("filtered array: \(filteredArray)")
        
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }

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
        
        let myCell = tableView.cellForRow(at: indexPath) as! searchLocationsTableViewCell
        var previous: NewTLViewController!
        
        for vc in self.navigationController!.viewControllers {
            
            if vc.isKind(of: NewTLViewController.self) {
                
                previous = vc as! NewTLViewController
                
            }
            
        }
        
        var myId = ""
        
        if shouldShowSearchResults {
            
            searchController.searchBar.resignFirstResponder()
            searchController.isActive = false
            
            for place in filteredArray {
                
                if myCell.placeName.text! == place["terms"].string! {
                    
                    myId = place["place_id"].string!
                    
                }
                
                
            }
            
            
        }
        
        else {
            
            for place in places {
                
                if myCell.placeName.text! == place["name"].string! {
                    
                    myId = place["place_id"].string!
                    
                }
                
            }
            
        }
        
        previous.putLocationName(myCell.placeName.text!, placeId: myId)
        self.navigationController?.popToViewController(previous, animated: true)
        
    }

}

class searchLocationsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var placeName: UILabel!
    @IBOutlet weak var vicinityLabel: UILabel!
    
}
