//
//  ProfileViewController.swift
//  swifty-companion
//
//  Created by Sylvain BONNEFON on 5/2/19.
//  Copyright © 2019 sbonnefo. All rights reserved.
//

import Foundation
import UIKit

class ProfileViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{

    @IBOutlet weak var studentLogin: UILabel!
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var levelLbl: UILabel!
    
    @IBOutlet weak var firstNameLbl: UILabel!
    @IBOutlet weak var lastNameLbl: UILabel!
    @IBOutlet weak var phoneLbl: UILabel!
    @IBOutlet weak var emailLbl: UILabel!
    
    var currentUser: UserInfo = UserInfo()
    
    

    @IBOutlet weak var projectsTableView: UITableView!{
        didSet {
            projectsTableView.delegate = self
            projectsTableView.dataSource = self
        }
    }
    
    @IBOutlet weak var skillsTableView: UITableView!{
        didSet {
            skillsTableView.delegate = self
            skillsTableView.dataSource = self
        }
    }
  
    

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setValue(elem: studentLogin,value: currentUser.login)
        setValue(elem: firstNameLbl, value: currentUser.first_name)
        setValue(elem: lastNameLbl, value: currentUser.last_name)
        setValue(elem: phoneLbl, value: currentUser.phone)
        setValue(elem: emailLbl, value: currentUser.email)
        var level: String
        self.currentUser.projects_users?.sort(){ $0.occurrence! < $1.occurrence! }
        self.currentUser.projects_users?.sort(){ $0.id! < $1.id! }
        //self.currentUser.projects_users?.sort(){ $0.cursus_ids![0] > $1.cursus_ids![0] }
        
        print(self.currentUser.projects_users!)
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
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var nbLines: Int
        if tableView == self.projectsTableView{
            nbLines = currentUser.projects_users!.count
        }
        else{
            nbLines = (currentUser.cursus_users![0].skills?.count)!
            //EXTEND TO OTHER CURSUSES !!!
        }
        
        return nbLines
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == self.projectsTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "projectCell") as! ProjectTableViewCell
            cell.project = currentUser.projects_users![indexPath.row]
            return cell
        } else if tableView == self.skillsTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "skillCell") as! SkillsTableViewCell
            cell.skill = currentUser.cursus_users![0].skills![indexPath.row]
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "skillCell") as! SkillsTableViewCell
            return cell
        }
    }
}




