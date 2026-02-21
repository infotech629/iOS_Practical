//
//  NoDataFoundTableViewCell.swift
//  iOS_Practical
//
//  Created by Ashish Gajera on 21/02/26.
//

import UIKit

class NoDataFoundTableViewCell: UITableViewCell {
    //MARK: - Outlet
    
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    //MARK: - Variables
    static let identifier = "NoDataFoundTableViewCell"
    
    
    //MARK: - Life cycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
