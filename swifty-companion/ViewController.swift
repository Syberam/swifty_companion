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
let GRANT_TYPE = "client_credentials"
let APIBASE = "https://api.intra.42.fr/v2"
let REDIRECT_URI = "https://www.42.fr"

var TOKEN: TokenAPI?{
    didSet{
        if (TOKEN != nil){
            print("\n\nTOKEN :\n")
            print(TOKEN!)
        }
    }
}


class ViewController: UIViewController, UISearchBarDelegate {

    @IBOutlet weak var searchField: UISearchBar!
    var currentUser: UserInfo? = UserInfo() {
        didSet{
            if (currentUser != nil && currentUser!.login != nil){
                print(currentUser!)
                self.performSegue(withIdentifier: "profileSegue", sender: currentUser)
            }
            else{
                print("currentUser clear")
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        if ( TOKEN == nil || TOKEN!.expire_date == nil || TOKEN!.expire_date! <= Date()) {
            self.exchangeCodeForToken()
        }
        print("_____________________\n\nY O L O\n\n------------------------\n\n")
        if (currentUser != nil){
            currentUser = nil
        }
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar){
        self.makeSearch(toFind: self.searchField.text!)
    }
    
    func makeSearch(toFind: String){
        DispatchQueue.main.async{
            self.getUserInfo(currentUser: toFind.lowercased())
        }
    }
    

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "profileSegue"{
            let vc = segue.destination as! ProfileViewController
            vc.currentUser = self.currentUser!
            //Data has to be a variable name in your RandomViewController
        }
    }

    
    func exchangeCodeForToken() {
        var components = URLComponents()
        
        components.scheme = "https";
        components.host = "api.intra.42.fr";
        components.path = "/oauth/TOKEN"
        components.queryItems = [
            URLQueryItem(name: "grant_type", value: GRANT_TYPE),
            URLQueryItem(name: "client_id", value: UID),
            URLQueryItem(name: "client_secret", value: SECRET),
            URLQueryItem(name: "redirect_uri", value: REDIRECT_URI),
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
                    print(d)
                    let jsonDecoder = JSONDecoder()
                    TOKEN = try jsonDecoder.decode(TokenAPI.self, from: d)
                    if (TOKEN == nil || TOKEN!.access_token == nil){
                        print("WHY")
                        DispatchQueue.main.async {
                            self.manageError("API 42 indisponible")
                            return
                        }
                    }
                    else {
                        print("WHAAAAAAAT")
                        TOKEN!.expire_date = Date() + TimeInterval(2 * 60 * 60) + TimeInterval(TOKEN!.expires_in!)
                    }
                }
                catch (let err) {
                    print(err)
                }
            }
        }
        getData.resume()
        
    }
    
    func getUserInfo(currentUser: String){
        while(TOKEN == nil || TOKEN!.access_token == nil){}
        print("\n\nYEAHAHAHAHAH\n\n")
        var components = URLComponents()
        
        components.scheme = "https";
        components.host = "api.intra.42.fr";
        components.path = "/v2/users/" + currentUser
    
        var request = URLRequest(url: components.url!)
        request.setValue("Bearer " + TOKEN!.access_token!, forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
        
        let getData = URLSession.shared.dataTask(with: request){
            (data, response, error) in
            if let httpResponse = response as? HTTPURLResponse {
                if (httpResponse.statusCode != 200){
                    DispatchQueue.main.async{
                        print("error : \(httpResponse.statusCode)")
                        self.currentUser = nil
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
                    self.currentUser = try jsonDecoder.decode(UserInfo.self, from: d)
                    if ( self.currentUser == nil || self.currentUser!.id == nil){
                        DispatchQueue.main.async{
                            self.manageError("User does not exist")
                            self.currentUser = nil
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
        self.present(alert, animated: true)
    }
    
    func wrongValueMessage(){
        let error : String = "⚠️ \"" + searchField.text! + "\" does not exist ⚠️"
        manageError(error)
    }
}

