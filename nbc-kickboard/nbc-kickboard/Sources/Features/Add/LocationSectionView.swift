//
//  LocationSectionView.swift
//  nbc-kickboard
//
//  Created by 전성규 on 12/17/24.
//

import UIKit
import MapKit
import SnapKit

protocol LocationSectionViewDelegate: AnyObject {
    func mapViewReginDidChange(centerCoordinate: CLLocationCoordinate2D)
}

final class LocationSectionView: UIStackView {
    weak var delegate: LocationSectionViewDelegate?
    
    private let viewTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "등록위치"
        label.textColor = .black
        label.font = Fonts.subtitleBold
        
        return label
    }()
    
    private let mapContentView = UIView()
    
    private let centerMarker = UIImageView(image: UIImage(named: "basic_maker"))
    
    private let mapView: MKMapView = {
        let mapView = MKMapView()
        // Seoul
        let coordinate = CLLocationCoordinate2D(
            latitude: 37.5665,
            longitude: 126.9780)
        let region = MKCoordinateRegion(
            center: coordinate,
            latitudinalMeters: 5000,
            longitudinalMeters: 5000)
        
        mapView.setRegion(region, animated: true)
        
        mapView.layer.cornerRadius = 12.0
        
        return mapView
    }()
    
    init() {
        super.init(frame: .zero)
        
        self.configureUI()
        self.setupConstratins()
        
        mapView.delegate = self
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        axis = .vertical
        alignment = .leading
        distribution = .equalSpacing
        spacing = 10.0
        
        [viewTitleLabel, mapContentView].forEach { addArrangedSubview($0) }
        
        [mapView, centerMarker].forEach { mapContentView.addSubview($0) }
    }
    
    private func setupConstratins() {
        mapContentView.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.height.equalTo(297.0)
        }
        
        mapView.snp.makeConstraints { $0.edges.equalToSuperview() }
        
        centerMarker.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(mapContentView.snp.centerY)
        }
    }
    
    func resetCoordinate() {
        let coordinate = CLLocationCoordinate2D(
            latitude: 37.5665,
            longitude: 126.9780)
        let region = MKCoordinateRegion(
            center: coordinate,
            latitudinalMeters: 5000,
            longitudinalMeters: 5000)
        
        mapView.setRegion(region, animated: false)
    }
    
    func updateCenterMaker(with type: KickboardType) {
        switch type {
        case .basic:
            centerMarker.image = UIImage(named: "basic_maker")
        case .power:
            centerMarker.image = UIImage(named: "power_maker")
        }
    }
}

extension LocationSectionView: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        delegate?.mapViewReginDidChange(centerCoordinate: mapView.centerCoordinate)
    }
}

#if DEBUG

import SwiftUI

struct LocationSectionView_Previews: PreviewProvider {
    static var previews: some View {
        LocationSectionView_Presentable()
            .frame(
                width: UIScreen.main.bounds.width - 40.0,
                height: 332.0,
                alignment: .center)
    }
    
    struct LocationSectionView_Presentable: UIViewRepresentable {
        func makeUIView(context: Context) -> some UIView {
            LocationSectionView()
        }
        
        func updateUIView(_ uiView: UIViewType, context: Context) {}
    }
}

#endif
