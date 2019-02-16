//
//  SentMemesCollectionViewController.swift
//  MemeMe_2.0
//
//  Created by Rana Omar on 04/06/1440 AH.
//  Copyright © 1440 Rana Aljasser. All rights reserved.
//

import UIKit

    class SentMemesCollectionViewController: UICollectionViewController {
        
    @ IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
        
    var memes: [MemeObject] {
            return (UIApplication.shared.delegate as! AppDelegate).memes
        }
        
    override func viewDidLoad() {
        super.viewDidLoad()
            
        flowLayout.minimumInteritemSpacing = 1
        flowLayout.minimumLineSpacing = 1
        flowLayout.itemSize = CGSize(width: (view.frame.size.width / 4) - 1, height: view.frame.size.width / 4)
    }
        

    override func viewDidAppear(_ animated: Bool) {
            collectionView!.reloadData()
        }
        
    //Set up Collection View
     
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memes.count
        }
        
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let meme = memes[(indexPath as NSIndexPath).row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MemeCollectionViewCell", for: indexPath) as! MemeCollectionViewCell
        cell.memeImageView.image = meme.memedImage
        cell.memeImageView.contentMode = UIView.ContentMode.scaleAspectFill
        return cell
    }

    
        
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailViewController = storyboard?.instantiateViewController(withIdentifier: "MemesDetailViewController") as! MemesDetailViewController
        detailViewController.meme = memes[(indexPath as NSIndexPath).row]
        navigationController!.pushViewController(detailViewController, animated: true)
    }
 
    override var prefersStatusBarHidden : Bool {
        return true
    }
        
}



