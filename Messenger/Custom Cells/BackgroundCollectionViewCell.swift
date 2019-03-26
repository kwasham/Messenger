//
//  BackgroundCollectionViewCell.swift
//  Messenger
//
//  Created by Kirk Washam on 3/24/19.
//  Copyright © 2019 StudioATX. All rights reserved.
//

import UIKit

class BackgroundCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
    func generateCell(image: UIImage) {
        self.imageView.image = image
    }
}
