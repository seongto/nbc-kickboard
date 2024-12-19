import UIKit
import MapKit
import CoreLocation
import SnapKit
import Combine
import CoreData

class MainViewController: UIViewController {
    private let locationManager = CLLocationManager()
    private let manager = KickboardManager.shared
    private var kickboards: [Kickboard] = []
    
    private let maxRange = 0.036
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - UI Components
    private lazy var mapView: MKMapView = {
        let map = MKMapView()
        map.showsUserLocation = true
        map.delegate = self

        return map
    }()

    private lazy var locationButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "location.fill"), for: .normal)
        button.backgroundColor = .white
        button.layer.cornerRadius = 20
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 2)
        button.layer.shadowOpacity = 0.2
        button.layer.shadowRadius = 4
        button.addTarget(self, action: #selector(locationButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var searchButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "magnifyingglass"), for: .normal) // 검색 아이콘
        button.backgroundColor = .white
        button.layer.cornerRadius = 20
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 2)
        button.layer.shadowOpacity = 0.2
        button.layer.shadowRadius = 4
        button.addTarget(self, action: #selector(searchButtonTapped), for: .touchUpInside)
        return button
    }()
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupLocationManager()
        setupBindings()
    }

    private func setupBindings() {
        manager.$movingAnnotation
            .sink { [weak self] annotation in
                if let existingAnnotations = self?.mapView.annotations.filter { !($0 is MKUserLocation) }{
                    self?.mapView.removeAnnotations(existingAnnotations)
                }
                if let newAnnotation = annotation {
                    self?.mapView.addAnnotation(newAnnotation)
                }
            }
            .store(in: &cancellables)
    }
    
    @objc private func searchButtonTapped() {
        let searchVC = SearchViewController()
        searchVC.delegate = self
        present(searchVC, animated: true, completion: nil)
    }
    
    
    // MARK: - Setup
    private func setupUI() {
        view.addSubview(mapView)
        mapView.snp.makeConstraints { $0.edges.equalToSuperview() }

        // UIView를 생성하여 버튼들을 넣을 공간을 마련합니다.
        let buttonContainerView = UIView()
        view.addSubview(buttonContainerView)
        
        //버튼 두개 공간
        buttonContainerView.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-20)
            $0.trailing.equalToSuperview().offset(-20)
            $0.height.equalTo(80)
            $0.width.equalTo(60)
        }
            
        // locationButton 추가
        buttonContainerView.addSubview(locationButton)
        locationButton.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(40) // 버튼 크기
        }
        
        // searchButton 추가
        buttonContainerView.addSubview(searchButton)
        searchButton.snp.makeConstraints {
            $0.top.equalTo(locationButton.snp.bottom).offset(10) // locationButton 바로 아래에 배치
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(40) // 버튼 크기
        }
    }
    
    private func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
    }
    
    private func loadNearbyKickboards(at location: CLLocation) {
        let spanRange = min(mapView.region.span.latitudeDelta / 2, maxRange/2)

        let minLat = location.coordinate.latitude - spanRange
        let maxLat = location.coordinate.latitude + spanRange
        let minLng = location.coordinate.longitude - spanRange
        let maxLng = location.coordinate.longitude + spanRange
        
        do {
            kickboards = try CoreDataStack.shared.requestKickboards(
                minLat: minLat,
                maxLat: maxLat,
                minLng: minLng,
                maxLng: maxLng
            )
            updateAnnotations()
        } catch {
            print("Failed to fetch kickboards: \(error)")
        }
    }
    
    private func drawRoute(to coordinate: CLLocationCoordinate2D) {
            guard let userLocation = locationManager.location?.coordinate else { return }
            
            if let existingRoute = manager.currentRoute {
                mapView.removeOverlay(existingRoute.polyline)
            }
            
            let request = MKDirections.Request()
            request.source = MKMapItem(placemark: MKPlacemark(coordinate: coordinate))
            request.destination = MKMapItem(placemark: MKPlacemark(coordinate: userLocation))
            request.transportType = .walking
            
            let directions = MKDirections(request: request)
            directions.calculate { [weak self] response, error in
                guard let self = self,
                      let route = response?.routes.first else { return }
                
                self.mapView.addOverlay(route.polyline)
                self.manager.setCurrentRoute(route)
                
                let rect = route.polyline.boundingMapRect
                self.mapView.setVisibleMapRect(rect, edgePadding: UIEdgeInsets(top: 80, left: 40, bottom: 300, right: 40), animated: true)
            }
        }
    
    private func showLocationPermissionAlert() {
        let alert = UIAlertController(
            title: "위치 권한 필요",
            message: "주변 킥보드를 확인하기 위해 위치 권한이 필요합니다. 설정에서 위치 권한을 허용해주세요.",
            preferredStyle: .alert
        )
        
        let settingsAction = UIAlertAction(title: "설정", style: .default) { _ in
            if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(settingsURL)
            }
        }
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel)
        
        alert.addAction(settingsAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }
    
    
    // MARK: - Map Functions
    private func updateAnnotations() {
        let existingAnnotations = mapView.annotations.filter { !($0 is MKUserLocation) }
        mapView.removeAnnotations(existingAnnotations)
        
        // 지도 위치 변경 시, 새로 보이는 영역에 있는 킥보드들 지도에 표시
        let annotations = kickboards.map { kickboard -> MKPointAnnotation in
            let annotation = MKPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2D(
                latitude: kickboard.latitude,
                longitude: kickboard.longitude
            )
            
            annotation.title = "배터리: \(kickboard.batteryStatus)%"
            annotation.subtitle = kickboard.kickboardCode
            return annotation
        }
        
        mapView.addAnnotations(annotations)
    }
    
    private func moveToCurrentLocation() {
        guard let coordinate = locationManager.location?.coordinate else { return }
        let region = MKCoordinateRegion(
            center: coordinate,
            latitudinalMeters: 1000,
            longitudinalMeters: 1000
        )
        mapView.setRegion(region, animated: true)
    }
    
    
    //MARK: - 콜백함수
    @objc private func locationButtonTapped() {
         moveToCurrentLocation()
     }
}


// MARK: - CLLocationManagerDelegate = 현재 사용자 위치 수집하기 위한 위임자
extension MainViewController: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager.startUpdatingLocation()
            moveToCurrentLocation()
        case .denied, .restricted:
            showLocationPermissionAlert()
            break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        @unknown default:
            break
        }
    }
}


// MARK: - MKMapViewDelegate
extension MainViewController: MKMapViewDelegate {
    /// 마커 디자인 관련 정의 메서드
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }
        let identifier = "KickboardMarker"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true
            annotationView?.image = UIImage(named: "map_pin2")
            
            // 오른쪽 버튼 추가
            let rightButton = UIButton(type: .detailDisclosure)
            rightButton.setTitle("대여하기", for: .normal)
            annotationView?.rightCalloutAccessoryView = rightButton
        }
        
        annotationView?.annotation = annotation
        
        return annotationView
    }
    
    /// 사용자가 바라보는 위치가 변경될 때
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        let center = CLLocation(
            latitude: mapView.centerCoordinate.latitude,
            longitude: mapView.centerCoordinate.longitude
        )
        loadNearbyKickboards(at: center)
    }
    
    /// 지도 줌아웃 범위 제한 용도
    func mapView(_ mapView: MKMapView, regionWillChangeAnimated animated: Bool) {
        var region = mapView.region
        
        if region.span.latitudeDelta > maxRange {
            region.span = MKCoordinateSpan(latitudeDelta: maxRange, longitudeDelta: maxRange)
            mapView.setRegion(region, animated: true)
        }
    }
    
    /// 경로 디자인 정의 용도
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if let polyline = overlay as? MKPolyline {
            let renderer = MKPolylineRenderer(polyline: polyline)
            renderer.strokeColor = .systemBlue
            renderer.lineWidth = 5
            return renderer
        }
        return MKOverlayRenderer(overlay: overlay)
    }
    
    /// 마커 선택 이벤트에 대한 콜백 메서드
    func mapView(_ mapView: MKMapView, didSelect annotation: MKAnnotation) {
        guard !(annotation is MKUserLocation) else { return }
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        guard let annotation = view.annotation as? MKPointAnnotation,
              let kickboard = kickboards.first(where: { $0.kickboardCode == annotation.subtitle }) else {
            return
        }
        
        if let coordinate = view.annotation?.coordinate {
            drawRoute(to: coordinate)
        }
        
        // DetailViewController 표시
        let detailVC = KickboardDetailViewController()
        if let sheet = detailVC.sheetPresentationController {
            let customDetent = UISheetPresentationController.Detent.custom { _ in
                return 256
            }
            sheet.detents = [customDetent]
            sheet.prefersGrabberVisible = true
            sheet.preferredCornerRadius = 20
        }
        
        manager.currentKickboard=kickboard
        
        present(detailVC, animated: true)
    }
}


extension MKPolyline {
    func coordinates() -> [CLLocationCoordinate2D] {
        var coords = [CLLocationCoordinate2D](repeating: kCLLocationCoordinate2DInvalid, count: pointCount)
        getCoordinates(&coords, range: NSRange(location: 0, length: pointCount))
        return coords
    }
}

// MARK: - SearchViewControllerDelegate 구현
extension MainViewController: SearchViewControllerDelegate {
    func didSelectLocation(latitude: Double, longitude: Double) {
        // 지도 카메라 이동
        let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let camera = MKMapCamera(lookingAtCenter: coordinate, fromDistance: 1000, pitch: 0, heading: 0)
        mapView.setCamera(camera, animated: true)
        
        print("위도: \(latitude), 경도: \(longitude)")
    }
}

// MARK: - CustomTabBarControllerDelegate 구현
extension MainViewController: CustomTabBarControllerDelegate {
    func createKickboardLocation(_ location: Location) {
        let coordinate = CLLocationCoordinate2D(
            latitude: location.latitude,
            longitude: location.longitude)
        let camera = MKMapCamera(lookingAtCenter: coordinate, fromDistance: 1000, pitch: 0, heading: 0)
        mapView.setCamera(camera, animated: true)
    }
}

@available(iOS 17, *)
#Preview {
    MainViewController()
}
