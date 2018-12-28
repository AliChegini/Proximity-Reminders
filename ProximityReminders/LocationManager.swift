//
//  LocationManager.swift
//  ProximityReminders
//
//  Created by Ehsan on 28/12/2018.
//  Copyright © 2018 Ali C. All rights reserved.
//

import Foundation
import CoreLocation

//enum LocationError: Error {
//    case unknownError
//    case disallowedByUser
//    case unableToFindLocation
//}
//
//protocol LocationPermissionDelegate: class {
//    func authorizationSucceeded()
//    func authorizationFailedWithStatus(_ status: CLAuthorizationStatus)
//}
//
//
//class LocationManager: NSObject, CLLocationManagerDelegate {
//    private let manager = CLLocationManager()
//    weak var permissionDelegate: LocationPermissionDelegate?
//
//    override init() {
//        super.init()
//        manager.delegate = self
//    }
//
//    func requestLocationAuthorization() throws {
//        let authorizationStatus = CLLocationManager.authorizationStatus()
//
//        if authorizationStatus == .restricted || authorizationStatus == .denied {
//            throw LocationError.disallowedByUser
//        } else if authorizationStatus == .notDetermined {
//            manager.requestAlwaysAuthorization()
//        } else {
//            return
//        }
//    }
//
//
//    func requestLocationPermission() {
//        do {
//            try self.requestLocationAuthorization()
//        } catch LocationError.disallowedByUser {
//            // show alert to user
//        } catch {
//            print("Location Authorization Error : \(error.localizedDescription)")
//        }
//    }
//
//
//    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
//        if status == .authorizedWhenInUse {
//            permissionDelegate?.authorizationSucceeded()
//        } else {
//            permissionDelegate?.authorizationFailedWithStatus(status)
//        }
//    }
//
//
//}
//
