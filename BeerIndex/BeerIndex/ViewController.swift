//
//  ViewController.swift
//  BeerIndex
//
//  Created by itsector on 07/03/2024.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Get all beers from API
        getBeers.sharedInstance.fetchBeers()
        
        // Get beer with id 4
        getBeers.sharedInstance.fetchBeerById(4)
    }

    @IBAction func seuBotao(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Login", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        self.navigationController?.pushViewController(viewController, animated: true)
    }


}

