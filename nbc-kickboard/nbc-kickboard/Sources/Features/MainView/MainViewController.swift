import UIKit
import MapKit
import CoreLocation
import SnapKit
import CoreData

class MapViewController: UIViewController {
    private let locationManager = CLLocationManager()
    private var kickboards: [Kickboard] = []
    private var currentRoute: MKRoute?
    
    private var movingAnnotation: KickboardAnnotation?
    private var routeCoordinates: [CLLocationCoordinate2D] = []
    private var animationTimer: Timer?
    private var currentPathIndex: Int = 0
    private let maxRange = 0.036
    
    
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
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupLocationManager()
    }
    
    
    // MARK: - Setup
    private func setupUI() {
        view.addSubview(mapView)
        view.addSubview(locationButton)
        
        mapView.snp.makeConstraints { $0.edges.equalToSuperview() }
        
        locationButton.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-20)
            $0.right.equalToSuperview().offset(-20)
            $0.width.height.equalTo(40)
        }
    }
    
    private func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
    }
    
    private func loadNearbyKickboards(at location: CLLocation) {
        let context = CoreDataManager.shared.context
        let request: NSFetchRequest<KickboardEntity> = KickboardEntity.fetchRequest()
        
        let spanRange = min(mapView.region.span.latitudeDelta / 2, maxRange/2)

        let minLat = location.coordinate.latitude - spanRange
        let maxLat = location.coordinate.latitude + spanRange
        let minLng = location.coordinate.longitude - spanRange
        let maxLng = location.coordinate.longitude + spanRange
        
        let predicate = NSPredicate(
            format: "latitude >= %f AND latitude <= %f AND longitude >= %f AND longitude <= %f",
            minLat, maxLat, minLng, maxLng
        )
        
        request.predicate = predicate
        
        do {
            let datas = try context.fetch(request)
            kickboards = datas.map {
                Kickboard(
                    longitude: $0.longitude,
                    latitude: $0.latitude,
                    kickboardCode: $0.kickboardCode ?? "",
                    isRented: $0.isRented,
                    batteryStatus: $0.batteryStatus
                )
            }
            
            updateAnnotations()
        } catch {
            print("Failed to fetch kickboards: \(error)")
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
        let annotations = kickboards.map { kickboard -> KickboardAnnotation in
            let annotation = KickboardAnnotation()
            annotation.coordinate = CLLocationCoordinate2D(
                latitude: kickboard.latitude,
                longitude: kickboard.longitude
            )
            
            annotation.title = "배터리: \(kickboard.batteryStatus)%"
            annotation.subtitle = kickboard.kickboardCode
            annotation.isRented = kickboard.isRented
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
    
    
    // MARK: - 자율주행 추가기능 구현을 위한 애니메이션 및 경로 저장 메서드
    private func drawRoute(to coordinate: CLLocationCoordinate2D) {
        if let existingRoute = currentRoute {
            mapView.removeOverlay(existingRoute.polyline)
        }
        
        guard let userLocation = locationManager.location?.coordinate else { return }
        
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: coordinate))
        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: userLocation))
        request.transportType = .walking
        
        let directions = MKDirections(request: request)
        directions.calculate { [weak self] response, error in
            guard let self = self,
                  let route = response?.routes.first else { return }
            
            self.currentRoute = route
            self.mapView.addOverlay(route.polyline)
            
            // 경로의 좌표 추출
            self.routeCoordinates = route.polyline.coordinates()
            
            // 선택된 킥보드의 가상 이동 시작
            self.startKickboardAnimation(from: coordinate)
            
            // 경로가 모두 보이도록 지도 영역 조정
            let rect = route.polyline.boundingMapRect
            self.mapView.setVisibleMapRect(rect, edgePadding: UIEdgeInsets(top: 80, left: 40, bottom: 100, right: 40), animated: true)
        }
    }
    
    private func startKickboardAnimation(from startCoordinate: CLLocationCoordinate2D) {
        let annotation = KickboardAnnotation() //TODO: 안뜨네요..? 해결필요
        annotation.title = "달려가고 있어요"
        annotation.subtitle = "도착 예상시간: 10분"
        annotation.coordinate = startCoordinate
        
        movingAnnotation = annotation
        if let movingAnnotation = movingAnnotation {
            mapView.addAnnotation(movingAnnotation)
        }
        
        currentPathIndex = 0
        animationTimer = Timer.scheduledTimer(withTimeInterval: 1.2, repeats: true) { [weak self] _ in
            self?.updateKickboardPosition()
        }
    }

    private func updateKickboardPosition() {
        guard let movingAnnotation = movingAnnotation, currentPathIndex < routeCoordinates.count else {
            stopKickboardAnimation()
            return
        }
        
        let nextCoordinate = routeCoordinates[currentPathIndex]
        UIView.animate(withDuration: 1.0) {
            movingAnnotation.coordinate = nextCoordinate
        }
        
        currentPathIndex += 1
    }

    private func stopKickboardAnimation() {
        animationTimer?.invalidate()
        animationTimer = nil
        
        if let movingAnnotation = movingAnnotation {
            mapView.removeAnnotation(movingAnnotation)
        }
        
        movingAnnotation = nil
        currentPathIndex = 0
        routeCoordinates.removeAll()
    }
    
    
    //MARK: - 콜백함수
    @objc private func locationButtonTapped() {
         moveToCurrentLocation()
     }
}


// MARK: - CLLocationManagerDelegate = 현재 사용자 위치 수집하기 위한 위임자
extension MapViewController: CLLocationManagerDelegate {
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
extension MapViewController: MKMapViewDelegate {
    /// 마커 디자인 관련 정의 메서드
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }
        
        if annotation === movingAnnotation {
            let identifier = "MovingKickboard"
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
            
            if annotationView == nil {
                annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                annotationView?.canShowCallout = true
                
                let image = UIImage(systemName: "figure.walk")
                annotationView?.image = image
            } else {
                annotationView?.annotation = annotation
            }
            
            return annotationView
        } else {
            let identifier = "KickboardMarker"
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView
            
            if annotationView == nil {
                annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                annotationView?.canShowCallout = true
                
                let rentButton = UIButton(type: .system)
                rentButton.setTitle("대여하기", for: .normal)
                annotationView?.rightCalloutAccessoryView = rentButton
            } else {
                annotationView?.annotation = annotation
            }
            
            if let kickboardAnnotation = annotation as? KickboardAnnotation {
                annotationView?.markerTintColor = kickboardAnnotation.isRented ? .red : .systemTeal
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
    
    /// 마커 선택 이벤트에 대한 콜백 메서드
    func mapView(_ mapView: MKMapView, didSelect annotation: MKAnnotation) {
        guard !(annotation is MKUserLocation) else { return }
        drawRoute(to: annotation.coordinate)
    }
    
    /// 마커 세부뷰가 나왔을 경우, 콜백 메서드 -> 추가 연구 필요
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        guard let annotation = view.annotation as? KickboardAnnotation else { return }
        print("대여하기 버튼 탭: \(annotation.subtitle ?? "")")
    }
}

// MARK: - 마커 객체
class KickboardAnnotation: MKPointAnnotation {
    var isRented: Bool = false
}

extension MKPolyline {
    func coordinates() -> [CLLocationCoordinate2D] {
        var coords = [CLLocationCoordinate2D](repeating: kCLLocationCoordinate2DInvalid, count: pointCount)
        getCoordinates(&coords, range: NSRange(location: 0, length: pointCount))
        return coords
    }
}

@available(iOS 17, *)
#Preview {
    MapViewController()
}
