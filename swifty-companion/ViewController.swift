//
//  ViewController.swift
//  swifty-companion
//
//  Created by Sylvain BONNEFON on 4/11/19.
//  Copyright © 2019 sbonnefo. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UISearchBarDelegate {

    @IBOutlet weak var searchField: UISearchBar!
    @IBOutlet weak var wrongValueLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        clearWrongValueLabel()

        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //TODO autocompletion ??
    // - (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText delegate method.

   
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar)
    {
        let userInfo: Int64 = getUserInfo(toFind: searchField.text!)
        
        if (userInfo == -1){
            wrongValueMessage()
        } else {
            print(userInfo)
            clearWrongValueLabel()
        }
    }
    
    func wrongValueMessage(){
        wrongValueLabel.text = "⚠️ \"" + searchField.text! + "\" does not exist ⚠️"
    }
    
    func clearWrongValueLabel()
    {
        wrongValueLabel.text = ""
    }
    
    func getUserInfo(toFind: String) -> Int64
    {
        if (toFind.uppercased() == "COUCOU"){
            return 1
        } else {
            return -1
        }
    }
}

