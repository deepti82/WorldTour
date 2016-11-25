//
//  MentionSuggestionsViewController.swift
//  TraveLibro
//
//  Created by Midhet Sulemani on 24/11/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit

class MentionSuggestionsViewController: UIViewController {
    
    var suggestions: [JSON] = []
    var textVar = ""
    
    @IBOutlet weak var suggestionsTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        getMentions()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        getMentions()
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
    
    
}

