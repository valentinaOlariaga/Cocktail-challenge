//
//  DetailsViewController.swift
//  Cocktail Challenge
//
//  Created by Valentina Olariaga on 11/3/22.
//

import UIKit
import ChameleonFramework
import Kingfisher

class DetailsViewController: UIViewController {
    
    var drink : Drink?
    var drinkDetails : DrinkData?
    let baseURLIdDrink = "https://www.thecocktaildb.com/api/json/v1/1/lookup.php?i="
    var cocktailManagerDrink = CocktailManagerDrink()
    let uiVioletColor = UIColor(red: 0.31, green: 0.30, blue: 0.73, alpha: 1.00)
    
    @IBOutlet weak var viewDetails: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var labelDetails: UILabel!
    @IBOutlet weak var labelIngredients: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let urlDrink: String = "\(baseURLIdDrink)\(drink!.idDrink)"
        self.view.backgroundColor = uiVioletColor
        viewDetails.layer.cornerRadius = self.view.frame.size.height / 100
        cocktailManagerDrink.delegate = self
        showData()
        cocktailManagerDrink.performRequest(urlDrink)
    }
    
    func doRequest() {
        labelIngredients.text = ""
        if let data = drinkDetails?.amountIngredients(){
            data.forEach { ingredient in
                labelIngredients.text =  """
                \(labelIngredients.text!)\(ingredient.measure) - \(ingredient.ingredient)
                
                """
            }
        }
        labelDetails.text = drinkDetails!.strInstructions
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        guard let navBar = navigationController?.navigationBar
        else {
            fatalError("Navigation controller does not exist")
        }
        navBar.backgroundColor = uiVioletColor
        navBar.tintColor = ContrastColorOf(uiVioletColor, returnFlat: true)
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundColor = uiVioletColor
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        navigationItem.standardAppearance = appearance
        navigationItem.scrollEdgeAppearance = appearance
    }
    
    func showData() {
        self.navigationItem.title = drink?.strDrink
        let imageStr = drink?.strDrinkThumb
        let url = URL(string : imageStr!)!
        imageView.kf.setImage(with: url)
   }
}

extension DetailsViewController : CocktailManagerDrinkDelegate {

    func didUpdateCocktail(_ cocktailManagerDrink: CocktailManagerDrink, _ drink : CocktailDataDrink) {
        drinkDetails = drink.drinks[0]
        doRequest()
    }

    func didFailWithError(error: Error) {
        print(error)
    }

}
