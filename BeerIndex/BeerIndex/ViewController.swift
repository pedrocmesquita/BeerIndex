//
//  ViewController.swift
//  BeerIndex
//
//  Created by itsector on 07/03/2024.
//

import UIKit

class ViewController: UIViewController {

    
    @IBOutlet weak var indexButton: UIButton!
    @IBOutlet weak var APIButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
    }
    @IBAction func traveltoIndex(_ sender: Any) {
        let storyboard = UIStoryboard(name: "BeerIndex", bundle: nil)
            if let viewControllerB = storyboard.instantiateViewController(withIdentifier: "ViewControllerBIdentifier") as? UIViewController {
                self.navigationController?.pushViewController(viewControllerB, animated: true)
            }
    }
    @IBAction func Login(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Login", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    @IBAction func viewAPI(_ sender: Any) {
        // Get all beers from API
        //getBeers.sharedInstance.fetchBeers()
        
        // Get beer with id 4
        //getBeers.sharedInstance.fetchBeerById(4)
    }
    
}

