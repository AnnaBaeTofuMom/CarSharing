//
//  DiscoverMapViewModel.swift
//  Assignment
//
//  Created by anna.bae on 2023/06/30.
//

import UIKit
import MapKit

import RxRelay
import RxSwift
import RxCocoa

enum Authorized {
    case authorized
    case unauthorized
    case notDetermined
}

final class DiscoverMapViewModel: NSObject {
    
    let disposeBag = DisposeBag()
    
    var useCase: DiscoverMapUseCase
    
    var factory: DependencyFactory

    let authorization = PublishRelay<Authorized>()
    
    let location = BehaviorRelay<CLLocationCoordinate2D?>(value: nil)
    
    let zoneList = PublishRelay<[Zone]>()
    
    init(factory: DependencyFactory) {
        self.factory = factory
        self.useCase = factory.makeDiscoverMapUseCase()
        super.init()
        bind()
        checkAuthorization()
        requestAuthorization()
        configureLocationManager()
    }
    
    let startingLocation = CLLocationCoordinate2D(
        latitude: 37.54330366639085,
        longitude: 127.04455548501139
    )
    
    let locationManager = CLLocationManager()
    
    private func bind() {
        useCase.zoneList
            .observe(on: MainScheduler.asyncInstance)
            .bind(to: zoneList)
            .disposed(by: disposeBag)
    }
    
    private func configureLocationManager() {
        locationManager.delegate = self
    }
    
    func requestAuthorization() {
        locationManager.requestWhenInUseAuthorization()
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
            checkAuthorization()
        }
    
    func checkAuthorization() {
        
        DispatchQueue.main.async {
            var status: CLAuthorizationStatus
            if #available(iOS 14.0, *) {
                status = self.locationManager.authorizationStatus
            } else {
                status = CLLocationManager.authorizationStatus()
            }
            
            switch status {
            case .notDetermined:
                self.authorization.accept(.notDetermined)
            case .restricted:
                self.authorization.accept(.unauthorized)
            case .denied:
                self.authorization.accept(.unauthorized)
            case .authorizedAlways:
                self.authorization.accept(.authorized)
            case .authorizedWhenInUse:
                self.authorization.accept(.authorized)
            @unknown default:
                print("Authorization unknown")
            }
        }
    }
}

extension DiscoverMapViewModel {
    func requestZones() {
        self.useCase.requestZones()
    }
}

extension DiscoverMapViewModel: CLLocationManagerDelegate {
    
    @available(iOS 14.0, *)
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        DispatchQueue.main.async {
            var status: CLAuthorizationStatus
            if #available(iOS 14.0, *) {
                status = self.locationManager.authorizationStatus
            } else {
                status = CLLocationManager.authorizationStatus()
            }
            
            switch status {
            case .notDetermined:
                self.authorization.accept(.notDetermined)
            case .restricted:
                self.authorization.accept(.unauthorized)
            case .denied:
                self.authorization.accept(.unauthorized)
            case .authorizedAlways:
                self.authorization.accept(.authorized)
            case .authorizedWhenInUse:
                self.authorization.accept(.authorized)
            @unknown default:
                print("Authorization unknown")
            }
        }
    }
}
