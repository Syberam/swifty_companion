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


class ViewController: UIViewController, UISearchBarDelegate {

    @IBOutlet weak var searchField: UISearchBar!
    @IBOutlet weak var wrongValueLabel: UILabel!


    override func viewDidLoad() {
        super.viewDidLoad()
        clearWrongValueLabel()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //TODO autocompletion ??
    // - (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText delegate method.

   
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar)
    {
        let userInfo: Int64 = makeSearch(toFind: searchField.text!)
        
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
    
    func makeSearch(toFind: String) -> Int64
    {
        if (TOKEN.expire_date == nil || TOKEN.expire_date! <= Date()) {
           // DispatchQueue.main.async{
                self.exchangeCodeForToken()
           // }
        }
        print(TOKEN)
        DispatchQueue.main.async{
            self.getUserInfo(user: toFind.lowercased())
        }
    
        if (toFind.uppercased() == "COUCOU"){
            return 1
        } else {
            return -1
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
        
        print(request)
        
       
        let getData = URLSession.shared.dataTask(with: request){
            (data, response, error) in
            print("______DATA_______")
            print(data)
            print("______RESPONSE_______")
            if let httpResponse = response as? HTTPURLResponse {
                if (httpResponse.statusCode != 200){
                    print("error : \(httpResponse.statusCode)")
                    return
                }
            }
            print("______ERROR_______")
            print(error)
            if let err = error {
                print(err)
            }
            else if let d = data {
                do {
                    print("D A T A")
                    print(d)
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

