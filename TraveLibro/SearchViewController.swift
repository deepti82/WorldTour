//
//  SearchViewController.swift
//  TraveLibro
//
//  Created by Pranay Joshi on 14/02/17.
//  Copyright © 2017 Wohlig Technology. All rights reserved.
//

import UIKit
var globalSearchViewController: SearchViewController!
class SearchViewController: UIViewController, UITextFieldDelegate {
    
    var search: SearchFieldView!
    var loader = LoadingOverlay()
    @IBOutlet weak var scrollView: UIScrollView!
    override func viewDidLoad() {
        super.viewDidLoad()
        globalSearchViewController = self
        self.automaticallyAdjustsScrollViewInsets = false
        print("in search view controller")
        getDarkBackGround(self)
//        loader.showOverlay(self.view)
        scrollView.isScrollEnabled = true
        
        scrollView.autoresizingMask = UIViewAutoresizing.flexibleWidth
        scrollView.autoresizingMask = UIViewAutoresizing.flexibleHeight
        
        let searchView = Search(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 675))
        searchView.parentController = self
        scrollView.contentSize = CGSize(width: 0, height: 800)
        searchView.setData()
        self.scrollView.addSubview(searchView)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        let searchTable = storyboard?.instantiateViewController(withIdentifier: "searchTable") as! SearchTableViewController
        searchTable.newSearch = textField.text!
        searchTable.searchPeople(search: textField.text!)
        globalNavigationController.pushViewController(searchTable, animated: true)
        return true
        
    }
    
    func closeLoader() {
        loader.hideOverlayView()
    }
    
    }
