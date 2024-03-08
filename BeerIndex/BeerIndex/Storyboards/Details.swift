//
//  Details.swift
//  BeerIndex
//
//  Created by itsector on 08/03/2024.
//

import Foundation
import UIKit

class Details: UIViewController{
    @IBOutlet weak var firstLabel: UILabel!
    @IBOutlet weak var secondLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var thirdLabel: UILabel!
    @IBOutlet weak var fourthLabel: UILabel!
    @IBOutlet weak var fifthLabel: UILabel!
    
    var beer: Beer?
    
    override func viewDidLoad() {
        
        // Name and ID
        firstLabel.text = beer?.name
        if let label2 = beer?.id {
            secondLabel.text = "\(label2)"
        }
        firstLabel.textAlignment = .center
        firstLabel.font = UIFont.boldSystemFont(ofSize: 30)
        secondLabel.font = UIFont.systemFont(ofSize: 20)
        
        // URL to Image
        if let imageURLstring = beer?.image_url{
            if let imageURL = URL(string: imageURLstring){
                
                DispatchQueue.global(qos: .userInitiated).async {
                    
                    if let imageData = try? Data(contentsOf: imageURL) {
                        DispatchQueue.main.async {
                            self.imageView.image = UIImage(data: imageData)
                        }
                    }
                }
            }
        }
        
        // Image shadow and corners
        imageView.layer.cornerRadius = 5
        imageView.layer.masksToBounds = false
        imageView.layer.shadowColor = UIColor.gray.cgColor
        imageView.layer.shadowOffset = CGSize(width: 0.0, height: 4.0)
        imageView.layer.shadowOpacity = 0.2
        imageView.layer.shadowRadius = 4.0
        
        // DESCRIPTION
        
        var description = NSMutableAttributedString(string: "")
        var attrs = [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: UIFont.systemFontSize)]
        var boldString = NSAttributedString(string: "Description: ", attributes: attrs)
        description.append(boldString)
        
        if let beerDescription = beer?.description {
            let descriptionAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: UIFont.systemFontSize)]
            let descriptionString = NSAttributedString(string: "\(beerDescription)", attributes: descriptionAttributes)
            description.append(descriptionString)
        }
        
        thirdLabel.attributedText = description
        
        // VOLUME
        
        var volume = NSMutableAttributedString(string: "")
        var boldString3 = NSAttributedString(string: "Volume: ", attributes: attrs)
        volume.append(boldString3)
        
        if let beerUnit = beer?.volume?.value, let beerValue = beer?.volume?.unit {
            let volumeAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: UIFont.systemFontSize)]
            let volumeString = NSAttributedString(string: "\(beerUnit) \(beerValue)", attributes: volumeAttributes)
            volume.append(volumeString)
        }
        
        fourthLabel.attributedText = volume
        print(volume)
        
        // FIRST BREWED
        
        var since = NSMutableAttributedString(string: "")
        var boldString2 = NSAttributedString(string: "First Brewed in: ", attributes: attrs)
        since.append(boldString2)
        
        if let beerSince = beer?.first_brewed {
            let sinceAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: UIFont.systemFontSize)]
            let sinceString = NSAttributedString(string: "\(beerSince)", attributes: sinceAttributes)
            since.append(sinceString)
        }
        
        fifthLabel.attributedText = since
        
        
        
    }
}
