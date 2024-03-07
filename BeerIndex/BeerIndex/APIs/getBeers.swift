//
//  getBeers.swift
//  BeerIndex
//
//  Created by itsector on 07/03/2024.
//

import Foundation
import Alamofire

class getBeers {
    static let sharedInstance = getBeers()
    
    // Get all the beers available in the API
    func fetchBeers(){
        let url = "https://api.punkapi.com/v2/beers";
          AF.request(url).responseData { response in
              switch response.result {
              case .success(let data):
                  do {
                      
                      let jsonData = try JSONDecoder().decode([Beer].self, from: data)
                      print(jsonData)
                  } catch {
                      print("Decoding error: \(error)")
                  }
              case .failure(let error):
                  print("Request error: \(error.localizedDescription)")
              }
          }
    }
    
    // I don't know if it wil be needed but done just in case since it's basically the same
    func fetchBeerById(_ id: Int){
        let url = "https://api.punkapi.com/v2/beers/\(id)";
          AF.request(url).responseData { response in
              switch response.result {
              case .success(let data):
                  do {
                      
                      /* Print JSON received because error testing
                      if let jsonString = String(data: data, encoding: .utf8) {
                          print(jsonString)
                      } else {
                          print("couldn't convert to string")
                      } */
                      
                      let jsonData = try JSONDecoder().decode([Beer].self, from: data)
                      print(jsonData)
                  } catch {
                      print("Decoding error: \(error)")
                  }
              case .failure(let error):
                  print("Request error: \(error.localizedDescription)")
              }
          }
    }
}

