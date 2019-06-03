//
//  ViewController.swift
//  swifty-companion
//
//  Created by Sylvain BONNEFON on 4/11/19.
//  Copyright © 2019 sbonnefo. All rights reserved.
//

import UIKit

var UID = "06c6f280c902a775caadda88750175568eea0d88acac67132c34468b59bf7450" //this project is now delete
var SECRET = "4dbaa9ac55c03b61c455c612091a46725079d844e1c6279d93dfa6876a83f4d6" //doesn't exist anymore
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
    var toSearch : String?
    var user: UserInfo? {
        didSet{
            DispatchQueue.main.async {
                if (self.user != nil && self.user!.login != nil){
                    if ( TOKEN == nil || TOKEN!.expire_date == nil || TOKEN!.expire_date! <= Date()) {
                        self.exchangeCodeForToken()
                    }
                    self.performSegue(withIdentifier: "profileSegue", sender: self)
                }
                else{
                    print("-----\ncurrentUser clear\n-----")
                }
            }
        }
    }

    
    override func viewDidAppear(_ animated: Bool) {
        DispatchQueue.main.async {
            self.unblockUser()
        }
        if ( TOKEN == nil || TOKEN!.expire_date == nil || TOKEN!.expire_date! <= Date()) {
            self.exchangeCodeForToken()
        }
        if (user != nil){
            user = nil
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar){
        self.blockUser()
        self.makeSearch(toFind: self.toSearch!)
    }
    
    func makeSearch(toFind: String){
        self.getUserInfo(currentUser: toFind.lowercased())
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "profileSegue"{
            self.unblockUser()
            let vc = segue.destination as! ProfileViewController
            vc.currentUser = self.user!
        }
    }

    
    func exchangeCodeForToken() {
        var components = URLComponents()
        
        self.blockUser()
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
                DispatchQueue.main.async {
                    self.manageError("Problème de connexion")
                    self.blockUser()
                    return
                }
                print(err)
            }
            if let resp = response as? HTTPURLResponse {
                if (resp.statusCode != 200){
                    DispatchQueue.main.async {
                        self.manageError("Probleme de connexion")
                        self.blockUser()
                        return
                    }
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
                            self.blockUser()
                            return
                        }
                    }
                    else {
                        TOKEN!.expire_date = Date() + TimeInterval(2 * 60 * 60) + TimeInterval(TOKEN!.expires_in!)
                        DispatchQueue.main.async {
                            self.unblockUser()
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
                        return
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
        unblockUser()
    }
    
    func wrongValueMessage(){
        let error : String = "⚠️ \"" + self.toSearch! + "\" does not exist ⚠️"
        manageError(error)
    }
    
    func blockUser(){
        showSpinner(onView: self.view)
        self.toSearch = self.searchField.text!
        self.searchField.isUserInteractionEnabled = false
    }
    
    func unblockUser(){
        self.searchField.isUserInteractionEnabled = true
        self.searchField.text = ""
        self.removeSpinner()
    }
    
}

var vSpinner : UIView?
extension UIViewController {
    func showSpinner(onView : UIView) {
        let spinnerView = UIView.init(frame: onView.bounds)
        spinnerView.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        let ai = UIActivityIndicatorView.init()
        ai.startAnimating()
        ai.center = spinnerView.center
        
        DispatchQueue.main.async {
            spinnerView.addSubview(ai)
            onView.addSubview(spinnerView)
        }
        
        vSpinner = spinnerView
    }
    
    func removeSpinner() {
        DispatchQueue.main.async {
            vSpinner?.removeFromSuperview()
            vSpinner = nil
        }
    }
}
