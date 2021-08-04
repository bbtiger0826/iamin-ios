//
//  AllMemberCell.swift
//  iamin
//
//  Created by 王靖渝 on 2021/8/4.
//

import UIKit

class AllMemberCell: UITableViewCell {

    @IBOutlet weak var lbID: UILabel!
    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var lbEmail: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
