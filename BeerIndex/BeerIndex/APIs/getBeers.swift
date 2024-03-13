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
    
    // Get all the beers available in the API, not used since now pagination in method fetchBeersPagination
    func fetchBeers(completion: @escaping ([Beer]?, Error?) -> Void){
        let url = "https://api.punkapi.com/v2/beers";
          AF.request(url).responseData { response in
              switch response.result {
              case .success(let data):
                  do {
                      let jsonData = try JSONDecoder().decode([Beer].self, from: data)
                      completion(jsonData, nil)
                      //print(jsonData)
                  } catch {
                      completion(nil, error)
                      print("Decoding error: \(error)")
                  }
              case .failure(let error):
                  completion(nil, error)
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
    
    // pagination, gets perPage beers at a time
    func fetchBeersPagination(page: Int, perPage: Int, completion: @escaping ([Beer]?, Error?) -> Void) {
        let url = "https://api.punkapi.com/v2/beers?page=\(page)&per_page=\(perPage)"
        AF.request(url).responseData { response in
            switch response.result {
            case .success(let data):
                do {
                    let jsonData = try JSONDecoder().decode([Beer].self, from: data)
                    completion(jsonData, nil)
                } catch {
                    completion(nil, error)
                }
            case .failure(let error):
                completion(nil, error)
            }
        }
    }
    
    func fetchBeersByName(name: String, completion: @escaping ([Beer]?, Error?) -> Void) {
        let url = "https://api.punkapi.com/v2/beers?beer_name=\(name)"
        AF.request(url).responseData { response in
            switch response.result {
            case .success(let data):
                do {
                    let jsonData = try JSONDecoder().decode([Beer].self, from: data)
                    completion(jsonData, nil)
                } catch {
                    completion(nil, error)
                }
            case .failure(let error):
                completion(nil, error)
            }
        }
    }
}

