//
//  mapPickerController.swift
//  Project1
//
//  Created by Raffaele P on 21/07/16.
//  Copyright © 2016 Gruppo2. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapPickerController: UIViewController, MKMapViewDelegate, UISearchBarDelegate,CLLocationManagerDelegate {
    
    var ad: AppDelegate? = UIApplication.sharedApplication().delegate as? AppDelegate
    
    @IBOutlet var mapView : MKMapView!
    
    var annotation : MKPointAnnotation?
    var currentCoordinate :CLLocationCoordinate2D?
    var locationManager = CLLocationManager ()
    var lastCoordinate = ""

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let uilgr = UILongPressGestureRecognizer(target: self, action: #selector(MapPickerController.addAnnotation(_:)))
        uilgr.minimumPressDuration = 1.0
        
        self.mapView.addGestureRecognizer(uilgr)
        
        self.mapView.delegate = self
        let rightBarButton = UIBarButtonItem(
            title: "SAVE",
            style: .Plain,
            target: self,
            action: #selector(saveCoordinateMap(_:))
        )
        
        self.navigationItem.setRightBarButtonItem(rightBarButton, animated: false)
    }
    
    
    
    override func viewWillAppear(animated: Bool) {
        
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        self.locationManager.requestWhenInUseAuthorization()
        
        self.locationManager.delegate = self
        
        self.locationManager.startUpdatingLocation()
        
        //self.mapView.showsUserLocation = true
        
 }
    /*
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
        
        if let location = locations.last {
            //self.locationManager.stopUpdatingLocation()
            
            if "\(location.coordinate)" == self.lastCoordinate {
                self.locationManager.stopUpdatingLocation()
            }
            
            self.lastCoordinate = "\(location.coordinate)"
            
            
            
            var region :MKCoordinateRegion  = MKCoordinateRegionMakeWithDistance(location.coordinate, 50, 50)
            var span = MKCoordinateSpan()
            print("\(location.coordinate)")
            region.center = location.coordinate
            
            
            UIView.animateWithDuration(8, animations: {
                
                
                span.latitudeDelta = self.mapView.region.span.latitudeDelta * 0.09
                span.longitudeDelta = self.mapView.region.span.longitudeDelta * 0.09
                region.span = span;
                self.mapView.setRegion(region, animated: true)
                
            })
            
        }
    }
    */
    
    
    
    func  saveCoordinateMap(sender: UIBarButtonItem){
        
        ad!.coordinateMap = self.currentCoordinate!
        
        ad!.issetFromMap = true
        
        self.navigationController?.popViewControllerAnimated(true)
        
    }
    
    /*
     func searchBarSearchButtonClicked(searchBar: UISearchBar){
     let text = searchBar.text! as String
     print(text)
     
     CLGeocoder().geocodeAddressString(text) { (arrayPlacemarks, error) in
     
     if let placemarks = arrayPlacemarks{
     if let placeMark = placemarks.last{
     
     // Location name
     if let locationName = placeMark.addressDictionary!["Name"] as? NSString {
     print(locationName)
     }
     
     // Street address
     if let street = placeMark.addressDictionary!["Thoroughfare"] as? NSString {
     print(street)
     }
     
     // City
     if let city = placeMark.addressDictionary!["City"] as? NSString {
     print(city)
     }
     
     // Zip code
     if let zip = placeMark.addressDictionary!["ZIP"] as? NSString {
     print(zip)
     }
     
     // Country
     if let country = placeMark.addressDictionary!["Country"] as? NSString {
     print(country)
     }
     }
     
     }
     
     }
     }
     */
    
    func addAnnotation(gestureRecognizer:UIGestureRecognizer){
        
        //        if(self.annotation != nil){
        //            return
        //        }
        
        if gestureRecognizer.state == UIGestureRecognizerState.Ended {
            let touchPoint = gestureRecognizer.locationInView(self.mapView)
            let newCoordinates = self.mapView.convertPoint(touchPoint, toCoordinateFromView: self.mapView)
            self.annotation = MKPointAnnotation()
            self.annotation!.coordinate = newCoordinates
            self.currentCoordinate = newCoordinates
            
            self.reverseFromLocation(newCoordinates, completion: { (result) in
                self.annotation = result as MKPointAnnotation
                self.mapView.addAnnotation(self.annotation!)
                self.mapView.selectAnnotation(self.annotation!, animated: true)
            })
        }
    }
    
    
    
    func reverseFromLocation(coordinates: CLLocationCoordinate2D, completion: (result: MKPointAnnotation) -> Void){
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinates
        //self.currentCoordinate = coordinates
        
        CLGeocoder().reverseGeocodeLocation(CLLocation(latitude: coordinates.latitude, longitude: coordinates.longitude), completionHandler: {(placemarks, error) -> Void in
            if error != nil {
                print("Reverse geocoder failed with error" + error!.localizedDescription)
                return
            }
            
            if placemarks!.count > 0 {
                let pm = placemarks![0]
                
                // not all places have thoroughfare & subThoroughfare so validate those values
                if let thoroughfare = pm.thoroughfare{
                    annotation.title = thoroughfare + ", " + thoroughfare
                    annotation.subtitle = pm.subLocality
                }
                
                completion(result: annotation)
                
            }
            else {
                annotation.title = "Unknown Place"
                
                self.mapView.addAnnotation(annotation)
                print("Problem with the data received from geocoder")
            }
        })
    }
    
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView?{
        var annotationView = mapView.dequeueReusableAnnotationViewWithIdentifier("CustomPin") as? MKPinAnnotationView
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "CustomPin")
            annotationView?.canShowCallout = true
            annotationView?.rightCalloutAccessoryView = UIButton(type: .InfoLight)
            annotationView?.draggable = true
            annotationView?.annotation = annotation
        } else {
            annotationView?.annotation = annotation
        }
        
        return annotationView
    }
    
    
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, didChangeDragState newState: MKAnnotationViewDragState, fromOldState oldState: MKAnnotationViewDragState){
        
        switch newState {
        case .Starting:
            print("starting")
        //view.dragState = .Dragging
        case .Dragging:
            print("dragging")
        case .Ending: //, .Canceling:
            print("ending")
            let coordinates = view.annotation?.coordinate
            self.currentCoordinate = coordinates!
            self.mapView.removeAnnotations(self.mapView.annotations)
            
            self.reverseFromLocation(coordinates!, completion: { (result) in
                self.annotation = result as MKPointAnnotation
                self.mapView.addAnnotation(self.annotation!)
                self.mapView.selectAnnotation(self.annotation!, animated: true)
            })
            
            view.dragState = .None
        default: break
        }
    }
}
