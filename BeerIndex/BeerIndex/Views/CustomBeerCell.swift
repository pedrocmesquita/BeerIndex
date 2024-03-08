//
//  CustomBeeerCell.swift
//  BeerIndex
//
//  Created by itsector on 08/03/2024.
//

import Foundation
import UIKit

class CustomBeerCell: UICollectionViewCell{
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var labelView: UILabel!
    @IBOutlet weak var idView: UILabel!
    
    override func awakeFromNib() {
            super.awakeFromNib()
            setupUI()
        }
        
        private func setupUI() {
            imageView.contentMode = .scaleAspectFit
            labelView.textAlignment = .center
            labelView.font = UIFont.boldSystemFont(ofSize: 19)
            idView.font = UIFont.systemFont(ofSize: 15)
            
            
            self.layer.cornerRadius = 5
            self.layer.masksToBounds = false
            
            self.layer.shadowColor = UIColor.gray.cgColor
            self.layer.shadowOffset = CGSize(width: 0.0, height: 4.0)
            self.layer.shadowOpacity = 0.2
            self.layer.shadowRadius = 4.0
        }
        
        func configure(with beer: Beer) {
            labelView.text = beer.name
            // meter isto dentro de um método e fazer cache da imagem
            if let imageURLString = beer.image_url, let imageURL = URL(string: imageURLString) {
                DispatchQueue.global(qos: .userInitiated).async {
                    if let imageData = try? Data(contentsOf: imageURL) {
                        DispatchQueue.main.async {
                            self.imageView.image = UIImage(data: imageData)
                        }
                    }
                }
            }
            
            if let text = beer.id {
                idView.text = "\(text)"
            }
        }
    
}


