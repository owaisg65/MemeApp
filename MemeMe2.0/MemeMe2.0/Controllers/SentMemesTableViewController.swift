//
//  SentMemesTableViewController.swift
//  MemeApp2.0
//
//  Created by Owais Gaffas on 22/04/2019.
//  Copyright © 2019 Udacity. All rights reserved.
//


import UIKit

class sentMemesTableViewController : UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var tableView: UITableView!
    var memes: [Meme]!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        memes = appDelegate.meme
        tableView?.reloadData()
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  memes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableCell")!
        let meme = memes[(indexPath as NSIndexPath).row]
        
        
        cell.imageView?.image = meme.memedImage
        cell.textLabel?.text = "\(meme.top.prefix(9)) ... \(meme.bottom.suffix(9))"
        cell.tag = indexPath.row
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "T2Details", sender: tableView.cellForRow(at: indexPath))
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "T2Details"){
            let controller = segue.destination as! DetailsViewController
            let cell = sender as! UITableViewCell
            let meme : Meme  = memes[cell.tag]
            controller.meme = meme
            
        }
        
    }
    
    
}

