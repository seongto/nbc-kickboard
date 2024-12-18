import Foundation
import CoreLocation
import Combine
import CoreData
import MapKit

enum KickboardStatus {
    case idle
    case isComing
    case isReady
    case riding
}

final class KickboardManager {
    static let shared = KickboardManager()
    private init() {}
    
    // MARK: - 출판된 속성들
    @Published private(set) var currentStatus: KickboardStatus = .idle
    @Published private(set) var distance: Double = 0.0 // TODO:
    @Published private(set) var elapsedTime: Int = 0
    @Published private(set) var price: Double = 0.0
    @Published var currentKickboard: Kickboard?
    @Published private(set) var currentRoute: MKRoute?
    @Published private(set) var movingAnnotation: MKPointAnnotation?
    
    
    // MARK: - Private Properties
    private var routeCoordinates: [CLLocationCoordinate2D] = []
    private var timer: Timer?
    private var currentPathIndex: Int = 0
    
    var remainingTime: Int {
        guard currentStatus == .isComing else { return 0 }
        return max(0, 600 - elapsedTime)
    }
    
    private var cancellables = Set<AnyCancellable>()
    
    
    // MARK: - 메서드
    /// DetailView에서 호출
    func setCurrentRoute(_ route: MKRoute) {
        currentRoute = route
        routeCoordinates = route.polyline.coordinates()
    }
    
    func requestKickboard(_ kickboard: Kickboard) {
        guard currentStatus == .idle else { return }
        print("requestKickboard")
        currentStatus = .isComing
        startKickboardAnimation(from: routeCoordinates.first!)
        updateKickboardCoreData(isRented: true)
    }
    
    /// DetailView에서 호출
    func startRiding() {
        guard currentStatus == .isReady else { return }
        
        currentStatus = .riding
        elapsedTime = 0
        startTimer()
    }
    
    /// DetailView에서 호출
    func endRiding() {
        guard currentStatus == .riding,
              let kickboard = currentKickboard else { return }
        
        let context = CoreDataManager.shared.context
        
        do {
            let historyEntity = HistoryEntity(context: context)
            historyEntity.rentDate = Date()
            historyEntity.totalRentTime = Int16(elapsedTime)
            historyEntity.cost = Int16(price)
            
            // 킥보드 상태 업데이트
            let kickboardRequest = KickboardEntity.fetchRequest()
            kickboardRequest.predicate = NSPredicate(format: "kickboardCode == %@", kickboard.kickboardCode)
            
            if let kickboardEntity = try context.fetch(kickboardRequest).first {
                kickboardEntity.isRented = false
                let usedBattery = Int16(elapsedTime / 60)
                kickboardEntity.batteryStatus = max(0, kickboardEntity.batteryStatus - usedBattery)
            }
            
            try context.save()
            
            resetState()
            
        } catch {
            print("Failed to create riding history: \(error)")
        }
    }
    
    
    // MARK: - Private Methods
    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            self?.elapsedTime += 1
            self?.updateDistance(Double(self?.elapsedTime ?? 0)*20.0)
        }
    }
    
    private func updateDistance(_ newDistance: Double) {
        distance = newDistance
        updatePrice()
    }
    
    /// CoreData 내부 Kickboard isRented값 롤백 및 공유되는 킥보드 대여 관련 데이터 초기화
    private func cancelRequest() {
        updateKickboardCoreData(isRented: false)
        resetState()
    }
    
    /// 가중치, 대여시간, 이동거리 3가지 요소를 통해 최종 가격 연산
    private func updatePrice() {
        let pricePerMinute: Double = 10.0
        let pricePerKm: Double = 8.0
        let timeComponent = Double(elapsedTime) / 60.0 * pricePerMinute
        let distanceComponent = distance * pricePerKm
        price = (timeComponent + distanceComponent)
    }
    
    /// CoreData 내부 Kickboard -> isRented 속성만 수정
    private func updateKickboardCoreData(isRented: Bool) {
        guard let kickboard = currentKickboard else { return }
        
        let context = CoreDataManager.shared.context
        let request = KickboardEntity.fetchRequest()
        request.predicate = NSPredicate(format: "kickboardCode == %@", kickboard.kickboardCode)
        
        do {
            if let entity = try context.fetch(request).first {
                entity.isRented = isRented
                try context.save()
            }
        } catch {
            print("Failed to update kickboard status: \(error)")
        }
    }
    
    
    // MARK: - 자율주행 추가기능 구현을 위한 애니메이션 및 경로 저장 메서드
    func startKickboardAnimation(from startCoordinate: CLLocationCoordinate2D) {
        print("startKickboardAnimation")
        let annotation = MKPointAnnotation()
        annotation.coordinate = startCoordinate
        annotation.title = "달려가고 있어요"
        annotation.subtitle = "도착 예상시간: 10분"
        
        movingAnnotation = annotation
        currentPathIndex = 0
        
        timer = Timer.scheduledTimer(withTimeInterval: 1.2, repeats: true) { [weak self] _ in
            self?.updateKickboardPosition()
        }
    }
    
    private func updateKickboardPosition() {
        guard currentPathIndex < routeCoordinates.count else {
            stopKickboardAnimation()
            return
        }
        print("updateKickboardPosition")
        let nextCoordinate = routeCoordinates[currentPathIndex]
        movingAnnotation?.coordinate = nextCoordinate
        currentPathIndex += 1
    }
    
    private func stopKickboardAnimation() {
        print("stopKickboardAnimation")
        timer?.invalidate()
        timer = nil
        currentStatus = .isReady
    }
    
    /// 반납 이후 초기화 메서드
    func resetState() {
        currentStatus = .idle
        currentRoute = nil
        currentKickboard = nil
        distance = 0
        price = 0
        elapsedTime = 0
        
        timer?.invalidate()
        timer = nil
    }
}
