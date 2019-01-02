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
    
    weak var delegate: LocationManagerDelegate?
    
    override init() {
        super.init()
        manager.delegate = self
        manager.requestAlwaysAuthorization()
    }
    
    func setupGeoFenceAndMonitor(latitude: Double, longitude: Double, locationName: String) {
        let geoFence: CLCircularRegion = CLCircularRegion(center: CLLocationCoordinate2DMake(latitude, longitude), radius: 50, identifier: locationName)
        manager.startMonitoring(for: geoFence)
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


