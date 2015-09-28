//
//  BrowseMoreCell.swift
//  Yelp
//
//  Created by Soumya on 9/27/15.
//  Copyright © 2015 Soumya. All rights reserved.
//

import UIKit

@objc protocol BrowseMoreCellDelegate {
    optional func browseMoreCellIsTapped(browseMoreCell : BrowseMoreCell)
}

class BrowseMoreCell: UITableViewCell {
    weak var delegate : BrowseMoreCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func onBrowseMoreCellTap(sender: AnyObject) {
        delegate?.browseMoreCellIsTapped!(self)        
    }

}
