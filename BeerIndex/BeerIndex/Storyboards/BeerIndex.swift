//
//  BeerIndex.swift
//  BeerIndex
//
//  Created by itsector on 07/03/2024.
//

import Foundation
import UIKit

class BeerIndex: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var logo: UIImageView!
    @IBOutlet weak var cartButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Get all beers from API
        //getBeers.sharedInstance.fetchBeers()
        
        // Get beer with id 4
        //getBeers.sharedInstance.fetchBeerById(4)
        
        searchBar.backgroundImage = UIImage()
    }
    
    func displayImage() {
        logo.image = UIImage(named: "image")
    }

    @IBAction func cartButtonTapped(_ sender: Any) {
        let storyboard = UIStoryboard(name: "ShoppingCart", bundle: nil)
        if let ShoppingCart = storyboard.instantiateViewController(withIdentifier: "shoppingCartView") as? ShoppingCart {
            self.navigationController?.pushViewController(ShoppingCart, animated: true)
        }
    }
}

