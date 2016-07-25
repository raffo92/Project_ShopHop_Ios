//
//  ViewArticleController.swift
//  Project1
//
//  Created by Artoo on 23/07/16.
//  Copyright © 2016 Gruppo2. All rights reserved.
//

import UIKit

class ViewArticleController: UITableViewController {
    
    var ad: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    
    @IBOutlet weak var shopNameLabel: UILabel!

    @IBOutlet weak var totalLabel: UILabel!
    
    @IBOutlet weak var shopImage: UIImageView!
    
    let userDefaults = NSUserDefaults.standardUserDefaults()
    
    
//    var currentShop: [String : AnyObject] =
//        [
//            "name":"H&M",
//            "totalExpense":85.50,
//            "lat":19.689,
//            "lng":13.590,
//            "totalArticles":2,
//            "rating":3,
//            "photo":"placeholder-150px",
//            "articles": [
//                [
//                    "name":"shoes",
//                    "price": 50.00,
//                    "date": NSDate()
//                ], [
//                    "name":"T-shit",
//                    "price": 35.50,
//                    "date": NSDate(),
//                ]
//            ]]
    

    var articleArray: [[String : AnyObject]]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        /*
        let rightBarButton = UIBarButtonItem(
            title: "Edit Shop",
            style: .Plain,
            target: self,
            action: #selector(editShop(_:))
        )
 
        self.navigationItem.setRightBarButtonItem(rightBarButton, animated: false)
        
        //self.navigationItem.rightBarButtonItem = self.editButtonItem()
         */
    }

    override func viewWillAppear(animated: Bool) {
        
        //Load DATA
        if (userDefaults.objectForKey("dataShop") != nil){
            ad.dataShop = userDefaults.objectForKey("dataShop") as? [[String:AnyObject]]
            self.articleArray = ad.dataShop![ad.indexDataShop]["articles"] as? [[String:AnyObject]]
            self.tableView.reloadData()
        }


        let shopName = ad.dataShop![ad.indexDataShop]["name"] as! String
        self.shopNameLabel.text = "\(shopName)"
        
        //Formatter Prezzo
        let formatterMoney = NSNumberFormatter()
        formatterMoney.numberStyle = .CurrencyStyle
        formatterMoney.locale = NSLocale(localeIdentifier: "es_ES")
        self.totalLabel.text = formatterMoney.stringFromNumber( ad.dataShop![ad.indexDataShop]["totalExpense"] as! Float)

        
        let fileName = ad.dataShop![ad.indexDataShop]["photo"] as? String
        
        //Controllo se l'utente ha caricato la foto
        if fileName == "placeholder-150px" {
            self.shopImage.image = UIImage(named: ad.dataShop![ad.indexDataShop]["photo"] as! String)
        }else{
            self.shopImage.image = ad.loadImageFromPath(fileName!)
        }
        
    }
    
    
    func editShop(sender: UIBarButtonItem) {
        
    }
    
    
    
    
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            
            let totalExp = ad.dataShop![ad.indexDataShop]["totalExpense"] as! Float
            let price = self.articleArray![indexPath.row]["price"] as! Float
            
            let newExpense = totalExp - price
            self.totalLabel.text = "\(newExpense) €"
            let newNumArt = (ad.dataShop![ad.indexDataShop]["totalArticles"] as! Int) - 1
            ad.dataShop![ad.indexDataShop]["totalArticles"] = newNumArt
            ad.dataShop![ad.indexDataShop]["totalExpense"] = newExpense
            self.articleArray!.removeAtIndex(indexPath.row)
            ad.dataShop![ad.indexDataShop]["articles"] = self.articleArray
            userDefaults.setObject(ad.dataShop, forKey: "dataShop")
            self.tableView.reloadData()
            
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    // MARK: - Table view data source

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.articleArray == nil ? 0 : self.articleArray!.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> ViewArticleCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cellArticle", forIndexPath: indexPath) as! ViewArticleCell

        // Configure the cell...
        
        if self.articleArray!.count > 0{
            
            let dict = self.articleArray![indexPath.row] as [String : AnyObject]
            let formatterDate = NSDateFormatter()
            formatterDate.dateFormat =  "dd MMM yyyy"
            
            //Formatter Date
            cell.articleNameLabel.text = dict["name"] as? String
            cell.articleDateLabel.text = formatterDate.stringFromDate(dict["date"] as! NSDate)
            
            //Formatter Prezzo
            let formatterMoney = NSNumberFormatter()
            formatterMoney.numberStyle = .CurrencyStyle
            formatterMoney.locale = NSLocale(localeIdentifier: "es_ES")
            cell.articlePriceLabel!.text = "\(dict["price"]!) €"

            
        }
        
        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
