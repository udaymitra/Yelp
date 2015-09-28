//
//  FilterCell.swift
//  Yelp
//
//  Created by Soumya on 9/24/15.
//  Copyright © 2015 Soumya. All rights reserved.
//

import UIKit

@objc protocol SwitchCellDelegate {
    optional func switchCellIsTapped(switchCell: SwitchCell)
}

class SwitchCell: UITableViewCell {

    @IBOutlet weak var switchLabel: UILabel!
    @IBOutlet weak var switchImageView: UIImageView!
    
    
    weak var delegate : SwitchCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()

        switchImageView.image = UIImage(named: "Uncheck")
        switchImageView.userInteractionEnabled = true
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: Selector("switchValueChanged:"))
        switchImageView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    func switchValueChanged(gestureRecognizer: UITapGestureRecognizer) {
        delegate?.switchCellIsTapped!(self)
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
