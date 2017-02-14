//
//  SearchViewController.swift
//  TraveLibro
//
//  Created by Pranay Joshi on 14/02/17.
//  Copyright © 2017 Wohlig Technology. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {
    @IBOutlet var searchScroll: UIScrollView!
    var search: SearchFieldView!
    @IBOutlet var SearchView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        getDarkBackGround(self)
        search = SearchFieldView(frame: CGRect(x: 10, y: 8, width: SearchView.frame.width - 10 , height: 30))
        search.searchField.returnKeyType = .done
        SearchView.addSubview(search)
  
        transparentCardWhite(SearchView)
        search.searchField.attributedPlaceholder = NSAttributedString(string:  "Search", attributes: [NSForegroundColorAttributeName: mainBlueColor])
        search.leftLine.backgroundColor = mainOrangeColor
        search.rightLine.backgroundColor = mainOrangeColor
        search.bottomLine.backgroundColor = mainOrangeColor
        search.searchButton.tintColor = mainOrangeColor
        
        searchScroll.contentSize.height = self.view.frame.height
        searchScroll.contentSize.width = 0
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
