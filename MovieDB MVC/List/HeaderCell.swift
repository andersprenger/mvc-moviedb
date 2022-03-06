//
//  HeaderCell.swift
//  MovieDB MVC
//
//  Created by Anderson Sprenger on 05/03/22.
//

import UIKit

class HeaderCell: UITableViewCell {
    static var identifier: String = "HeaderCell"
    var title: String?

    @IBOutlet private weak var headerTitle: UILabel!
    
    func reload() {
        headerTitle.text = title
    }
}
