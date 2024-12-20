import UIKit
import MapKit
import CoreLocation
import Combine
import CoreData

class CustomAnnotation: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    var kickboardType: KickboardType
    
    init(coordinate: CLLocationCoordinate2D, title: String, subtitle: String, kickboardType: KickboardType) {
        self.coordinate = coordinate
        self.title = title
        self.subtitle = subtitle
        self.kickboardType = kickboardType
    }
}

class MovingAnnotation: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var title: String?
    
    init(coordinate: CLLocationCoordinate2D, title: String) {
        self.coordinate = coordinate
        self.title = title
    }
}

class MainViewController: UIViewController {
    private let mainView = MainView()
    private let locationManager = CLLocationManager()
    private let manager = KickboardManager.shared
    private let kickboardRepository: KickboardRepositoryProtocol = KickboardRepository()
    private var kickboards: [Kickboard] = []
    private let maxRange = 0.036
    private var cancellables = Set<AnyCancellable>()

    override func loadView() {
        view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupActions()
        setupLocationManager()
        setupBindings()
        mainView.mapView.delegate = self
    }

    private func setupActions() {
        mainView.locationButton.addTarget(self, action: #selector(locationButtonTapped), for: .touchUpInside)
        mainView.searchButton.addTarget(self, action: #selector(searchButtonTapped), for: .touchUpInside)
    }
    
    private func setupBindings() {
        manager.$movingAnnotation
            .sink { [weak self] annotation in
                guard let self = self else { return }
                // 기존의 annotation 제거
                let existingAnnotations = self.mainView.mapView.annotations.filter { !($0 is MKUserLocation) }
                self.mainView.mapView.removeAnnotations(existingAnnotations)
                
                // 새 annotation 추가
                if let newAnnotation = annotation {
                    self.mainView.mapView.addAnnotation(newAnnotation)
                }
            }
            .store(in: &cancellables)
        
        
        manager.$currentRoute
            .sink { [weak self] route in
                guard let self = self else { return }
                
                if let existingRoute = manager.currentRoute {
                    mainView.mapView.removeOverlay(existingRoute.polyline)
                }
            }
            .store(in: &cancellables)
        
        manager.$currentStatus
            .sink { [weak self] status in
                guard let self = self else { return }

                if status == .idle {
                    moveToCurrentLocation()
                }
            }
            .store(in: &cancellables)
    }
    
    @objc private func searchButtonTapped() {
        let searchVC = SearchViewController()
        searchVC.modalPresentationStyle = .pageSheet
        searchVC.delegate = self
        
        if let sheet = searchVC.sheetPresentationController {
            let screenHeight = UIScreen.main.bounds.height
            let customDetent = UISheetPresentationController.Detent.custom { context in
                return screenHeight * 0.85 // 화면의 85%만 차지하도록 설정
            }
            sheet.detents = [customDetent] // 높이 조절
            sheet.prefersGrabberVisible = true // 드래그 가능한 grabber 추가
            sheet.preferredCornerRadius = 24 // 상단에 둥근 모서리 추가 (선택 사항)
        }
        
        present(searchVC, animated: true, completion: nil)
    }

    private func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
    }
    
    private func loadNearbyKickboards(at location: CLLocation) {
        let spanRange = min(mainView.mapView.region.span.latitudeDelta / 2, maxRange / 2)

        let minLat = location.coordinate.latitude - spanRange
        let maxLat = location.coordinate.latitude + spanRange
        let minLng = location.coordinate.longitude - spanRange
        let maxLng = location.coordinate.longitude + spanRange
        
        do {
            kickboards = try kickboardRepository.fetchKickboardsInAreaOf(
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
            mainView.mapView.removeOverlay(existingRoute.polyline)
        }
        
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: coordinate))
        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: userLocation))
        request.transportType = .walking
        
        let directions = MKDirections(request: request)
        directions.calculate { [weak self] response, error in
            guard let self = self,
                  let route = response?.routes.first else { return }
            
            self.mainView.mapView.addOverlay(route.polyline)
            self.manager.setCurrentRoute(route)
            
            let rect = route.polyline.boundingMapRect
            self.mainView.mapView.setVisibleMapRect(rect, edgePadding: UIEdgeInsets(top: 80, left: 40, bottom: 300, right: 40), animated: true)
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
        let existingAnnotations = mainView.mapView.annotations.filter { !($0 is MKUserLocation) }
        mainView.mapView.removeAnnotations(existingAnnotations)
        
        let annotations = kickboards.map { kickboard -> CustomAnnotation in
            CustomAnnotation(
                coordinate:CLLocationCoordinate2D(latitude: kickboard.latitude, longitude: kickboard.longitude),
                title: "배터리: \(kickboard.batteryStatus)%",
                subtitle: kickboard.kickboardCode,
                kickboardType: kickboard.type
            )
        }
        
        mainView.mapView.addAnnotations(annotations)
    }
    
    private func moveToCurrentLocation() {
        guard let coordinate = locationManager.location?.coordinate else { return }
        let region = MKCoordinateRegion(
            center: coordinate,
            latitudinalMeters: 1000,
            longitudinalMeters: 1000
        )
        mainView.mapView.setRegion(region, animated: true)
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
        
        if annotation is MovingAnnotation {
            let identifier = "MovingKickboard"
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
            
            if annotationView == nil {
                annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                annotationView?.image = UIImage(named: "map_pin_moving") // 움직이는 킥보드용 이미지
            }
            
            return annotationView
        } else {
            let identifier = "KickboardMarker"
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
            
            if annotationView == nil {
                annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            }
            
            annotationView?.canShowCallout = true
            
            let rightButton = UIButton(type: .system)
            rightButton.setTitle("대여", for: .normal)
            rightButton.titleLabel?.font = Fonts.subtitleBold
            rightButton.setTitleColor(Colors.white, for: .normal)
            rightButton.backgroundColor = Colors.mint
            rightButton.layer.cornerRadius = 8
            rightButton.sizeToFit()
            
            annotationView?.rightCalloutAccessoryView = rightButton
            annotationView?.annotation = annotation
            
            if let customAnnotation = annotation as? CustomAnnotation {
                switch customAnnotation.kickboardType {
                case .basic:
                    annotationView?.image = UIImage(named: "map_pin1")
                case .power:
                    annotationView?.image = UIImage(named: "map_pin2")
                }
            }
            
            return annotationView
        }
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
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        guard let annotation = view.annotation as? CustomAnnotation,
              let kickboard = kickboards.first(where: { $0.kickboardCode == annotation.subtitle }) else {
            return
        }
        
        if let coordinate = view.annotation?.coordinate {
            drawRoute(to: coordinate)
        }
        
    
        let detailVC = KickboardDetailViewController()
        detailVC.modalPresentationStyle = .overFullScreen
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
        mainView.mapView.setCamera(camera, animated: true)
        
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
        mainView.mapView.setCamera(camera, animated: true)
    }
}

@available(iOS 17, *)
#Preview {
    MainViewController()
}
