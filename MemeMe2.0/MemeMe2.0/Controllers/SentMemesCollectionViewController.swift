//
//  CollectionViewController.swift
//  MemeApp2.0
//
//  Created by Owais Gaffas on 22/04/2019.
//  Copyright © 2019 Udacity. All rights reserved.
//

import UIKit



class SentMemesCollectionViewController :  UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
 
    @IBOutlet weak var CollectionView: UICollectionView!
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    var memes: [Meme]! {
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
         return appDelegate.meme
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let space:CGFloat = 3.0
        let dimension = (view.frame.size.width - (2 * space)) / 3.0
        
        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSize(width: dimension, height: dimension)
        
        CollectionView!.reloadData()
    }
    
     func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memes.count
    }
    
     func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! CollectionViewCell
        let meme = memes[(indexPath as NSIndexPath).row]
        
        cell.memeImage.image = meme.memedImage
        cell.tag = indexPath.row
        
        return cell
    }
    
     func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        self.performSegue(withIdentifier: "C2Details", sender: collectionView.cellForItem(at: indexPath))
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "C2Details"){
            let controller = segue.destination as! DetailsViewController
            let cell = sender as! UICollectionViewCell
            let meme : Meme = memes[cell.tag]
            controller.meme = meme
        }
    }
    
}

