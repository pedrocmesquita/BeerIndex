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
            // If the beer is already in the cart, add one to the quantity
            print("add \(String(describing: beer.name))")
            items[beer] = existingQuantity + 1
        } else {
            // If the beer is not in the cart, add it with a quantity of 1
            print("added \(String(describing: beer.name))")
            items[beer] = 1
        }
    }
    
    func removeItem(_ beer: Beer) {
        items.removeValue(forKey: beer)
    }
    
    func addQuantity(for beer: Beer, delta: Int) {
        if let existingQuantity = items[beer] {
            let newQuantity = max(0, existingQuantity + delta) // Ensure the quantity is never negative
            items[beer] = newQuantity
        } else {
            // If the beer is not in the cart, there is nothing to do
            print("Error: Beer \(beer.name ?? "unknown") is not in the cart.")
        }
    }
    
    func removeQuantity(for beer: Beer, quantityToRemove: Int) {
        if let existingQuantity = items[beer] {
            if quantityToRemove >= existingQuantity {
                // Remove the beer if the quantity to remove is greater than or equal to the existing quantity
                removeItem(beer)
            } else {
                // Remove the specified quantity
                items[beer] = existingQuantity - quantityToRemove
            }
        } else {
            // If the beer is not in the cart, there is nothing to do
            print("Error: Beer \(beer.name ?? "unknown") is not in the cart.")
        }
    }
    
}

// Dependency Injection
// used in BeerIndex and ShoppingCart
class MyItens {
    static let shared = MyItens()
    var shoppingCart = Cart()
}
