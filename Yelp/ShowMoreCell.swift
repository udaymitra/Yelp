//
//  ShowMoreTableViewCell.swift
//  Yelp
//
//  Created by Soumya on 9/27/15.
//  Copyright © 2015 Timothy Lee. All rights reserved.
//

import UIKit

@objc protocol ShowMoreCellDelegate {
    optional func showMoreCellIsTapped(showMoreCell : ShowMoreCell)
}

class ShowMoreCell: UITableViewCell {
    weak var delegate: ShowMoreCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func onShowMoreButtonTap(sender: AnyObject) {
        delegate?.showMoreCellIsTapped!(self)
    }
}
