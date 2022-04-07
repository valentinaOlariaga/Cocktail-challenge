//
//  CocktailManager.swift
//  Cocktail Challenge
//
//  Created by Valentina Olariaga on 10/3/22.
//

import Foundation
import UIKit

protocol CocktailManagerDrinkDelegate {
    func didUpdateCocktail(_ cocktailManagerDrink : CocktailManagerDrink, _ drink : CocktailDataDrink)
    func didFailWithError(error: Error)
}

struct CocktailManagerDrink {
    var delegate : CocktailManagerDrinkDelegate?
    
    func performRequest(_ urlString : String){
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                if let safeData = data {
                    DispatchQueue.main.async {
                        if let drink = parseJSON(safeData) {
                            self.delegate?.didUpdateCocktail(self, drink)
                        }
                    }
                }
            }
            task.resume()
        }
    }
    
    func parseJSON(_ data: Data) -> CocktailDataDrink? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(CocktailDataDrink.self, from: data)
            return decodedData
        } catch {
            self.delegate?.didFailWithError(error: error)
            return nil
        }
    }
}
