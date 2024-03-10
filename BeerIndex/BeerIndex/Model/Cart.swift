//
//  Car.swift
//  BeerIndex
//
//  Created by ITSector on 10/03/2024.
//

import Foundation

class Cart {
    var items: [Beer: Int] = [:]
    
    func addItem(_ beer: Beer) {
        if let existingQuantity = items[beer] {
            // Se a cerveja já estiver no carrinho, adicione mais um à quantidade
            print("adiciona a \(String(describing: beer.name))")
            items[beer] = existingQuantity + 1
        } else {
            // Se a cerveja não estiver no carrinho, adicione-a com uma quantidade de 1
            print("adicionado \(String(describing: beer.name))")
            items[beer] = 1
        }
    }
    
    func removeItem(_ beer: Beer) {
        items.removeValue(forKey: beer)
    }
        
    func updateQuantity(for beer: Beer, quantity: Int) {
        items[beer] = quantity
    }
}

// Dependency Injection
// devido a utilização no BeerIndex e no ShoppingCart
class MyItens {
    static let shared = MyItens()
    var shoppingCart = Cart()
}
