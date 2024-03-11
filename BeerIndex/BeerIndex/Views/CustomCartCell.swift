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
    
    var onAddButtonTapped: (() -> Void)?
    var onRemoveButtonTapped: (() -> Void)?
    
    @IBAction func addAmountBeer(_ sender: UIButton) {
        onAddButtonTapped?()
    }
    
    @IBAction func removeAmountBeer(_ sender: Any) {
        onRemoveButtonTapped?()
    }
    static let identifier = "CustomCartCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "CustomCartCell", bundle: nil)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.layer.cornerRadius = 10
        self.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
