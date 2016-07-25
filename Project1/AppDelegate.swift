//
//  AppDelegate.swift
//  TestPinDraggable
//
//  Created by Omar Cafini on 21/07/16.
//  Copyright © 2016 Airbag Studio. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    
    
    
    /*
    //Dichiarazione dellla funzione
    func reverse(<#parameters#>,parametroRitorno: (result : TIPORITORNO) -> void) {
    }
    
    
    //Richiamo della funzione
    //USO DELLA CLOSUR
    self.funzioneReverse (parametri , completion:{
    (result) in
    self.VariabileRitorno = result AS TIPORITORNO
    
    },error:{(error) in 
      self.VariabileError = error AS TIPORITORNO2 })
    */
    
    
    var window: UIWindow?
    var coordinateMap = CLLocationCoordinate2D()
    var issetFromMap = false //Per Settare LabelInfo
    var dataShop: [[String:AnyObject]]?
    var currentDataShop: [String:AnyObject]?
    var indexDataShop : Int = -1

    
    func getCacheURL() -> NSURL {
        let cacheURL = NSFileManager.defaultManager().URLsForDirectory(.CachesDirectory, inDomains: .UserDomainMask)[0]
        return cacheURL
    }
    
    
    func fileInCacheDirectory(filename: String) -> String {
        let fileURL = getCacheURL().URLByAppendingPathComponent(filename)
        return fileURL.path!
    }
    
    
    func loadImageFromPath(fileName: String) -> UIImage? {
        
        let imagePath = fileInCacheDirectory(fileName)
        let image = UIImage(contentsOfFile: imagePath)        
        if image == nil {
            
            print("missing image at: \(imagePath)")
        }
        print("Loading image from path: \(imagePath)") // this is just for you to see the path in case you want to go to the directory, using Finder.
        return image
        
    }
    

    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

