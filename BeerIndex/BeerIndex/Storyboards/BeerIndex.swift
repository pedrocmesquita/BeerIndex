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
    
    let beer2 = Beer(
        id: 193,
        name: "Galaxy IPA",
        tagline: "Intergalactic Experience. Fruity. Hoppy.",
        first_brewed: "09/2010",
        description: "Embark on an intergalactic journey with our Galaxy IPA. Packed with the finest Australian Galaxy hops, this beer delivers an explosion of tropical fruit flavors, including passionfruit, peach, and citrus, balanced by a satisfying hop bitterness.",
        image_url: "https://images.punkapi.com/v2/195.png",
        abv: 6.5,
        ibu: 55.0,
        target_fg: 1012.0,
        target_og: 1058.0,
        ebc: 20.0,
        srm: 10.0,
        ph: 4.2,
        attenuation_level: 79.31,
        volume: Volume(value: 20, unit: "liters"),
        boil_volume: Volume(value: 25, unit: "liters"),
        method: Method(
            mash_temp: [
                MashTemp(
                    temp: Volume(value: 67, unit: "celsius"),
                    duration: 60
                )
            ],
            fermentation: Fermentation(
                temp: Volume(value: 20.0, unit: "celsius")
            ),
            twist: nil
        ),
        ingredients: Ingredients(
            malt: [
                Malt(
                    name: "Maris Otter Extra Pale",
                    amount: Volume(value: 4.5, unit: "kilograms")
                ),
                Malt(
                    name: "CaraPils",
                    amount: Volume(value: 0.5, unit: "kilograms")
                )
            ],
            hops: [
                Hop(
                    name: "Galaxy",
                    amount: Volume(value: 25, unit: "grams"),
                    add: "start",
                    attribute: "bitter"
                ),
                Hop(
                    name: "Galaxy",
                    amount: Volume(value: 50, unit: "grams"),
                    add: "middle",
                    attribute: "flavour"
                ),
                Hop(
                    name: "Galaxy",
                    amount: Volume(value: 75, unit: "grams"),
                    add: "end",
                    attribute: "aroma"
                )
            ],
            yeast: "Wyeast 1098 - British Ale™"
        ),
        food_pairing: [
            "Thai green curry",
            "Grilled pineapple and shrimp skewers",
            "Passion fruit cheesecake"
        ],
        brewer_tips: "To showcase the unique flavors of Galaxy hops, use them generously in late additions and dry hopping stages.",
        contributed_by: "Emily Johnson <emilyj>"
    )

    let beer3 = Beer(
        id: 194,
        name: "Baltic Porter",
        tagline: "Rich. Complex. Smooth.",
        first_brewed: "11/2012",
        description: "Indulge in the luxurious flavors of our Baltic Porter. Brewed with a complex blend of specialty malts and a touch of traditional lager yeast, this beer boasts notes of chocolate, caramel, and dark fruits, balanced by a smooth, velvety mouthfeel.",
        image_url: "https://images.punkapi.com/v2/194.png",
        abv: 8.0,
        ibu: 40.0,
        target_fg: 1020.0,
        target_og: 1090.0,
        ebc: 70.0,
        srm: 35.0,
        ph: 4.0,
        attenuation_level: 77.78,
        volume: Volume(value: 20, unit: "liters"),
        boil_volume: Volume(value: 25, unit: "liters"),
        method: Method(
            mash_temp: [
                MashTemp(
                    temp: Volume(value: 65, unit: "celsius"),
                    duration: 60
                )
            ],
            fermentation: Fermentation(
                temp: Volume(value: 12.0, unit: "celsius")
            ),
            twist: "Aged in oak barrels for 6 months"
        ),
        ingredients: Ingredients(
            malt: [
                Malt(
                    name: "Munich",
                    amount: Volume(value: 5.0, unit: "kilograms")
                ),
                Malt(
                    name: "Brown",
                    amount: Volume(value: 1.0, unit: "kilograms")
                ),
                Malt(
                    name: "Crystal 300",
                    amount: Volume(value: 0.5, unit: "kilograms")
                ),
                Malt(
                    name: "Chocolate",
                    amount: Volume(value: 0.5, unit: "kilograms")
                )
            ],
            hops: [
                Hop(
                    name: "Saaz",
                    amount: Volume(value: 30, unit: "grams"),
                    add: "start",
                    attribute: "bitter"
                )
            ],
            yeast: "Saflager S-23™"
        ),
        food_pairing: [
            "Beef stroganoff",
            "Dark chocolate fondant",
            "Vanilla bean ice cream"
        ],
        brewer_tips: "For optimal results, allow the beer to age in a cool, dark place for at least 6 months before consumption.",
        contributed_by: "Michael Williams <michaelw>"
    )

    let beer4 = Beer(
        id: 195,
        name: "Summer Wheat Ale",
        tagline: "Light. Refreshing. Citrusy.",
        first_brewed: "05/2018",
        description: "Quench your thirst with our Summer Wheat Ale. Brewed with a blend of malted wheat and barley, and infused with zesty citrus hops, this beer offers a crisp and refreshing taste with hints of lemon and orange, perfect for sipping on a hot summer day.",
        image_url: "https://images.punkapi.com/v2/195.png",
        abv: 4.2,
        ibu: 25.0,
        target_fg: 1008.0,
        target_og: 1040.0,
        ebc: 10.0,
        srm: 5.0,
        ph: 4.2,
        attenuation_level: 80.0,
        volume: Volume(value: 20, unit: "liters"),
        boil_volume: Volume(value: 25, unit: "liters"),
        method: Method(
            mash_temp: [
                MashTemp(
                    temp: Volume(value: 67, unit: "celsius"),
                    duration: 60
                )
            ],
            fermentation: Fermentation(
                temp: Volume(value: 18.0, unit: "celsius")
            ),
            twist: "Add a slice of lemon to garnish when serving"
        ),
        ingredients: Ingredients(
            malt: [
                Malt(
                    name: "Wheat",
                    amount: Volume(value: 3.0, unit: "kilograms")
                ),
                Malt(
                    name: "Pale",
                    amount: Volume(value: 2.0, unit: "kilograms")
                )
            ],
            hops: [
                Hop(
                    name: "Amarillo",
                    amount: Volume(value: 20, unit: "grams"),
                    add: "middle",
                    attribute: "flavour"
                ),
                Hop(
                    name: "Cascade",
                    amount: Volume(value: 15, unit: "grams"),
                    add: "middle",
                    attribute: "flavour"
                ),
                Hop(
                    name: "Amarillo",
                    amount: Volume(value: 25, unit: "grams"),
                    add: "end",
                    attribute: "aroma"
                ),
                Hop(
                    name: "Cascade",
                    amount: Volume(value: 20, unit: "grams"),
                    add: "end",
                    attribute: "aroma"
                )
            ],
            yeast: "Wyeast 1010 - American Wheat™"
        ),
        food_pairing: [
            "Grilled shrimp skewers",
            "Summer salads with citrus vinaigrette",
            "Lemon sorbet"
        ],
        brewer_tips: "For a burst of citrus aroma, consider adding a zest of lemon or orange during the last few minutes of the boil.",
        contributed_by: "Alexandra Lee <alexlee>"
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
            beers.append(beer2)
            beers.append(beer3)
            beers.append(beer4)
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
