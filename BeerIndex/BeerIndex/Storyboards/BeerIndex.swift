//
//  BeerIndex.swift
//  BeerIndex
//
//  Created by itsector on 07/03/2024.
//

import Foundation
import UIKit
import GoogleSignIn

class BeerIndex: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, AddToCartDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var logo: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var cartButton: UIBarButtonItem!
    
    var beers: [Beer] = []
    
    var shoppingCart = MyItens.shared.shoppingCart
    
    var currentPage = 1
    var isLoading = false
    var hasMoreBeers = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.backgroundImage = UIImage()
        searchBar.placeholder = "Name or number"
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UINib(nibName: "CustomBeerCell", bundle: nil), forCellWithReuseIdentifier: "BeerCell")

        /* Get all beers from API, substitued by pagination in method loadBeers()
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
                } */
        
        loadBeers()
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
    
    func loadBeers() {
        guard !isLoading && hasMoreBeers else { return }
        isLoading = true

        getBeers.sharedInstance.fetchBeersPagination(page: currentPage, perPage: 20) { [weak self] (fetchedBeers, error) in
            DispatchQueue.main.async {
                self?.isLoading = false
                if let fetchedBeers = fetchedBeers {
                    self?.beers.append(contentsOf: fetchedBeers)
                    self?.collectionView.reloadData()
                    self?.currentPage += 1
                    if fetchedBeers.isEmpty {
                        self?.hasMoreBeers = false
                    }
                } else if let error = error {
                    print("Error fetching beers: \(error.localizedDescription)")
                }
            }
        }
    }
    
    @IBAction func logOutButton(_ sender: UIButton) {
        logoutCurrentUser()
    }
    
    func logoutCurrentUser() {
        let currentUser = User.current
        
        // Executa a operação de logout em uma fila de background
        DispatchQueue.global(qos: .background).async { [self] in
            
            if((currentUser) != nil) {
                // Logout do usuário do Parse
                do {
                    try User.logout()
                    print("previous user logged out!")
                } catch {
                    print("No user to logout")
                }
            }
            
            // Logout Google
            if (GIDSignIn.sharedInstance.hasPreviousSignIn()){
                GIDSignIn.sharedInstance.signOut();
            }
            
            shoppingCart.clearCart()
            
            
            
            // Exibe uma mensagem na thread principal
            DispatchQueue.main.async {
                print("Utilizador desconectado de todos os serviços")
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let viewControllerB = storyboard.instantiateViewController(withIdentifier: "Main")
                // Hide the navigation bar on the next screen
                viewControllerB.navigationItem.hidesBackButton = true
                self.navigationController?.pushViewController(viewControllerB, animated: true)
                
            }
            
        }
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
    
    // pagination, basically checks when we're at the last column and loads more
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == beers.count - 1 {
            loadBeers()
        }
    }
    
}




