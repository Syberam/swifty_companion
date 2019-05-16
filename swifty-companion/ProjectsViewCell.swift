//
//  ProjectsViewCell.swift
//  swifty-companion
//
//  Created by Sylvain BONNEFON on 5/16/19.
//  Copyright © 2019 sbonnefo. All rights reserved.
//

import UIKit

class ProjectTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    var victime : UserInfo? {
        didSet {
            if let vic = victime{
//                nameLabel?.text = vic.name
//                descriptionLabel?.text = vic.desc
//
//                let formatter = DateFormatter()
//                // initially set the format based on your datepicker date / server String
//                formatter.dateFormat = "dd-MM-yyyy"
//
//                let deathDate = formatter.string(from: vic.date)
//                dateLabel?.text = deathDate
            }
        }
    }
}

