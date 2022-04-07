//
//  CocktailData.swift
//  Cocktail Challenge
//
//  Created by Valentina Olariaga on 10/3/22.
//

import Foundation

struct CocktailData :  Decodable{
    let drinks : [Drink]
}

struct Drink : Decodable{
    let strDrink : String
    let strDrinkThumb : String
    let idDrink : String
}




