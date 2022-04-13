//
//  CocktailViewController.swift
//  Cocktail Challenge
//
//  Created by Valentina Olariaga on 9/3/22.
//

import UIKit

class CocktailViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var listDrinksStatic, listDrink : CocktailData?
    var segue : UIStoryboardSegue?
    var selectedDrink:  Drink? = nil
    var cocktailManager = CocktailManager()
    var cocktailManagerDrink = CocktailManagerDrink()
    let drinksURL = "https://www.thecocktaildb.com/api/json/v1/1/filter.php?g=Cocktail_glass"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "CocktailCell", bundle: nil), forCellReuseIdentifier : "ReusableCell")
        tableView.rowHeight = 211.0
        tableView.backgroundColor = UIColor(red: 0.31, green: 0.30, blue: 0.73, alpha: 1.00)
        cocktailManager.delegate = self
        cocktailManager.performRequest(drinksURL)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! DetailsViewController
        destinationVC.drink = selectedDrink
    }
    
    @IBAction func search(_ sender: Any) {
        if (listDrinksStatic?.drinks.count == 1) {
            self.listDrinksStatic = listDrink
            tableView.reloadData()
        } else {
            var textField = UITextField()
            let alert = UIAlertController(title: "Search a cocktail", message: "", preferredStyle: .alert)
            let action = UIAlertAction(title: "Search", style: .default) { (action) in
                if let drinkName = textField.text {
                    if let drink = self.listDrinksStatic?.drinks.first(where: { cocktail -> Bool in
                        return cocktail.strDrink.caseInsensitiveCompare(drinkName) == .orderedSame
                    })
                    {
                        self.listDrinksStatic = CocktailData(drinks : [drink])
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
}

extension CocktailViewController : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let drink = listDrinksStatic?.drinks[indexPath.row] {
            selectedDrink = drink
            tableView.deselectRow(at: indexPath, animated: true)
            performSegue(withIdentifier: "goToDetails", sender: self)
        }
    }
}

extension CocktailViewController : UITableViewDataSource {
    
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

extension CocktailViewController : CocktailManagerDelegate {
    
    func didUpdateCocktail(_ cocktailManager: CocktailManager, _ cocktailList : CocktailData) {
        listDrinksStatic = cocktailList
        listDrink = cocktailList
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func didFailWithError(error: Error?) {
        print(error! as Any)
    }
    
}


