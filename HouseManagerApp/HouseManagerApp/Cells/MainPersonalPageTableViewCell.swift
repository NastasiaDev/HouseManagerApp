//
//  MainPersonalPageTableViewCell.swift
//  HouseManagerApp
//
//  Created by Anastasia Larina on 06.02.2025.
//

import UIKit

final class MainPersonalPageTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var icon: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        nameLabel.textColor = .black
        descriptionLabel.textColor = .gray
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        nameLabel.text = nil
        descriptionLabel.text = nil
        icon.image = nil
    }

}
