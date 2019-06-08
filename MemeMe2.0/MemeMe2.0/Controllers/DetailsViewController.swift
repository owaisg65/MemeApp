//
//  DetailsViewController.swift
//  MemeApp2.0
//
//  Created by Owais Gaffas on 26/04/2019.
//  Copyright © 2019 Udacity. All rights reserved.
//

import UIKit


class DetailsViewController : UIViewController{

    
    
    @IBOutlet weak var memeImage: UIImageView!
    
    
    var meme : Meme!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
         memeImage.image = meme.memedImage
    }
}
