//
//  MemesDetailViewController.swift
//  MemeMe_2.0
//
//  Created by Rana Omar on 04/06/1440 AH.
//  Copyright © 1440 Rana Aljasser. All rights reserved.
//

import UIKit

    class MemesDetailViewController: UIViewController {

    var meme: MemeObject! = nil
 
    @IBOutlet weak var memeImageView: UIImageView!
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated) 
        memeImageView.image = meme.memedImage
    }

    
    override var prefersStatusBarHidden : Bool {
        return true
    }

}
