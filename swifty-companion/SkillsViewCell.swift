//
//  SkillsViewCell.swift
//  swifty-companion
//
//  Created by Sylvain BONNEFON on 5/16/19.
//  Copyright © 2019 sbonnefo. All rights reserved.
//


import UIKit

class SkillsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var skillNameLbl: UILabel!
    @IBOutlet weak var skillLvlBar: UIProgressView!
    @IBOutlet weak var lvlLbl: UILabel!
    
    
    
    var skill : Skills? {
        didSet {
            self.backgroundColor = UIColor(red:0.54,green:0.6,blue:0.4,alpha:0.5)
            if let sk = skill{
                skillNameLbl.text = sk.name
                lvlLbl.text = String(sk.level!)
                skillLvlBar.setProgress(sk.level! / 30, animated: true)
            }
        }
    }
}

