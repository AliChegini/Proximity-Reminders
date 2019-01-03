//
//  LocationManager.swift
//  ProximityReminders
//
//  Created by Ehsan on 28/12/2018.
//  Copyright © 2018 Ali C. All rights reserved.
//

import Foundation
import CoreLocation

protocol LocationManagerDelegate: class {
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion)
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion)
}


class LocationManager: NSObject, CLLocationManagerDelegate {
    private let manager = CLLocationManager()
    
    var userLocation: CLLocation?
    let radius = 50.0      // radius is in meter
    let limitForUnderWatchedRegions = 20   // iOS allows only 20 regions at a time
    
    weak var delegate: LocationManagerDelegate?
    
    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestAlwaysAuthorization()
    }
    
    // function to setup geofence and start monitoring
    func setupGeoFenceAndMonitor(latitude: Double, longitude: Double, locationName: String) {
        let geoFence: CLCircularRegion = CLCircularRegion(center: CLLocationCoordinate2DMake(latitude, longitude), radius: radius, identifier: locationName)
        manager.startMonitoring(for: geoFence)
    }
    
    // function to stop monitoring for a geofence
    func stopMonitoring(latitude: Double, longitude: Double, locationName: String) {
        let geoFence: CLCircularRegion = CLCircularRegion(center: CLLocationCoordinate2DMake(latitude, longitude), radius: radius, identifier: locationName)
        manager.stopMonitoring(for: geoFence)
    }
    
    // function to return number of monitored regions
    func numberOfUnderWatchedRegions() -> Int {
        return manager.monitoredRegions.count
    }
    
}


extension LocationManager {
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        delegate?.locationManager(manager, didEnterRegion: region)
    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        delegate?.locationManager(manager, didExitRegion: region)
    }
}


extension LocationManager {
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways {
            manager.requestLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            userLocation = location
        }
    }
}

