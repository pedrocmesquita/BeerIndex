//
//  ViewController.swift
//  BeerIndex
//
//  Created by itsector on 07/03/2024.
//

import UIKit
import GoogleSignIn

class ViewController: UIViewController {

    @IBOutlet weak var name: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Get all beers from API
        getBeers.sharedInstance.fetchBeers()
        
        // Get beer with id 4
        getBeers.sharedInstance.fetchBeerById(4)
        
        
        
        
    }
    @IBAction func out(_ sender: UIButton) {
        
        let currentUser = User.current;
        
        // handel signout in parse swift
        if ((currentUser) != nil) {
            do{
                try User.logout()
                
                print("previous user logged out!")
            }
            catch{
                print("No user to logout")
            }
        }
        
        // handele signout for google
        if (GIDSignIn.sharedInstance.hasPreviousSignIn()){
            GIDSignIn.sharedInstance.signOut();
        }
        
    }
    
    @IBAction func seuBotao(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Login", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        self.navigationController?.pushViewController(viewController, animated: true)
    }

    

}

