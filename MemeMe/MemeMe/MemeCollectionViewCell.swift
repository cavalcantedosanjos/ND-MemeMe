//
//  MemeCollectionViewCell.swift
//  MemeMe
//
//  Created by Joao Anjos on 24/01/17.
//  Copyright © 2017 Joao Anjos. All rights reserved.
//

import UIKit

class MemeCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var memeImageView: UIImageView!

    func setup(meme: Meme) {
        self.memeImageView.image = meme.memedImage
    }
}
