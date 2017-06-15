//
//  SuggestionsViewController.swift
//  TraveLibro
//
//  Created by Wohlig Technology on 11/23/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit

class SuggestionsViewController: UIViewController {
    
    var suggestions: [JSON] = []
    var whichSuggestion = "hashtag"
    var textVar = ""
    private var requestId = 0
    
    @IBOutlet weak var suggestionsTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getSuggestions()
//        suggestionsTable.footer View = UIView()
    }
    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        
//        return suggestions.count
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        
//        
//        
//    }
    
    func getSuggestions() {
        
        if whichSuggestion == "hashtag" {
            print("get hashtag")
//            getHashtags()
        }
        else if whichSuggestion == "mentions" {
            print("get mentions")
            getMentions()
        }
    }
    

    
    func getMentions() {
        
        requestId += 1
        
        request.getMentions(userId: user.getExistingUser(), searchText: textVar, requestId: self.requestId, completion: {(response, responseId) in
            
            DispatchQueue.main.async(execute: {
                
                if (self.requestId == responseId) {
                    if response.error != nil {                        
                        print("error: \(response.error!.localizedDescription)")                        
                    }
                    else if response["value"].bool! {                        
                        //                    self.comments = response["data"]["comment"].array!
                        self.suggestionsTable.reloadData()
                    }
                }
                
            })
            
        })
    }
    
}

