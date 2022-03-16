//
//  MessageCell.swift
//  Flash Chat iOS13
//
//  Created by Valentina Olariaga on 18/2/22.
//  Copyright © 2022 Angela Yu. All rights reserved.
//

import UIKit
import Kingfisher

class CocktailCell: UITableViewCell {
    
    @IBOutlet weak var view: UIView!
    
    //@IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var cocktailImage: UIImageView!
    @IBOutlet weak var cocktailName: UILabel!
 
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.view.layer.cornerRadius = self.view.frame.size.height / 45
     }
    
    func setUp (_ drink : Drink) {
        let name = drink.strDrink
        let imageStr = drink.strDrinkThumb
        let url = URL(string : imageStr)!
        cocktailName.text = name
        cocktailImage.kf.setImage(with: url)
        
       }
    
    
    
}
