//
//  MainSearchViewController.swift
//  TraveLibro
//
//  Created by Jagruti  on 15/03/17.
//  Copyright © 2017 Wohlig Technology. All rights reserved.
//

import UIKit
var globalMainSearchViewController: MainSearchViewController!

class MainSearchViewController: UIViewController, UITextFieldDelegate {
    
    var search: SearchFieldView!
    @IBOutlet var SearchView: UIView!
    @IBOutlet weak var searchSlider: UIView!
    @IBOutlet weak var searchTable: UIView!
    var whichView: String = "slider"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        globalMainSearchViewController = self
        changeView(switchView: "slider")
        loader.showOverlay(self.view)
        
        search = SearchFieldView(frame: CGRect(x: 10, y: 8, width: self.view.frame.width - 20 , height: 30))
        search.searchField.returnKeyType = .done
        search.searchField.delegate = self
        search.searchField.addTarget(self, action: #selector(self.onChange), for: .editingChanged)
        
        SearchView.addSubview(search)
        
        transparentCardWhite(SearchView)
        search.searchField.attributedPlaceholder = NSAttributedString(string:  "Search", attributes: [NSForegroundColorAttributeName: mainBlueColor])
        search.backgroundColor = UIColor.clear
        search.leftLine.backgroundColor = mainOrangeColor
        search.rightLine.backgroundColor = mainOrangeColor
        search.bottomLine.backgroundColor = mainOrangeColor
        search.searchButton.tintColor = mainOrangeColor
        getDarkBackGround(self)
        let tapout = UITapGestureRecognizer(target: self, action: #selector(self.searchTable(_:)))
        search.SearchView.addGestureRecognizer(tapout)
        
        
        
        setTopNavigation("Search")

        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func onChange() {
        print(search.searchField.text!)
        if search.searchField.text! == "" {
            self.changeView(switchView: "slider")
        }else{
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {

            self.changeView(switchView: "table")
            }
        }
    }
    func closeLoader() {
        loader.hideOverlayView()
    }
    
    func searchTable(_ sender: UITapGestureRecognizer) {
        changeView(switchView: "table")
    }
    
    func setTopNavigation(_ text: String) {
        let leftButton = UIButton()
        leftButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        leftButton.setImage(UIImage(named: "arrow_prev"), for: UIControlState())
        leftButton.addTarget(self, action: #selector(self.goBack(_:)), for: .touchUpInside)
        let rightButton = UIView()
        self.title = text
        self.navigationController?.navigationBar.titleTextAttributes = [ NSFontAttributeName: UIFont(name: "Avenir-Medium", size: 18)!]
        
        self.customNavigationBar(left: leftButton, right: rightButton)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        search.searchField.resignFirstResponder()
        return true
        
    }
    
    func goBack(_ sender:AnyObject) {
        print(whichView)
        if whichView == "slider" {
            self.navigationController!.popViewController(animated: true)
        }else{
            changeView(switchView: "slider")
        }
    }
    
    func changeView(switchView: String) {
        print(globalSearchTableViewController.selectedStatus)
        whichView = switchView
        if switchView == "slider" {
            self.searchSlider.isHidden = false
            self.searchTable.isHidden = true
        }else{
            self.searchSlider.isHidden = true
            self.searchTable.isHidden = false
            globalSearchTableViewController.page = 1
            if globalSearchTableViewController.selectedStatus == "hashtags" {
                globalSearchTableViewController.searchHashtags(search: search.searchField.text!)
            }else{
                globalSearchTableViewController.searchPeople(search: search.searchField.text!)
            }
        }
    }
    
}
