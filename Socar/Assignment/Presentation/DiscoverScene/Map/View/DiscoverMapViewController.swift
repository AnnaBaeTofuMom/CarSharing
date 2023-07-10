//
//  DiscoverMapViewController.swift
//  Assignment
//
//  Created by anna.bae on 2023/06/30.
//

import UIKit
import MapKit

import SnapKit
import RxSwift
import RxCocoa
import RxRelay

class DiscoverMapViewController: UIViewController {
    
    private var viewModel: DiscoverMapViewModel
    
    var disposeBag = DisposeBag()
    
    let map = MKMapView()
    
    let favoriteButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "favorite_zone"), for: .normal)
        return button
    }()
    
    let myLocationButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "current_location"), for: .normal)
        return button
    }()
    
    init(viewModel: DiscoverMapViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .blue
        configure()
        makeConstraints()
        
        setUpMap()
        bind()
        bindOutput()
        viewModel.checkAuthorization()
        viewModel.requestZones()
    }
    
    private func bind() {
        
        myLocationButton.rx.tap.withUnretained(self).subscribe { owner, _ in
            owner.viewModel.checkAuthorization()
        }.disposed(by: disposeBag)
        
        favoriteButton.rx.tap.withUnretained(self).subscribe { owner, _ in
            let viewModel = owner.viewModel.factory.makeFavoriteListViewModel()
            Router.shared.actions.accept(.toFavoriteList(viewModel: viewModel))
        }.disposed(by: disposeBag)
    }
    
    private func bindOutput() {
        
        viewModel.authorization.withUnretained(self).subscribe { owner, status in
            if status == .authorized {
                owner.focusUserLocation()
            } else if status == .unauthorized {
                owner.goSetting()
            }
        }.disposed(by: disposeBag)
        
        viewModel.zoneList.withUnretained(self).subscribe { owner, zones in
            zones.forEach { [weak self] zone in
                let pin = SocarAnnotation(zone: zone)
                self?.map.addAnnotation(pin)
            }
        }.disposed(by: disposeBag)
    }
    
    private func configure() {
        [map, favoriteButton, myLocationButton].forEach { view.addSubview($0) }
        
        map.delegate = self
        map.setRegion(MKCoordinateRegion(
            center: viewModel.location.value ?? viewModel.startingLocation,
            span: MKCoordinateSpan(
                latitudeDelta: 0.005,
                longitudeDelta: 0.005)),
                      animated: true)
    }
    
    private func setUpMap() {
        map.showsUserLocation = true
        self.focusDefaultLocation()
    }
    
    private func focusUserLocation() {
        map.showsUserLocation = true
        map.userTrackingMode = .follow
        map.setRegion(MKCoordinateRegion(center: viewModel.locationManager.location?.coordinate ?? viewModel.startingLocation, span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)), animated: true)
    }
    
    private func focusDefaultLocation() {
        map.showsUserLocation = false
        map.userTrackingMode = .none
        map.setRegion(MKCoordinateRegion(center: viewModel.locationManager.location?.coordinate ?? viewModel.startingLocation, span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)), animated: true)
    }
    
    private func makeConstraints() {
        map.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        favoriteButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(16)
            make.left.equalToSuperview().inset(16)
        }
        
        myLocationButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-16)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(16)
        }
    }
    
    func goSetting() {
        
        let alert = UIAlertController(title: "위치권한 요청", message: "내 주변의 공유차랑 정보를 보려면 위치 권한이 필요해요.", preferredStyle: .alert)
        
        let settingAction = UIAlertAction(title: "설정", style: .default) { action in
            guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
            }
        }
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel) { UIAlertAction in
            print("Canceled")
        }
        
        alert.addAction(settingAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    
    private func moveCenterToZone(location: CLLocationCoordinate2D, completion: @escaping () -> Void) {
        self.map.setCenter(location, animated: true)
        completion()
    }

}

extension DiscoverMapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard !annotation.isKind(of: MKUserLocation.self) else {
            return nil
        }
        
        var annotationView = self.map.dequeueReusableAnnotationView(withIdentifier: SocarAnnotationView.identifier)
        
        if annotationView == nil {
            annotationView = SocarAnnotationView(annotation: annotation, reuseIdentifier: SocarAnnotationView.identifier)
        } else {
            annotationView?.annotation = annotation
        }
        
        annotationView?.image = UIImage(named: "img_zone_shadow")
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        let pin = view.annotation as? SocarAnnotation
        guard let zone = pin?.zone else { return }
        let location = CLLocationCoordinate2D(latitude: zone.lat, longitude: zone.lng)
        self.moveCenterToZone(location: location) {
            guard let nav = self.navigationController else { return }
            let viewModel = self.viewModel.factory.makeCarListViewModel(zone: zone)
            Router.shared.actions.accept(.toCarList(viewModel: viewModel))
        }
    }
}
