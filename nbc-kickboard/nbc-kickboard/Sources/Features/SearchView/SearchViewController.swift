import UIKit

protocol SearchViewControllerDelegate: AnyObject {
    func didSelectLocation(latitude: Double, longitude: Double)
}

class SearchViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    private let searchView = SearchView()
    var searchResults: [Place] = [] // 모델에서 전달된 결과
    var searchTimer: Timer? // 디바운싱용 타이머
    
    weak var delegate: SearchViewControllerDelegate?
    
    override func loadView() {
        view = searchView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Delegates 설정
        searchView.searchBar.delegate = self
        searchView.tableView.dataSource = self
        searchView.tableView.delegate = self
    }
    
    // MARK: - UISearchBar Delegate
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchTimer?.invalidate() // 이전 타이머 무효화
        guard !searchText.isEmpty else {
            searchResults = []
            searchView.tableView.reloadData()
            return
        }
        searchTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { [weak self] _ in
            self?.searchPlaces(query: searchText)
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let query = searchBar.text, !query.isEmpty else { return }
        searchPlaces(query: query)
        searchBar.resignFirstResponder()
    }
    
    // MARK: - 장소 검색 API 호출
    func searchPlaces(query: String) {
        guard let kakaoApiKey = loadEnv()?["KAKAO_API_KEY"] else {
            print("Kakao API Key is missing")
            return
        }
        
        KakaoAPIService.shared.searchPlaces(query: query, apiKey: kakaoApiKey) { [weak self] result in
            switch result {
            case .success(let places):
                self?.searchResults = places
                DispatchQueue.main.async {
                    self?.searchView.tableView.reloadData()
                }
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
            }
        }
    }
    
    // MARK: - TableView DataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchTableViewCell.id, for: indexPath) as? SearchTableViewCell else {
            fatalError("SearchTableViewCell을 dequeue하는데 실패했습니다.")
        }
        
        cell.config(name: searchResults[indexPath.row].placeName, address: searchResults[indexPath.row].addressName)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let place = searchResults[indexPath.row]
        
        if let latitude = Double(place.y), let longitude = Double(place.x) {
            print("선택한 장소의 위도: \(latitude), 경도: \(longitude)")
            
            // Delegate를 통해 MainViewController에 전달
            delegate?.didSelectLocation(latitude: latitude, longitude: longitude)
        }

        tableView.deselectRow(at: indexPath, animated: true) // 선택된 셀 해제
        dismiss(animated: true, completion: nil) // 화면 닫기
    }
    
    // MARK: - .env 파일에서 API 키 로드
    func loadEnv() -> [String: String]? {
        guard let filePath = Bundle.main.path(forResource: ".env", ofType: "") else {
            print(".env 파일을 찾을 수 없습니다")
            return nil
        }
        
        do {
            let contents = try String(contentsOfFile: filePath)
            var envDict: [String: String] = [:]
            
            // 각 줄을 파싱하여 환경 변수로 저장
            let lines = contents.split(separator: "\n")
            for line in lines {
                let components = line.split(separator: "=")
                if components.count == 2 {
                    let key = String(components[0]).trimmingCharacters(in: .whitespacesAndNewlines)
                    let value = String(components[1]).trimmingCharacters(in: .whitespacesAndNewlines)
                    envDict[key] = value
                }
            }
            return envDict
        } catch {
            print("Error reading .env file: \(error)")
            return nil
        }
    }
}

@available(iOS 17.0, *)
#Preview {
    SearchViewController()
}
