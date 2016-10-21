//
//  BlogsListViewController.swift
//  TraveLibro
//
//  Created by Midhet Sulemani on 13/06/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit

class BlogsListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setNavigationBarItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 4
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "blogCell") as! PopularBlogTableviewCell
        cell.LikeFA.text = String(format: "%C", faicon["likes"]!)
        cell.calendarFA.text = String(format: "%C", faicon["calendar"]!)
        cell.clockFA.text = String(format: "%C", faicon["clock"]!)
        return cell
        
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let blogDescriptionVC = storyboard?.instantiateViewController(withIdentifier: "blogs") as! BlogViewViewController
        self.navigationController?.pushViewController(blogDescriptionVC, animated: true)
        
        
    }

}


class PopularBlogTableviewCell: UITableViewCell {
    
    @IBOutlet weak var LikeFA: UILabel!
    @IBOutlet weak var calendarFA: UILabel!
    @IBOutlet weak var clockFA: UILabel!
    
    
    
}
