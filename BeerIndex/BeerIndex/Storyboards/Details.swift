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
    
    @IBOutlet weak var scrollView: UIScrollView!
    var shoppingCart = MyItens.shared.shoppingCart
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
        
        scrollView.contentSize = CGSizeMake(self.view.frame.width, self.view.frame.height+30)
        // URL to Image
        /*if let imageURLstring = beer?.image_url{
            if let imageURL = URL(string: imageURLstring){
                
                DispatchQueue.global(qos: .userInitiated).async {
                    
                    if let imageData = try? Data(contentsOf: imageURL) {
                        DispatchQueue.main.async {
                            self.imageView.image = UIImage(data: imageData)
                        }
                    }
                }
            }
        }*/
        
        if let imageURLstring = beer?.image_url, let imageURL = URL(string: imageURLstring) {
            URLSession.shared.dataTask(with: imageURL) { (data, response, error) in
                if let data = data, let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self.imageView.image = image
                    }
                } else {
                    print("Failed to load image:", error?.localizedDescription ?? "Unknown error")
                }
            }.resume()
        }

        
        // Image shadow and corners
        imageView.layer.cornerRadius = 5
        imageView.layer.masksToBounds = false
        imageView.layer.shadowColor = UIColor.gray.cgColor
        imageView.layer.shadowOffset = CGSize(width: 0.0, height: 4.0)
        imageView.layer.shadowOpacity = 0.2
        imageView.layer.shadowRadius = 4.0
        
        // DESCRIPTION
        
        let description = NSMutableAttributedString(string: "")
        let attrs = [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: UIFont.systemFontSize)]
        let boldString = NSAttributedString(string: "Description: ", attributes: attrs)
        description.append(boldString)
        
        if let beerDescription = beer?.description {
            let descriptionAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: UIFont.systemFontSize)]
            let descriptionString = NSAttributedString(string: "\(beerDescription)", attributes: descriptionAttributes)
            description.append(descriptionString)
        }
        
        thirdLabel.attributedText = description
        
        // VOLUME
        
        let volume = NSMutableAttributedString(string: "")
        let boldString3 = NSAttributedString(string: "Volume: ", attributes: attrs)
        volume.append(boldString3)
        
        if let beerUnit = beer?.volume?.value, let beerValue = beer?.volume?.unit {
            let volumeAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: UIFont.systemFontSize)]
            let volumeString = NSAttributedString(string: "\(beerUnit) \(beerValue)", attributes: volumeAttributes)
            volume.append(volumeString)
        }
        
        fourthLabel.attributedText = volume
        
        // FIRST BREWED
        
        let since = NSMutableAttributedString(string: "")
        let boldString2 = NSAttributedString(string: "First Brewed in: ", attributes: attrs)
        since.append(boldString2)
        
        if let beerSince = beer?.first_brewed {
            let sinceAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: UIFont.systemFontSize)]
            let sinceString = NSAttributedString(string: "\(beerSince)", attributes: sinceAttributes)
            since.append(sinceString)
        }
        
        fifthLabel.attributedText = since
        
    }
    
    // Message saying item added successfully (toast)
    func showToast(message : String, font: UIFont) {
        let toastLabel = UILabel()
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.font = font
        toastLabel.textAlignment = .center
        toastLabel.text = message
        toastLabel.numberOfLines = 0
        toastLabel.alpha = 0.0
        toastLabel.layer.cornerRadius = 10
        toastLabel.clipsToBounds = true
        self.view.addSubview(toastLabel)

        toastLabel.frame = CGRect(x: self.view.frame.size.width / 2 - 100,
                                  y: self.view.frame.size.height - 150, width: 200, height: 50)

        UIView.animate(withDuration: 2.5, delay: 0.1, options: .curveEaseOut, animations: {
             toastLabel.alpha = 1.0
        }, completion: {(isCompleted) in
            UIView.animate(withDuration: 1.0, animations: {
                toastLabel.alpha = 0.0
            }, completion: { _ in
                toastLabel.removeFromSuperview()
            })
        })
    }


    @IBAction func addBeerButton(_ sender: Any) {
        shoppingCart.addItem(beer!)
        self.showToast(message: "Item added to your cart successfully!", font: .systemFont(ofSize: 14.0))
    }
}
