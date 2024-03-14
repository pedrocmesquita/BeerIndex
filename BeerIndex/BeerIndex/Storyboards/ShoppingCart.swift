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
    @IBOutlet weak var buyButton: UIButton!
    
    //var shoppingCart = MyItens.shared.shoppingCart
    
    var shoppingCart = MyItens.shared.shoppingCart {
            didSet {
                // Atualizar o estado do botão de compra sempre que o carrinho for atualizado
                updateBuyButtonState()
            }
        }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        table.dataSource = self
        table.delegate = self
        
        table.register(CustomCartCell.nib(), forCellReuseIdentifier: CustomCartCell.identifier)
        
        updateBuyButtonState()
        
        // Adicionar um alvo para o botão de compra
        buyButton.addTarget(self, action: #selector(buyButtonTapped), for: .touchUpInside)
    }
            
    // Atualizar o estado do botão de compra com base na contagem de itens no carrinho
    func updateBuyButtonState() {
        buyButton.isEnabled = !shoppingCart.items.isEmpty
    }
            
    // Método chamado quando o botão de compra é pressionado
    @objc func buyButtonTapped() {
        if shoppingCart.items.isEmpty {
            showMessage(title: "Empty Cart", message: "Your shopping cart is empty.")
        } else {
            // Limpar o carrinho
            shoppingCart.clearCart()
            table.reloadData()
            
            self.updateBuyButtonState()
            
            showMessage(title: "Successful purchase", message: "Your purchase was successful.")
        }
    }
    
}

extension ShoppingCart: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shoppingCart.items.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 131
    }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CustomCartCell.identifier, for: indexPath) as? CustomCartCell else {
            fatalError("Failed to dequeue CustomCartCell.")
        }
        
        let beer = Array(shoppingCart.items.keys)[indexPath.row]
        let quantity = shoppingCart.items[beer] ?? 0
        
        cell.nameBeer.text = beer.name
        cell.amountBeer.text = String(quantity)
        
        if let imageURLString = beer.image_url, let imageURL = URL(string: imageURLString) {
            DispatchQueue.global(qos: .userInitiated).async {
                if let imageData = try? Data(contentsOf: imageURL) {
                    DispatchQueue.main.async {
                        cell.customImageView.image = UIImage(data: imageData)
                    }
                }
            }
        }
        
        cell.onAddButtonTapped = {
            // Incrementar a quantidade quando o botão de adicionar é pressionado
            self.shoppingCart.addQuantity(for: beer, delta: 1)
            tableView.reloadData() // Atualizar a tabela após a alteração na quantidade
        }
        
        cell.onRemoveButtonTapped = {
            // Decrementar a quantidade quando o botão de remover é pressionado
            self.shoppingCart.removeQuantity(for: beer, quantityToRemove: 1)
            tableView.reloadData() // Atualizar a tabela após a alteração na quantidade
            
            self.updateBuyButtonState()
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
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
       
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completionHandler) in
            // Remover a cerveja do carrinho
            let beer = Array(self.shoppingCart.items.keys)[indexPath.row]
            self.shoppingCart.removeItem(beer)
            
            // Remover a célula da tabela
            tableView.deleteRows(at: [indexPath], with: .fade)
            
            //se o carrinho estiver bazio atualizar o estado do carrinho
            self.updateBuyButtonState()
            
            completionHandler(true)
        }
        
        // Customize the delete button
        delete.backgroundColor = UIColor.systemYellow
        delete.image = UIImage(systemName: "trash")
        
        let configuration = UISwipeActionsConfiguration(actions: [delete])
        return configuration
    }
}

