//
//  TLLoadingTableViewCell.swift
//  TraveLibro
//
//  Created by Wohlig Technology on 11/05/17.
//  Copyright © 2017 Wohlig Technology. All rights reserved.
//

import UIKit

class TLLoadingTableViewCell: UITableViewCell {

    var FLoadingIndicator: UIActivityIndicatorView?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    init(style: UITableViewCellStyle, reuseIdentifier: String, pageType: viewType?){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        createView(pageType: pageType)        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)        
        createView(pageType: nil)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.FLoadingIndicator?.stopAnimating()
    }
    
    
    //MARK: - Create View
    
    func createView(pageType: viewType?) {
        
        if FLoadingIndicator == nil {
            FLoadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 60, height: 60))
            FLoadingIndicator?.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.whiteLarge
            FLoadingIndicator?.color = mainOrangeColor
            FLoadingIndicator?.hidesWhenStopped = true            
            self.contentView.addSubview(FLoadingIndicator!)
        }
        else{
            print("\n\n Already animating bottom loading indicator \n\n")
        }
        
        setData(pageType: pageType)            
        
    }    
    
    func setData(pageType: viewType?) {
        if pageType == viewType.VIEW_TYPE_LOCAL_LIFE {
            FLoadingIndicator?.color = mainGreenColor
        }
        else {
            FLoadingIndicator?.color = mainOrangeColor
        }
        
        FLoadingIndicator?.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        FLoadingIndicator?.center = self.contentView.center
        FLoadingIndicator?.startAnimating()
    }
}
