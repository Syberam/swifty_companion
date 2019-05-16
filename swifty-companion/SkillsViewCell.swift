//
//  SkillsViewCell.swift
//  swifty-companion
//
//  Created by Sylvain BONNEFON on 5/16/19.
//  Copyright © 2019 sbonnefo. All rights reserved.
//


import UIKit

class SkillsTableViewCell: UITableViewCell {
    
    
    
    
    var skill : Skills? {
        didSet {
            if let sk = skill{
                //projectNameLbl.text = proj.project!.name!
                //projectMarkLbl.text = "\(proj.final_mark!)"
            }
        }
    }
}

