//
//  CocktailManager.swift
//  Cocktail Challenge
//
//  Created by Valentina Olariaga on 10/3/22.
//

import Foundation
import UIKit

protocol CocktailManagerDelegate {
    func didUpdateCocktail(_ cocktailManager : CocktailManager, _ cocktailList : CocktailData)
    func didFailWithError(error: Error?)
}

struct CocktailManager {
    var delegate : CocktailManagerDelegate?
    
    func performRequest(_ urlString : String) {
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                if let safeData = data {
                    if let cocktailDrinks = parseJSON(safeData) {
                        self.delegate?.didUpdateCocktail(self, cocktailDrinks)
                    }
                }
            }
            task.resume()
        }
    }
    
    func parseJSON(_ data: Data) -> CocktailData? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(CocktailData.self, from: data)
            return decodedData
        } catch {
            self.delegate?.didFailWithError(error: error)
            return nil
        }
    }
}
