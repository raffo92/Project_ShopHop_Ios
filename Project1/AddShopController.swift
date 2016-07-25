//
//  addShopController.swift
//  Project1
//
//  Created by Raffaele P on 21/07/16.
//  Copyright © 2016 Gruppo2. All rights reserved.
//

import UIKit
import CoreLocation

class AddShopController: UIViewController, CLLocationManagerDelegate , UINavigationControllerDelegate, UIImagePickerControllerDelegate {

   
    @IBOutlet weak var shopNameLabel: UITextField!
    
    @IBOutlet weak var shopLocationLabelLat: UILabel!
    @IBOutlet weak var shopLocationLabelLng: UILabel!
    @IBOutlet weak var infoLocation: UILabel!

    
    var ratingStars = 0
    var namePhoto = ""
    
    @IBOutlet var shopImage : UIImageView!
    
    
    @IBOutlet weak var ratingStar1: UIButton!
    @IBOutlet weak var ratingStar2: UIButton!
    @IBOutlet weak var ratingStar3: UIButton!
    @IBOutlet weak var ratingStar4: UIButton!
    @IBOutlet weak var ratingStar5: UIButton!
  
    
 
    var ad: AppDelegate? = UIApplication.sharedApplication().delegate as? AppDelegate
    
    var locationManager = CLLocationManager ()

    let imagePicker = UIImagePickerController()
    
    
    
    //----------
    
    override func viewDidLoad() {

        super.viewDidLoad()
        imagePicker.delegate = self
        self.namePhoto = ""
        
        
    }
    
    override func viewWillAppear(animated: Bool) {
        
        if let coordinateFromMap = ad?.coordinateMap{
            self.shopLocationLabelLat.text = "\(coordinateFromMap.latitude)"
            self.shopLocationLabelLng.text = "\(coordinateFromMap.longitude)"
            
        }
        
        //Se coordinate settate da MAP
        if ad!.issetFromMap{
            self.infoLocation.text = "Posizione acquisita dall'utente"
            self.infoLocation.textColor = UIColor.blueColor()
        }
    }


    @IBAction func ratingButtonPress(sender: UIButton) {
        
        self.ratingStars = sender.tag
        
        var buttons = [self.ratingStar1, self.ratingStar2, self.ratingStar3, self.ratingStar4, self.ratingStar5]
        
        for i in 1...5 {
            
            if i <= sender.tag {
                if sender.tag == 1 && buttons[0].selected && !buttons[1].selected {
                    sender.selected = false
                }else{
                    buttons[i - 1].selected = true
                }
            } else {
                buttons[i - 1].selected = false
            }
        }
        
    }
 

    
    
    // MARK: - PositionGPS
    @IBAction func currentLocationPress (sender: UIButton) {
        
        
            self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
            
            self.locationManager.requestWhenInUseAuthorization()
            
            self.locationManager.delegate = self ;
            
            self.locationManager.startUpdatingLocation()
        
        //self.mapView.showsUserLocation = true
        
    }
    
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
        
        if let location = locations.last {
            self.shopLocationLabelLat.text = "\(location.coordinate.latitude)"
            self.shopLocationLabelLng.text = "\(location.coordinate.longitude)"
            self.infoLocation.text = "Posizione acquisita da GPS"
            self.infoLocation.textColor = UIColor.greenColor()
            
            self.locationManager.stopUpdatingLocation()
        }
    }
    
    
    
    // MARK: - Save
    
    @IBAction func saveButtonPress(sender: UIBarButtonItem) {
        
        let userDefaults = NSUserDefaults.standardUserDefaults()
        
        var currentDict : [String : AnyObject] = [:]
        
        currentDict["name"] = self.shopNameLabel.text == nil ? "NoName" : self.shopNameLabel.text 
        currentDict["totalExpense"] = 0
        currentDict["lat"] = self.shopLocationLabelLat.text == nil ? 0 : self.shopLocationLabelLat.text
        currentDict["lng"] = self.shopLocationLabelLng.text == nil ? 0 : self.shopLocationLabelLng.text
        currentDict["totalArticles"] = 0
        currentDict["rating"] = self.ratingStars
        
        if self.namePhoto == "" {
            currentDict["photo"] = "placeholder-150px"
        }else {
            currentDict["photo"] = self.namePhoto
        }
        
        currentDict["articles"] = nil
        
        //currentDict!["articles"] = [] //DICTIONARY
        
        ad!.dataShop!.insert(currentDict , atIndex: ad!.dataShop!.count)
      
        userDefaults.setObject(ad!.dataShop, forKey: "dataShop")
        
        userDefaults.synchronize()
     
        self.navigationController?.popViewControllerAnimated(true)
        
    }

     
     @IBAction func loadImageButtonTapped(sender: UIButton) {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .PhotoLibrary
     
        presentViewController(imagePicker, animated: true, completion: nil)
     }
     
     
     // MARK: Delegate
     func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.shopImage.contentMode = .ScaleAspectFit
            self.shopImage.image = pickedImage
            
            let namePhoto = NSDate()
            
            self.namePhoto = "\(namePhoto)"
            
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
     

    
    // MARK: - Segue
    
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if(segue.identifier == "showMap"){
            var mp = MapPickerController()
            mp = segue.destinationViewController as! MapPickerController
            
        }
        
        
    }
    
}
