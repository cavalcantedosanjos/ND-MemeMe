//
//  MemeDetailViewController.swift
//  MemeMe
//
//  Created by Joao Anjos on 24/01/17.
//  Copyright © 2017 Joao Anjos. All rights reserved.
//

import UIKit

class MemeDetailViewController: UIViewController {

    // MARK: - Properties
    @IBOutlet weak var imageViewMeme: UIImageView!
    var meme: Meme?
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let memedImage = meme?.memedImage {
            imageViewMeme.image = memedImage
        }
        
    }

}
