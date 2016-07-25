//
//  addArticles.swift
//  Project1
//
//  Created by Raffaele P on 24/07/16.
//  Copyright © 2016 Gruppo2. All rights reserved.
//

import UIKit
import CoreData

class addArticles: UIViewController, UITextFieldDelegate {

    
    var ad: AppDelegate? = UIApplication.sharedApplication().delegate as? AppDelegate
    
    let imagePicker = UIImagePickerController()
    
    var imageName : String = ""
    
    @IBOutlet weak var articleName: UITextField!
    @IBOutlet weak var articlePrice: UITextField!
    @IBOutlet weak var articleDate: UIDatePicker?
    @IBOutlet weak var articleImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        articlePrice.delegate = self
        articlePrice.keyboardType = .NumbersAndPunctuation
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func loadImageButtonTapped(sender: UIButton) {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .PhotoLibrary
        
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    
    // MARK: Delegate
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.articleImage.contentMode = .ScaleAspectFit
            self.articleImage.image = pickedImage
            
            let namePhoto = NSDate()
            
            self.imageName = "\(namePhoto)"
            
            self.saveImage(pickedImage, fileName: "\(namePhoto)")
        }
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func saveImage (image: UIImage, fileName: String ) -> Bool{
        
        let pngImageData = UIImagePNGRepresentation(image)
        
        let imagePath = ad?.fileInCacheDirectory(fileName)
        //print(imagePath)
        
        let result = pngImageData!.writeToFile(imagePath!, atomically: true)
        
        return result
    }

    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        let invalidCharacters = NSCharacterSet(charactersInString: "0123456789.").invertedSet
        
        //textField.text?.containsString(",") || textField.text?.containsString(".")
        
        return string.rangeOfCharacterFromSet(invalidCharacters, options: [], range: string.startIndex ..< string.endIndex) == nil
    }
    
    // MARK: - Save
    
    @IBAction func saveButtonPress(sender: UIBarButtonItem) {
        
        let userDefaults = NSUserDefaults.standardUserDefaults()
        
        var newArticle : [String : AnyObject] = [:]
        
        newArticle["name"] = self.articleName.text == nil ? "NoName" : self.articleName.text
        
        let number = self.articlePrice.text!
        let numberCharacters = NSCharacterSet(charactersInString: "0123456789.").invertedSet
        print(number.rangeOfCharacterFromSet(numberCharacters))
        if !number.isEmpty && number.rangeOfCharacterFromSet(numberCharacters) == nil {
            let numberFormatter = NSNumberFormatter()
            numberFormatter.numberStyle = NSNumberFormatterStyle.DecimalStyle
            newArticle["price"] = numberFormatter.numberFromString(number)
        } else {
            newArticle["price"] = 0
        }
        
        if self.articleImage == nil {
            newArticle["photo"] = "placeholder-150px"
        }else {
            newArticle["photo"] = self.imageName
        }
        
        newArticle["date"] = self.articleDate?.date
        

        if let articles = ad!.dataShop![ad!.indexDataShop]["articles"] as? [[String:AnyObject]]{
            var articlesFinal = articles
            articlesFinal.append(newArticle)
            ad!.dataShop![ad!.indexDataShop]["articles"] = articlesFinal
        }else{
            ad!.dataShop![ad!.indexDataShop]["articles"] = [newArticle]
        }
        
//        let articles = ad!.dataShop![ad!.indexDataShop]["articles"] as! [[String:AnyObject]]
//        
//        print(articles)
        
        
        let currentArticles = ad!.dataShop![ad!.indexDataShop]["totalArticles"] as! Int
        ad!.dataShop![ad!.indexDataShop]["totalArticles"] = currentArticles + 1
        let currentExpense = ad!.dataShop![ad!.indexDataShop]["totalExpense"] as! Float
        let newPrice = newArticle["price"] as! Float
        ad!.dataShop![ad!.indexDataShop]["totalExpense"] = currentExpense + newPrice
        
        userDefaults.setObject(ad!.dataShop, forKey: "dataShop")
        
        userDefaults.synchronize()
        
        print(ad!.dataShop)
        
        self.navigationController?.popViewControllerAnimated(true)
        
    }

    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
