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
        self.nameLabel.textColor = .black
        self.descriptionLabel.textColor = .gray
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        self.nameLabel.text = nil
        self.descriptionLabel.text = nil
        self.icon.image = nil
    }

}
