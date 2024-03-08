//
//  ViewController.swift
//  BeerIndex
//
//  Created by itsector on 07/03/2024.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var collectionButton: UIButton!
    @IBOutlet weak var apiButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func showAPIData(_ sender: Any) {
        // Get all beers from API
        getBeers.sharedInstance.fetchBeers()
        
        // Get beer with id 4
        //getBeers.sharedInstance.fetchBeerById(4)
    }
    
    @IBAction func travelTo(_ sender: Any) {
        navigateToSecondStoryboard()
    }
    
    func navigateToSecondStoryboard() {
        let storyboard = UIStoryboard(name: "BeerIndex", bundle: nil)
        if let BeerIndex = storyboard.instantiateViewController(withIdentifier: "ViewControllerBIdentifier") as? BeerIndex {
            self.navigationController?.pushViewController(BeerIndex, animated: true)
        }
    }
    
}

