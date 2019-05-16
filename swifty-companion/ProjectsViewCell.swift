//
//  ProjectsViewCell.swift
//  swifty-companion
//
//  Created by Sylvain BONNEFON on 5/16/19.
//  Copyright © 2019 sbonnefo. All rights reserved.
//

import UIKit

class ProjectTableViewCell: UITableViewCell {
    
    @IBOutlet weak var projectNameLbl: UILabel!
    @IBOutlet weak var projectMarkLbl: UILabel!
    
    var project : ProjectsUser? {
        didSet {
            projectMarkLbl.text = "Ø"
            projectMarkLbl.textColor = UIColor.black
            projectNameLbl.text = ""
            self.backgroundColor = UIColor.white
            if let proj = project{
                projectNameLbl.text = proj.project!.name
                if let mark = project?.marked{
                    if mark{
                        if let val = proj.validated{
                            if val{
                                projectMarkLbl.textColor = UIColor.green
                            }
                            else{
                                projectMarkLbl.textColor = UIColor.red
                            }
                        }
                        if let mark = proj.final_mark{
                            projectMarkLbl.text = "\(mark)"
                        }
                    }
                    else{
                        self.backgroundColor = UIColor.gray

                    }
                }
                
            }
        }
    }
}

