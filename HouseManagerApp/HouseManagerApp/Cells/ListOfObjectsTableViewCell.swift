//
//  ListOfObjectsTableViewCell.swift
//  HouseManagerApp
//
//  Created by Anastasia Larina on 06.02.2025.
//

import UIKit

final class ListOfObjectsTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.nameLabel.textColor = .black
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        self.nameLabel.text = nil
    }
}
