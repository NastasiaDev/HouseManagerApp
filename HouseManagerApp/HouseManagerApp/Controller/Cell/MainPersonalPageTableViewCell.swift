//
//  MainPersonalPageTableViewCell.swift
//  HouseManagerApp
//
//  Created by Anastasia Larina on 06.02.2025.
//

import UIKit

final class MainPersonalPageTableViewCell: UITableViewCell {
    
    // MARK: - Outlets
    
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var icon: UIImageView!

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
