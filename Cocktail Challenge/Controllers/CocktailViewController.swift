//
//  CocktailViewController.swift
//  Cocktail Challenge
//
//  Created by Valentina Olariaga on 9/3/22.
//

import UIKit

class CocktailViewController: UIViewController {
    
    
    @IBOutlet weak var tableView: UITableView!
    
    
    
    var listDrinksStatic : CocktailData?
    var listCocktail : CocktailData?
    
    var segue : UIStoryboardSegue?
    
    var cocktailManager = CocktailManager()
    var cocktailManagerDrink = CocktailManagerDrink()
    let drinksURL = "https://www.thecocktaildb.com/api/json/v1/1/filter.php?g=Cocktail_glass"
    let baseURLIdDrink = "https://www.thecocktaildb.com/api/json/v1/1/lookup.php?i="
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "CocktailCell", bundle: nil), forCellReuseIdentifier : "ReusableCell")
        tableView.rowHeight = 211.0
        tableView.backgroundColor = UIColor(red: 0.31, green: 0.30, blue: 0.73, alpha: 1.00)
        
        cocktailManager.delegate = self
        cocktailManagerDrink.delegate = self
        
        cocktailManager.performRequest(drinksURL)
        
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        self.segue = segue
    }
    
    
    
    @IBAction func search(_ sender: Any) {
        if(listDrinksStatic?.drinks.count == 1) {
            self.listDrinksStatic = listCocktail
            tableView.reloadData()
        } else{
            
            var textField = UITextField()
            
            
            let alert = UIAlertController(title: "Search a cocktail", message: "", preferredStyle: .alert)
            
            let action = UIAlertAction(title: "Search", style: .default) { (action) in
                
                if let drinkName = textField.text{
                    if let drink = self.returnDrink(drinkName){
                        let tragos : [Drink] = [drink]
                        let listDrinks = CocktailData(drinks: tragos)
                        
                        self.listDrinksStatic = listDrinks
                        self.tableView.reloadData()
                    }
                    
                }
            }
            
            alert.addAction(action)
            
            alert.addTextField { (field) in
                textField = field
                textField.placeholder = "Search a cocktail"
                
            }
            
            present(alert, animated: true, completion: nil)
        }
    }
    
    func returnDrink(_ drinkName : String) -> Drink? {
        if let drinks = listDrinksStatic?.drinks {
            for n in 0...drinks.count {
                if(drinks[n].strDrink.caseInsensitiveCompare(drinkName) == .orderedSame){
                    return drinks[n]
                }
            }
        }
        return nil
    }
    
    
}

extension CocktailViewController : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let idDrink = listDrinksStatic?.drinks[indexPath.row].idDrink {
            let urlIdDrink = "\(baseURLIdDrink)\(idDrink)"
            
            cocktailManagerDrink.callRequest(urlIdDrink, indexPath.row)
        }
        
        self.performSegue(withIdentifier: "goToDetails", sender: self)
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    
}

extension CocktailViewController : UITableViewDataSource {
    // es la cantidad de filas que tendra nuestra table
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let count = listDrinksStatic?.drinks.count {
            return count
        }
        return 0
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let drink = listDrinksStatic?.drinks[indexPath.row] else {
            return UITableViewCell()
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReusableCell", for : indexPath) as! CocktailCell
        cell.setUp(drink)
        return cell
    }
    
}
extension CocktailViewController : CocktailManagerDrinkDelegate {
    
    func didUpdateCocktail(_ cocktailManagerDrink: CocktailManagerDrink, _ drink : CocktailDataDrink) {
        
        DetailsViewController.drink = drink
        
        
        
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
    
}

extension CocktailViewController : CocktailManagerDelegate {
    
    func didUpdateCocktail(_ cocktailManager: CocktailManager, _ cocktailList : CocktailData) {
        listDrinksStatic = cocktailList
        listCocktail = cocktailList
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func didFailWithError(error: Error?) {
        print(error! as Any)
    }
    
}


