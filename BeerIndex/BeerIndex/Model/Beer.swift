//
//  Beer.swift
//  BeerIndex
//
//  Created by itsector on 07/03/2024.
//

import Foundation

struct Beer: Codable, Hashable{
    let id: Int?
    let name: String?
    let tagline: String?
    let first_brewed: String?
    let description: String?
    let image_url: String?
    let abv: Double?
    let ibu: Double?
    let target_fg: Double?
    let target_og: Double?
    let ebc: Double?
    let srm: Double?
    let ph: Double?
    let attenuation_level: Double?
    let volume: Volume?
    let boil_volume: Volume?
    let method: Method?
    let ingredients: Ingredients?
    let food_pairing: [String]?
    let brewer_tips: String?
    let contributed_by: String?
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(name)
    }
       
    static func ==(lhs: Beer, rhs: Beer) -> Bool {
        return lhs.id == rhs.id &&
        lhs.name == rhs.name
    }
}

struct Volume: Codable{
    let value: Double?
    let unit: String?
}

struct Method: Codable{
    let mash_temp: [MashTemp]?
    let fermentation: Fermentation?
    let twist: String?
}

struct MashTemp: Codable{
    let temp: Volume?
    let duration: Int?
}

struct Fermentation: Codable{
    let temp: Volume?
}

struct Ingredients: Codable{
    let malt: [Malt]?
    let hops: [Hop]?
    let yeast: String?
}

struct Malt: Codable {
    let name: String?
    let amount: Volume?
}

struct Hop: Codable {
    let name: String?
    let amount: Volume?
    let add, attribute: String?
}
