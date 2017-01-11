//
//  QuickPhotosCollectionViewController.swift
//  TraveLibro
//
//  Created by Jagruti  on 11/01/17.
//  Copyright © 2017 Wohlig Technology. All rights reserved.
//

import UIKit


class QuickPhotosCollectionViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var downButton: UIButton!
    @IBOutlet weak var quickCollectionView: UICollectionView!
    @IBOutlet weak var noOfPhotos: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        quickCollectionView.delegate = self
        quickCollectionView.dataSource = self
        downButton.titleLabel?.font = UIFont(name: "FontAwesome", size: 14)
        let arrow = String(format: "%C", faicon["arrow-down"]!)
        downButton.setTitle(arrow, for: UIControlState())
        noOfPhotos.text = "Photo(\(globalPostImage.count))"
        let statusBar = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 20))
        statusBar.layer.zPosition = -1
        statusBar.backgroundColor = UIColor(red: 35/255, green: 45/255, blue: 74/255, alpha: 1)
        self.view.addSubview(statusBar)
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func downClicked(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return globalPostImage.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "QCell", for: indexPath) as! quickCell
        cell.qPhoto.image = globalPostImage[indexPath.row].image
    
        return cell
    }

}

class quickCell: UICollectionViewCell {
    @IBOutlet weak var qPhoto: UIImageView!
    
}
