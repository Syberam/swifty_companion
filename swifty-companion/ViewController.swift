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
            print("\n\nTOKEN 42:\n")
            print(TOKEN!)
        }
    }
}

class ViewController: UIViewController, UISearchBarDelegate {

    @IBOutlet weak var searchField: UISearchBar!
    var user: UserInfo? {
        didSet{
            print("---\nUser didSet\n---")
            if (user != nil && user!.login != nil){
                print("BEFORE PERFORM SEGUE")
                self.performSegue(withIdentifier: "profileSegue", sender: self.user)
                print("AFTER PERFORM SEGUE")
            }
            else{
                print("-----\ncurrentUser clear\n-----")
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        if ( TOKEN == nil || TOKEN!.expire_date == nil || TOKEN!.expire_date! <= Date()) {
            self.exchangeCodeForToken()
        }
        print("_____________________\n\nY O L O\n\n------------------------\n\n")
        if (user != nil){
            user = nil
        }
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar){
        self.makeSearch(toFind: self.searchField.text!)
        //self.performSegue(withIdentifier: "profileSegue", sender: user)
    }
    
    func makeSearch(toFind: String){
        self.getUserInfo(currentUser: toFind.lowercased())
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("\n\nPREPARE SEGUE\n\n")
        if segue.identifier == "profileSegue"{
            print("\n\nPREPARE SEGUE\n\n")
            let vc = segue.destination as! ProfileViewController
            vc.currentUser = self.user!
        }
    }

    
    func exchangeCodeForToken() {
        var components = URLComponents()
        
        components.scheme = "https";
        components.host = "api.intra.42.fr";
        components.path = "/oauth/token"
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
            if let resp = response as? HTTPURLResponse {
                if (resp.statusCode != 200){
                    print(resp)
                }
            }
            if let d = data {
                do {
                    let jsonDecoder = JSONDecoder()
                    TOKEN = try jsonDecoder.decode(TokenAPI.self, from: d)
                    if (TOKEN == nil || TOKEN!.access_token == nil){
                        DispatchQueue.main.async {
                            self.manageError("API 42 indisponible")
                            return
                        }
                    }
                    else {
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
        print("\n\nUSER SEARCH\n\n")
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
                        self.user = nil
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
                    self.user = try jsonDecoder.decode(UserInfo.self, from: d)
                    if ( self.user == nil || self.user!.id == nil){
                        DispatchQueue.main.async{
                            self.manageError("User does not exist")
                            self.user = nil
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

