//
//  MemeTableViewController.swift
//  MemeMe
//
//  Created by Joao Anjos on 24/01/17.
//  Copyright © 2017 Joao Anjos. All rights reserved.
//

import UIKit

class MemeTableViewController: UITableViewController {

    // MARK: - Properties
    var memes = [Meme]()
    
    // MARK: - Life Cycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        memes = (UIApplication.shared.delegate as! AppDelegate).memes
        tableView.reloadData()
    }

    // MARK: - Table view
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "memeCell") as! MemeTableViewCell
        cell.setup(meme: memes[indexPath.row])
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "segueMemeDetail", sender: memes[indexPath.row])
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueMemeDetail" {
            let vc = segue.destination as! MemeDetailViewController
            vc.meme = sender as? Meme
        }
    }

}
