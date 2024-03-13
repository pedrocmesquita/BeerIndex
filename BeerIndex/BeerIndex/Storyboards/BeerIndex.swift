//
//  BeerIndex.swift
//  BeerIndex
//
//  Created by itsector on 07/03/2024.
//

import Foundation
import UIKit
import GoogleSignIn

class BeerIndex: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, AddToCartDelegate, UISearchBarDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var logo: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var cartButton: UIBarButtonItem!
    
    
    var beers: [Beer] = []
    
    var shoppingCart = MyItens.shared.shoppingCart
    
    var currentPage = 1
    var isLoading = false
    var hasMoreBeers = true
    var isSearchMode = false
    
    // Test beer to use since API was down on 13/03
    let testBeer = Beer(
        id: 192,
        name: "Punk IPA 2007 - 2010",
        tagline: "Post Modern Classic. Spiky. Tropical. Hoppy.",
        first_brewed: "04/2007",
        description: "Our flagship beer that kick started the craft beer revolution. This is James and Martin's original take on an American IPA, subverted with punchy New Zealand hops. Layered with new world hops to create an all-out riot of grapefruit, pineapple and lychee before a spiky, mouth-puckering bitter finish.",
        image_url: "https://images.punkapi.com/v2/192.png",
        abv: 6.0,
        ibu: 60.0,
        target_fg: 1010.0,
        target_og: 1056.0,
        ebc: 17.0,
        srm: 8.5,
        ph: 4.4,
        attenuation_level: 82.14,
        volume: Volume(value: 20, unit: "liters"),
        boil_volume: Volume(value: 25, unit: "liters"),
        method: Method(
            mash_temp: [
                MashTemp(
                    temp: Volume(value: 65, unit: "celsius"),
                    duration: 75
                )
            ],
            fermentation: Fermentation(
                temp: Volume(value: 19.0, unit: "celsius")
            ),
            twist: nil
        ),
        ingredients: Ingredients(
            malt: [
                Malt(
                    name: "Extra Pale",
                    amount: Volume(value: 5.3, unit: "kilograms")
                )
            ],
            hops: [
                Hop(
                    name: "Ahtanum",
                    amount: Volume(value: 17.5, unit: "grams"),
                    add: "start",
                    attribute: "bitter"
                ),
                Hop(
                    name: "Chinook",
                    amount: Volume(value: 15, unit: "grams"),
                    add: "start",
                    attribute: "bitter"
                )
            ],
            yeast: "Wyeast 1056 - American Ale™"
        ),
        food_pairing: [
            "Spicy carne asada with a pico de gallo sauce",
            "Shredded chicken tacos with a mango chilli lime salsa",
            "Cheesecake with a passion fruit swirl sauce"
        ],
        brewer_tips: "While it may surprise you, this version of Punk IPA isn't dry hopped but still packs a punch! To make the best of the aroma hops make sure they are fully submerged and add them just before knock out for an intense hop hit.",
        contributed_by: "Sam Mason <samjbmason>"
    )

    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.backgroundImage = UIImage()
        searchBar.placeholder = "Name of the beer"
        searchBar.delegate = self
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
        
        addTestBeer()
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
        //comentadas porque estava a dar erro ao dar reset à searchbar
        //guard !isLoading && hasMoreBeers else { return }
        //isLoading = true
        
        if isSearchMode{
            return
        }
        
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
    
    func addTestBeer() {
        if beers.isEmpty {
            beers.append(testBeer)
        }
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
    
    func startNewSearch(withName name: String) {
            isSearchMode = true
            currentPage = 1
            hasMoreBeers = true
            beers.removeAll()
            collectionView.reloadData()
            
            searchBeers(byName: name)
    }
        
    func searchBeers(byName name: String) {
        getBeers.sharedInstance.fetchBeersByName(name: name) { [weak self] (fetchedBeers, error) in
            DispatchQueue.main.async {
                if let fetchedBeers = fetchedBeers {
                    self?.beers = fetchedBeers
                    self?.collectionView.reloadData()
                } else if let error = error {
                    print("Error fetching beers by name: \(error.localizedDescription)")
                }
            }
        }
            // Reset search bar
            searchBar.text = nil
            searchBar.resignFirstResponder()
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
    
    
    
     func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
         if searchText.isEmpty {
             self.resetSearch()
         }
     }
     
     func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
         guard let searchText = searchBar.text, !searchText.isEmpty else {
             resetSearch()
             return
         }
         startNewSearch(withName: searchText)
     }
     
     func resetSearch() {
         DispatchQueue.main.async {
             self.searchBar.text = nil
             self.isSearchMode = false
             self.beers.removeAll()
             self.currentPage = 1
             self.hasMoreBeers = true
             self.collectionView.reloadData()
             self.loadBeers()
         }
     }
}
