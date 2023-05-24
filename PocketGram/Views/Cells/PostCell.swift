//
//  PostCell.swift
//  PocketGram
//
//  Created by Nathan Ireland on 5/23/23.
//

import UIKit

class PostCell: UITableViewCell {

    @IBOutlet weak var usernamLabel: UILabel!
    @IBOutlet weak var captionLabel: UILabel!
    @IBOutlet weak var photoView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
