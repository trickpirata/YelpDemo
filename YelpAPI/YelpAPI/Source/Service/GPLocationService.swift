//
//  GPLocationService.swift
//  YelpAPI
//
//  Created by Trick Gorospe on 8/12/21.
//

import Foundation
import CoreLocation

public protocol GPLocationServiceDelegate: AnyObject {
    func authorizationTurnedOff()
    func didFailWithError(error: Error)
    func didUpdateLocation(location: CLLocation)
    func didCheckAuthorizationStatus(status: CLAuthorizationStatus)
}

public class GPLocationService: NSObject {
    // MARK: - Outputs
    public var currentUserLocation: CLLocationCoordinate2D? {
        get {
            return locationManager.location?.coordinate
        }
    }
    private var currentLocation: CLLocation?
    
    // MARK: - Delegate
    public weak var delegate: GPLocationServiceDelegate?
    
    // MARK: - Utils
    private let locationManager: CLLocationManager
    
    public override init() {
        locationManager = CLLocationManager()
        super.init()
        setupLocationService()
    }
    // MARK: - Public Functions
    public func startLocationService() {
        locationManager.startUpdatingLocation()
    }
    
    public func stopLocationService() {
        locationManager.stopUpdatingLocation()
    }
    
    public func checkLocationAuthorization() {
        let status = locationManager.authorizationStatus
        switch status {
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager.startUpdatingLocation()
        case .notDetermined:
            /// Request permission to use location services
            locationManager.requestWhenInUseAuthorization()
        case .denied, .restricted:
            delegate?.authorizationTurnedOff()
        @unknown default:
            fatalError("CLAuthorizationStatus is unknown.")
        }
        didCheckAuthorizationStatus(status: status)
    }
    
    // MARK: - Private Functions
    private func setupLocationService() {
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 200
        locationManager.delegate = self
    }
        
    private func didCheckAuthorizationStatus(status: CLAuthorizationStatus) {
        delegate?.didCheckAuthorizationStatus(status: status)
    }
}

extension GPLocationService: CLLocationManagerDelegate {
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        currentLocation = location
        delegate?.didUpdateLocation(location: location)
    }
    
    public func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationAuthorization()
    }
    
    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationManager.stopUpdatingLocation()
        delegate?.didFailWithError(error: error)
    }
}
