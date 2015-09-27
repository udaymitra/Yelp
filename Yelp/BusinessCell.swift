//
//  BusinessCell.swift
//  Yelp
//
//  Created by Soumya on 9/23/15.
//  Copyright © 2015 Soumya. All rights reserved.
//

import UIKit

class BusinessCell: UITableViewCell {

    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var businessNameLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var reviewsLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var cuisinesLabel: UILabel!
    @IBOutlet weak var ratingImageView: UIImageView!
    @IBOutlet weak var dealsImageView: UIImageView!
    @IBOutlet weak var dealLabel: UILabel!
    @IBOutlet weak var dealLabelToBottomMarginConstraint: NSLayoutConstraint!
    
    var business : Business! {
        didSet {
            businessNameLabel.text = business.name
            distanceLabel.text = business.distance
            reviewsLabel.text = "\(business.reviewCount!) Reviews"
            addressLabel.text = business.address
            cuisinesLabel.text = business.categories
            thumbnailImageView.setImageWithURL(business.imageURL)
            ratingImageView.setImageWithURL(business.ratingImageURL)
//            thumbnailImageView.contentMode = UIViewContentMode.ScaleAspectFit
            
//            self.removeConstraint(dealLabelToBottomMarginConstraint)
            if(business.dealString != nil && !business.dealString!.isEmpty) {
                dealsImageView.hidden = false
                dealLabel.hidden = false
                dealLabel.text = business.dealString!
//                self.addConstraint(dealLabelToBottomMarginConstraint)
            } else {
                dealsImageView.hidden = true
                dealLabel.hidden = true
                dealLabelToBottomMarginConstraint.constant = 0
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        thumbnailImageView.layer.cornerRadius = 3
        thumbnailImageView.clipsToBounds = true
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}
