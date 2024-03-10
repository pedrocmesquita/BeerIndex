//
//  BeerIndex.swift
//  BeerIndex
//
//  Created by itsector on 07/03/2024.
//

import Foundation
import UIKit

class BeerIndex: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, AddToCartDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var logo: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var cartButton: UIBarButtonItem!
    
    var beers: [Beer] = []
    
    var shoppingCart = MyItens.shared.shoppingCart
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.backgroundImage = UIImage()
        searchBar.placeholder = "Name or number"
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UINib(nibName: "CustomBeerCell", bundle: nil), forCellWithReuseIdentifier: "BeerCell")

        // Get all beers from API
        getBeers.sharedInstance.fetchBeers { [weak self] (fetchedBeers, error) in
                    DispatchQueue.main.async {
                        if let fetchedBeers = fetchedBeers {
                            self?.beers = fetchedBeers
                            self?.collectionView.reloadData()
                            print(self?.beers,"\n\n\n\n")
                        } else if let error = error {
                            print("Error fetching beers: \(error.localizedDescription)")
                        }
                    }
                }
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
    
    func addToCart(beer: Beer) {
        shoppingCart.addItem(beer)
    }
}

extension BeerIndex {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return beers.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        /*
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BeerCell", for: indexPath)
        
        cell.contentView.subviews.forEach({ $0.removeFromSuperview() })
        
        let imageView = UIImageView(frame: cell.bounds)
        imageView.contentMode = .scaleAspectFit
        cell.contentView.addSubview(imageView)
        
        // unwrap image url adn asynconously load it
        if let imageURLString = beers[indexPath.row].image_url, let imageURL = URL(string: imageURLString) {
            DispatchQueue.global(qos: .userInitiated).async {
                if let imageData = try? Data(contentsOf: imageURL) {
                    DispatchQueue.main.async {
                        imageView.image = UIImage(data: imageData)
                    }
                }
            }
        }
        
        return cell
     */
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BeerCell", for: indexPath) as? CustomBeerCell else {
                return UICollectionViewCell()
            }
            
            let beer = beers[indexPath.row]
            cell.configure(with: beer)
        cell.delegate = self
            
            return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 170, height: 230)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let beer = beers[indexPath.row]
        let storyboard = UIStoryboard(name: "BeerIndex", bundle: nil)
            if let detailsController = storyboard.instantiateViewController(withIdentifier: "DetailsIdentifier") as? Details {
                
                detailsController.beer = beer
                
                self.navigationController?.pushViewController(detailsController, animated: true)
            }
    }
}




