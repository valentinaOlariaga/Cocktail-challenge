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
    
    static var drink : CocktailDataDrink?
    
    @IBOutlet weak var viewDetails: UIView!
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var labelDetails: UILabel!
    @IBOutlet weak var labelIngredients: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red: 0.31, green: 0.30, blue: 0.73, alpha: 1.00)
        viewDetails.layer.cornerRadius = self.view.frame.size.height / 100
        
    }
    
    @IBAction func reload(_ sender: Any) {
        labelIngredients.text = ""
        self.navigationItem.title = DetailsViewController.drink?.drinks[0].strDrink
        
        let imageStr = DetailsViewController.drink?.drinks[0].strDrinkThumb
        let url = URL(string : imageStr!)!
        imageView.kf.setImage(with: url)
        
        if let data = DetailsViewController.drink?.drinks[0].amountIngredients(){
            for n in data {
                labelIngredients.text =  """
                \(labelIngredients.text!)\(n.measure) - \(n.ingredient)
                
                """
            }
            
            
        }
        labelDetails.text = DetailsViewController.drink?.drinks[0].strInstructions
        
    }
    override func viewWillAppear(_ animated: Bool) {
        
        guard let navBar = navigationController?.navigationBar else {fatalError("Navigation controller does not exist")}
        let navBarColour = UIColor(red: 0.31, green: 0.30, blue: 0.73, alpha: 1.00)
        
        navBar.backgroundColor = navBarColour
        navBar.tintColor = ContrastColorOf(navBarColour, returnFlat: true)
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundColor = navBarColour
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        navigationItem.standardAppearance = appearance
        navigationItem.scrollEdgeAppearance = appearance
        
        
    }
    
    
    
    
}
