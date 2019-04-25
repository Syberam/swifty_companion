//
//  ViewController.swift
//  swifty-companion
//
//  Created by Sylvain BONNEFON on 4/11/19.
//  Copyright © 2019 sbonnefo. All rights reserved.
//

import UIKit



var UID = "06c6f280c902a775caadda88750175568eea0d88acac67132c34468b59bf7450"
var SECRET = "4dbaa9ac55c03b61c455c612091a46725079d844e1c6279d93dfa6876a83f4d6"
//let STATE = "Yolo"
let APIBASE = "https://api.intra.42.fr/v2"
let authURL = "https://api.intra.42.fr/oauth/token"
let grantType = "client_credentials"
let redirectURI = "https://www.42.fr"
let signInURL = "https://signin.intra.42.fr"
let signOutURL = "https://signin.intra.42.fr/users/sign_out"
var TOKEN:TokenAPI = TokenAPI(access_token:"", created_at:Int(Date().timeIntervalSince1970), expires_in:0)
var USERID = ""


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
        let error : String = "⚠️ \"" + searchField.text! + "\" does not exist ⚠️"
        wrongValueLabel.text = error
        manageError(error)
    }
    
    func clearWrongValueLabel()
    {
        wrongValueLabel.text = ""
    }
    
    func getUserInfo(toFind: String) -> Int64
    {
       if (TOKEN.created_at + TOKEN.expires_in <= Int(Date().timeIntervalSince1970)){
            exchangeCodeForToken()
       }
    else{
        print(Date(timeIntervalSince1970: Double(TOKEN.created_at)))
    }
        if (toFind.uppercased() == "COUCOU"){
            return 1
        } else {
            return -1
        }
    }
    
    func exchangeCodeForToken() {
        var components = URLComponents()
        
// curl -X POST --data "grant_type=client_credentials&client_id=06c6f280c902a775caadda88750175568eea0d88acac67132c34468b59bf7450&client_secret=4dbaa9ac55c03b61c455c612091a46725079d844e1c6279d93dfa6876a83f4d6" https://api.intra.42.fr/oauth/token
        
        
        components.scheme = "https";
        components.host = "api.intra.42.fr";
        components.path = "/oauth/token"
        components.queryItems = [
            URLQueryItem(name: "grant_type", value: grantType),
            URLQueryItem(name: "client_id", value: UID),
            URLQueryItem(name: "client_secret", value: SECRET),
            //URLQueryItem(name: "code", value: code),
            URLQueryItem(name: "redirect_uri", value: redirectURI),
            //URLQueryItem(name: "state", value: STATE),
        ]
        
        
        print(components)
        var request = URLRequest(url: components.url!)
        request.httpMethod = "POST"
        
        let getData = URLSession.shared.dataTask(with: request){
            (data, response, error) in
            if let err = error {
                print(err)
            }
            else if let d = data {
                do {
                    let jsonDecoder = JSONDecoder()
                    let TOKEN = try jsonDecoder.decode(TokenAPI.self, from: d)
                    if (TOKEN.access_token == nil){
                        self.manageError("Login failed")
                        return
                    }
                    print(TOKEN)
                }
                catch (let err) {
                    print(err)
                }
            }
        }
        getData.resume()
    }
    
    
    func manageError(_ error: String) {
        
        let alert = UIAlertController(title: "Error", message: "\(error)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Close", style: .cancel, handler: nil))
        DispatchQueue.main.async {
            self.present(alert, animated: true)
        }
    }
//curl  -H "Authorization: Bearer be1107c5edc05f4a851433f72b9a7974cbea4823bdf99da424758b92bf6f1933" "https://api.intra.42.fr/v2/users/sbonnefo"
}

