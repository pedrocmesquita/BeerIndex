//
//  CustomCartCell.swift
//  BeerIndex
//
//  Created by ITSector on 10/03/2024.
//

import UIKit

class CustomCartCell: UITableViewCell {
    
    @IBOutlet weak var nameBeer: UILabel!
    @IBOutlet weak var customImageView: UIImageView!
    
    @IBOutlet weak var amountBeer: UILabel!
    
    @IBAction func addAmountBeer(_ sender: UIButton) {
    }
    
    @IBAction func removeAmountBeer(_ sender: Any) {
    }
    static let identifier = "CustomCartTableViewCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "CustomCartTableViewCell", bundle: nil)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
