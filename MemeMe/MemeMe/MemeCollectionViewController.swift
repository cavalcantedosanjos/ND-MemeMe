//
//  MemeCollectionViewController.swift
//  MemeMe
//
//  Created by Joao Anjos on 24/01/17.
//  Copyright © 2017 Joao Anjos. All rights reserved.
//

import UIKit

private let reuseIdentifier = "memeCell"

class MemeCollectionViewController: UICollectionViewController {

    // MARK: - Properties
    
    @IBOutlet weak var collectionViewFlowLayout: UICollectionViewFlowLayout!
    
    var memes = [Meme]()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        memes = (UIApplication.shared.delegate as! AppDelegate).memes
        collectionView?.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueMemeDetail" {
            let vc = segue.destination as! MemeDetailViewController
            vc.meme = sender as? Meme
        }
    }
    
    // MARK: - Helpers
    
    func setup() {
        let space:CGFloat = 3.0
        let dimension = (self.view.frame.size.width - (2 * space)) / 3.0
        
        collectionViewFlowLayout.minimumInteritemSpacing = space
        collectionViewFlowLayout.minimumLineSpacing = space
        collectionViewFlowLayout.itemSize = CGSize(width: dimension, height: dimension)
    }
    
    // MARK: - UICollectionView
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memes.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! MemeCollectionViewCell
        cell.setup(meme: memes[indexPath.row])
        return cell
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "segueMemeDetail", sender: memes[indexPath.row])
    }
}
