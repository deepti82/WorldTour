//
//  SuggestionsViewController.swift
//  TraveLibro
//
//  Created by Wohlig Technology on 11/23/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit

class SuggestionsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var suggestions: [JSON] = []
    var whichSuggestion = "hashtag"
    var textVar = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return suggestions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! SuggestionsTableViewCell
        return cell
        
    }
    
    func getSuggestions() {
        
        if whichSuggestion == "hashtag" {
            getHashtags()
        }
        else if whichSuggestion == "mentions" {
            getMentions()
        }
    }
    
    func getHashtags() {
        
        request.getHashtags(hashtag: textVar, completion: {(response) in
            
            DispatchQueue.main.async(execute: {
                
                if response.error != nil {
                    
                    print("error: \(response.error!.localizedDescription)")
                    
                }
                else if response["value"].bool! {
                    
//                    self.comments = response["data"]["comment"].array!
//                    self.commentsTable.reloadData()
                    
                }
                else {
                    
                    
                }
                
            })
            
        })
        
    }
    
    func getMentions() {
        
        request.getMentions(userId: currentUser["_id"].string!, searchText: textVar, completion: {(response) in
            
            DispatchQueue.main.async(execute: {
                
                if response.error != nil {
                    
                    print("error: \(response.error!.localizedDescription)")
                    
                }
                else if response["value"].bool! {
                    
                    //                    self.comments = response["data"]["comment"].array!
                    //                    self.commentsTable.reloadData()
                    
                }
                else {
                    
                    
                }
                
            })
            
        })
    }
    
}

class SuggestionsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var statistics: UILabel!
    
}
