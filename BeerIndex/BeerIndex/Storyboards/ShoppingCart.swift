//
//  ShoppingCart.swift
//  BeerIndex
//
//  Created by itsector on 07/03/2024.
//

import Foundation
import UIKit

class ShoppingCart: UIViewController{
    
    @IBOutlet weak var table: UITableView!
    
    var shoppingCart = MyItens.shared.shoppingCart
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        table.dataSource = self
        table.delegate = self
        
        table.register(CustomCartCell.nib(), forCellReuseIdentifier: CustomCartCell.identifier)
        
    }
    
}

extension ShoppingCart: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shoppingCart.items.count
    }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CustomCartCell.identifier, for: indexPath) as? CustomCartCell else {
            fatalError("Failed to dequeue CustomCartCell.")
        }
        
        let beer = Array(shoppingCart.items.keys)[indexPath.row]
        let quantity = shoppingCart.items[beer] ?? 0
        
        cell.nameBeer.text = beer.name
        cell.amountBeer.text = String(quantity)
        
        cell.onAddButtonTapped = {
            // Incrementar a quantidade quando o botão de adicionar é pressionado
            self.shoppingCart.addQuantity(for: beer, delta: 1)
            tableView.reloadData() // Atualizar a tabela após a alteração na quantidade
        }
        
        cell.onRemoveButtonTapped = {
            // Decrementar a quantidade quando o botão de remover é pressionado
            self.shoppingCart.removeQuantity(for: beer, quantityToRemove: 1)
            tableView.reloadData() // Atualizar a tabela após a alteração na quantidade
        }
        
        return cell
    }
    
    // redirecionar para a paguina de Details
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let beer = Array(shoppingCart.items.keys)[indexPath.row]
        let storyboard = UIStoryboard(name: "BeerIndex", bundle: nil)
        if let detailsController = storyboard.instantiateViewController(withIdentifier: "DetailsIdentifier") as? Details {
            detailsController.beer = beer
            navigationController?.pushViewController(detailsController, animated: true)
        }
    }
}

