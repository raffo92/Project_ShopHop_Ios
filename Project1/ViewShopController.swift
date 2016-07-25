//
//  ViewListController.swift
//  Project1
//
//  Created by Raffaele P on 21/07/16.
//  Copyright © 2016 Gruppo2. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ViewShopController: UITableViewController {
    
    var ad: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
   
    let userDefaults = NSUserDefaults.standardUserDefaults()

    
    var shopArray : [[String : AnyObject]] =
        [
            [
            "name":"H&M",
            "totalExpense":85.50,
            "lat":19.689,
            "lng":13.590,
            "totalArticles":2,
            "rating":3,
            "photo":"placeholder-150px",
            "articles": [
                    [
                        "name":"shoes",
                        "price": 50.00,
                        "date": NSDate()
                    ], [
                        "name":"T-shit",
                        "price": 35.50,
                        "date": NSDate(),
                        ]
                    ]
            ]
        ]
    
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        //userDefaults.setObject(self.shopArray, forKey: "dataShop")
    }


    
    override func viewWillAppear(animated: Bool) {
        
        //Load DATA
        if (userDefaults.objectForKey("dataShop") != nil){
            ad.dataShop = userDefaults.objectForKey("dataShop") as! [[String:AnyObject]]
            self.shopArray = ad.dataShop!
            self.tableView.reloadData()
        }else{
            ad.dataShop = self.shopArray
            self.tableView.reloadData()
        }
        
        
    }
    
    
    
    
    // MARK: - Table view data source

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.shopArray.count
    }

    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            //tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            
            //tableView.ann
            self.shopArray.removeAtIndex(indexPath.row)
            ad.dataShop = self.shopArray
            userDefaults.setObject(ad.dataShop, forKey: "dataShop")
            
            self.tableView.reloadData()
 
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    
    /*
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if (editingStyle == UITableViewCellEditingStyle.Delete) {
            
            self.shopArray.removeAtIndex(indexPath.row)
            ad.dataShop = self.shopArray
            userDefaults.setObject(ad.dataShop, forKey: "dataShop")
            self.tableView.reloadData()
           
        }
    
    }
    */
    
    //Popola Campi Cell
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> ViewShopCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! ViewShopCell
        
       
            //Setto Celle
            cell.shopNameCell.text = shopArray[indexPath.row]["name"] as? String
        
            //Formatter Prezzo
            let formatterMoney = NSNumberFormatter()
            formatterMoney.numberStyle = .CurrencyStyle
            formatterMoney.locale = NSLocale(localeIdentifier: "es_ES")
            cell.shopPriceCell.text = "Total: " + formatterMoney.stringFromNumber(shopArray[indexPath.row]["totalExpense"] as! Float)!
        
            cell.shopNumberArtCell.text = "Articles: " + "\(shopArray[indexPath.row]["totalArticles"] as! Int)"
        
            cell.shopStars.text = "\(shopArray[indexPath.row]["rating"]!)"
        
        
        let fileName = shopArray[indexPath.row]["photo"] as? String
        
        //Controllo se l'utente ha caricato la foto
        if fileName == "placeholder-150px" {
            cell.shopImageCell.image = UIImage(named: shopArray[indexPath.row]["photo"] as! String)
        }else{
            cell.shopImageCell.image = ad.loadImageFromPath(fileName!)
        }
        
      // Setto il Frame dell Image a circle
      cell.shopImageCell.layer.masksToBounds = true
      cell.shopImageCell.layer.cornerRadius = cell.shopImageCell.frame.height/2
    
        return cell
    }
 
    @IBAction func addShop(sender: UIButton) {
         self.performSegueWithIdentifier("addShop", sender: self)
    }
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        ad.currentDataShop = self.shopArray[indexPath.row]
        ad.indexDataShop = indexPath.row
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if(segue.identifier == "addShop"){
            
            var addS = AddShopController()
            addS = segue.destinationViewController as! AddShopController
            ad.issetFromMap = false
            let coordinateDefault = CLLocationCoordinate2D()
            ad.coordinateMap = coordinateDefault
        }
        
        if (segue.identifier == "shopDetail") {
            //print("entra")
        }
        
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
}
