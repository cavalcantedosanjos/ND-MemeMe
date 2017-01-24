//
//  MemeTableViewCell.swift
//  MemeMe
//
//  Created by Joao Anjos on 24/01/17.
//  Copyright © 2017 Joao Anjos. All rights reserved.
//

import UIKit

class MemeTableViewCell: UITableViewCell {


    @IBOutlet weak var memeImageView: UIImageView!
    @IBOutlet weak var messageLabel: UILabel!

    func setup(meme: Meme) {
        self.memeImageView.image = meme.originalImage
        self.messageLabel.text = "\(meme.topText) \(meme.bottomText)"
    }

}
