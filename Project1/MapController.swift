//
//  MapController.swift
//  Project1
//
//  Created by Raffaele P on 23/07/16.
//  Copyright © 2016 Gruppo2. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapController: UIViewController, CLLocationManagerDelegate {
    
    var ad: AppDelegate? = UIApplication.sharedApplication().delegate as? AppDelegate
    
    @IBOutlet weak var mapView: MKMapView!
    
    var locationManager = CLLocationManager ()
    var initMap = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        
        //Rimuovo all Annotations
        let annotationsToRemove = mapView.annotations.filter { $0 !== mapView.userLocation }
        mapView.removeAnnotations( annotationsToRemove )
        
        if let shops = ad?.dataShop {
            
            for shop in shops{
                
                let annotation = MKPointAnnotation()
                
                let numberFormatter = NSNumberFormatter()
                let numberLat = numberFormatter.numberFromString("\(shop["lat"]!)") as! Double
                let numberLng = numberFormatter.numberFromString("\(shop["lng"]!)") as! Double
                
                var coordinates = CLLocationCoordinate2D()
                coordinates.latitude = numberLat
                coordinates.longitude = numberLng
                annotation.coordinate = coordinates
                annotation.title = shop["name"] as?String
                annotation.subtitle = "Totale Speso: " + "\(shop["totalExpense"]!)" + "€"
                
                self.mapView.addAnnotation(annotation)
                
            }
            
            self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
            
            self.locationManager.requestWhenInUseAuthorization()
            
            self.locationManager.delegate = self
            
            self.locationManager.startUpdatingLocation()
            
            
        }
    }
    
    
    //override func viewWillAppear(animated: Bool) {
    
    
    //self.mapView.showsUserLocation = true
    
    // }
    
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
        
        if let location = locations.last {
            
            
            if self.initMap {
                
                
                var region : MKCoordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, 50, 50)
                var span = MKCoordinateSpan()
                //print("\(location.coordinate)")
                region.center = location.coordinate
                
                self.initMap = false
                UIView.animateWithDuration(8, animations: {
                    
                    span.latitudeDelta = self.mapView.region.span.latitudeDelta * 0.09
                    span.longitudeDelta = self.mapView.region.span.longitudeDelta * 0.09
                    region.span = span;
                    self.mapView.setRegion(region, animated: true)
                    
                })
                
            }
            
            
        }
        
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
