//
//  SentMemesTableViewController.swift
//  MemeMe_2.0
//
///  Created by Rana Omar on 04/06/1440 AH.
//  Copyright © 1440 Rana Aljasser. All rights reserved.
//

import UIKit

    class SentMemesTableViewController: UITableViewController, UIViewControllerTransitioningDelegate {
    
    var memes: [MemeObject] {
        return (UIApplication.shared.delegate as! AppDelegate).memes
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let meme = memes[(indexPath as NSIndexPath).row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "MemeTableViewCell", for: indexPath) as! MemeTableViewCell
        cell.cellLabel.text = "\(meme.topText!) ... \(meme.bottomText!)"
        cell.memeImageView.image = meme.memedImage
        
        return cell
    }
    
   
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailViewController = storyboard?.instantiateViewController(withIdentifier: "MemesDetailViewController") as! MemesDetailViewController
        detailViewController.meme = memes[(indexPath as NSIndexPath).row]
        navigationController!.pushViewController(detailViewController, animated: true)
    }
    
    override var prefersStatusBarHidden : Bool {
        return true
    }

}
