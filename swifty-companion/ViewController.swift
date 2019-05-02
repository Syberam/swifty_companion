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
var TOKEN:TokenAPI = TokenAPI()
var USERID = ""
var USER: UserInfo = UserInfo(){
    didSet{
        print(USER)
        PERFORM_SEG = true
    }
}
var PERFORM_SEG: Bool = false


class ViewController: UIViewController, UISearchBarDelegate {

    @IBOutlet weak var searchField: UISearchBar!


    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
 
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar)
    {
        self.makeSearch(toFind: self.searchField.text!)
    }
    
    func wrongValueMessage(){
        let error : String = "⚠️ \"" + searchField.text! + "\" does not exist ⚠️"
        manageError(error)
    }
    

    
    func makeSearch(toFind: String)
    {
        if (TOKEN.expire_date == nil || TOKEN.expire_date! <= Date()) {
                self.exchangeCodeForToken()
        }
        DispatchQueue.main.async{
            self.getUserInfo(user: toFind.lowercased())
            while(!PERFORM_SEG){}
            let ProfileController: ProfileViewController = ProfileViewController()
            self.navigationController?.pushViewController(ProfileController, animated: true)
        }
}
    
    func exchangeCodeForToken() {
        var components = URLComponents()
        
        components.scheme = "https";
        components.host = "api.intra.42.fr";
        components.path = "/oauth/token"
        components.queryItems = [
            URLQueryItem(name: "grant_type", value: grantType),
            URLQueryItem(name: "client_id", value: UID),
            URLQueryItem(name: "client_secret", value: SECRET),
            URLQueryItem(name: "redirect_uri", value: redirectURI),
        ]

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
                    TOKEN = try jsonDecoder.decode(TokenAPI.self, from: d)
                    if (TOKEN.access_token == nil){
                        self.manageError("Login failed")
                        return
                    }
                    else {
                        TOKEN.expire_date = Date() + TimeInterval(2 * 60 * 60) + TimeInterval(TOKEN.expires_in!)
                    }
                }
                catch (let err) {
                    print(err)
                }
            }
        }
        getData.resume()
        
    }
    
    
    func getUserInfo(user: String){
        while(TOKEN.access_token == nil){}
        var components = URLComponents()
        
        components.scheme = "https";
        components.host = "api.intra.42.fr";
        components.path = "/v2/users/" + user
    
        var request = URLRequest(url: components.url!)
        request.setValue("Bearer " + TOKEN.access_token!, forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
        
        let getData = URLSession.shared.dataTask(with: request){
            (data, response, error) in
            if let httpResponse = response as? HTTPURLResponse {
                if (httpResponse.statusCode != 200){
                    DispatchQueue.main.async{
                        print("error : \(httpResponse.statusCode)")
                        self.wrongValueMessage()
                    }
                }
            }
            if let err = error {
                print(err)
            }
            else if let d = data {
                do {
                    let jsonDecoder = JSONDecoder()
                    USER = try jsonDecoder.decode(UserInfo.self, from: d)
                    if (USER.id == nil){
                        DispatchQueue.main.async{
                            self.manageError("User does not exist")
                            self.wrongValueMessage()
                        }
                    }
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
}

