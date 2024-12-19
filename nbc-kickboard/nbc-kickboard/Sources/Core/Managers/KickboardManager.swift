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
    private init() {
        historyRepository = HistoryRepository()
        kickboardRepository = KickboardRepository()
    }
    
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
    private let historyRepository: HistoryRepositoryProtocol
    private let kickboardRepository: KickboardRepositoryProtocol
    
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
        
        do {
            // TODO: current User 저장하기
            guard let username = UserDefaults.standard.value(forKey: "username") as? String,
                  let isAdmin = UserDefaults.standard.value(forKey: "isAdmin") as? Bool else {
                print("Failed to Create riding history: no user in userdefaults")
                return
            }
            
            let newHistory = History(
                cost: Int16(price),
                rentDate: Date(),
                totalRentTime: Int16(elapsedTime),
                kickboard: kickboard,
                user: User(username: username, isAdmin: isAdmin)
            )
            
            try historyRepository.saveHistory(newHistory)
            
            var newKickboard = kickboard
            newKickboard.isRented = false
            newKickboard.batteryStatus = max(0, kickboard.batteryStatus - Int16(elapsedTime / 60))
            
            try kickboardRepository.updateKickboard(by: kickboard.kickboardCode, to: newKickboard)
            
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
        
        do {
            var newKickboard = kickboard
            newKickboard.isRented = isRented
            try kickboardRepository.updateKickboard(by: kickboard.kickboardCode, to: newKickboard)
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
