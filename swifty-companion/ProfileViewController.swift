//
//  ProfileViewController.swift
//  swifty-companion
//
//  Created by Sylvain BONNEFON on 5/2/19.
//  Copyright © 2019 sbonnefo. All rights reserved.
//

import Foundation
import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var studentLogin: UILabel!
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var levelLbl: UILabel!
    
    @IBOutlet weak var firstNameLbl: UILabel!
    @IBOutlet weak var lastNameLbl: UILabel!
    @IBOutlet weak var phoneLbl: UILabel!
    @IBOutlet weak var emailLbl: UILabel!
    
    var currentUser: UserInfo = UserInfo()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setValue(elem: studentLogin,value: currentUser.login)
        setValue(elem: firstNameLbl, value: currentUser.first_name)
        setValue(elem: lastNameLbl, value: currentUser.last_name)
        setValue(elem: phoneLbl, value: currentUser.phone)
        setValue(elem: emailLbl, value: currentUser.email)
        var level: String
        if (currentUser.cursus_users![0].level != nil ){
            level = String(describing: currentUser.cursus_users![0].level!)
        }
        else{level = "ø"}
        setValue(elem: levelLbl, value: "Level : \(level)")
        
        if let picUrl = currentUser.image_url{
            if let url = URL(string: picUrl), let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
                profileImg.image = image
            }
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    func setValue(elem: UILabel, value: String?){
        if (value != nil && value != "" && value != "null"){
            elem.text = value
        }
        else{
            elem.text = "__ø__"
        }
    }
}

