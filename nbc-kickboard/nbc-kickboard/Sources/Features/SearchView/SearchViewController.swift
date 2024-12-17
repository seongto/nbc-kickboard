import UIKit
import SnapKit
import SwiftUI

class SearchViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    let searchBar = UISearchBar()
    let tableView = UITableView()
    var searchResults: [String] = []
    var kakaoApiKey: String? // 카카오 REST API 키 (옵셔널로 변경)
    var searchTimer: Timer? // 디바운싱용 타이머
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        // .env 파일에서 API 키 로드
        if let env = loadEnv(), let apiKey = env["KAKAO_API_KEY"] {
            kakaoApiKey = apiKey
        }
        
        // Search Bar 설정
        searchBar.delegate = self
        searchBar.placeholder = "장소를 입력해주세요"
        searchBar.layer.borderWidth = 1
        searchBar.layer.borderColor = UIColor.gray.cgColor
        searchBar.layer.cornerRadius = 8
        searchBar.clipsToBounds = true
        view.addSubview(searchBar)
        
        // TableView 설정
        tableView.isScrollEnabled = true
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        view.addSubview(tableView)
        
        // SnapKit으로 레이아웃 설정 ($0 shorthand usage)
        searchBar.snp.makeConstraints { $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(10) }
        searchBar.snp.makeConstraints { $0.leading.equalToSuperview().offset(10) }
        searchBar.snp.makeConstraints { $0.trailing.equalToSuperview().offset(-10) }
        searchBar.snp.makeConstraints { $0.height.equalTo(50) }
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(searchBar.snp.bottom).offset(10)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    // MARK: - .env 파일에서 API 키 로드
    func loadEnv() -> [String: String]? {
        guard let filePath = Bundle.main.path(forResource: ".env", ofType: "") else {
            print(".env file not found")
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
    
    // MARK: - UISearchBar Delegate
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchTimer?.invalidate() // 이전 타이머 무효화
        guard !searchText.isEmpty else {
            searchResults = []
            tableView.reloadData()
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
        guard let kakaoApiKey = kakaoApiKey else {
            print("Kakao API Key is missing")
            return
        }
        
        guard let url = URL(string: "https://dapi.kakao.com/v2/local/search/keyword.json?query=\(query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")") else { return }
        
        var request = URLRequest(url: url)
        request.setValue("KakaoAK \(kakaoApiKey)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            guard let self = self, let data = data, error == nil else {
                print("Error: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            // 디버깅용: 응답 데이터를 출력
            print(String(data: data, encoding: .utf8)!)
            
            do {
                let decoder = JSONDecoder()
                let result = try decoder.decode(KakaoPlaceSearchResult.self, from: data)
                self.searchResults = result.documents.map { $0.placeName }
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            } catch {
                print("Decoding error: \(error.localizedDescription)")
            }
        }

        task.resume()
    }
    
    // MARK: - TableView DataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = searchResults[indexPath.row]
        return cell
    }
}

// MARK: - Kakao API Response Model
struct KakaoPlaceSearchResult: Codable {
    let documents: [Place]
}

struct Place: Codable {
    let placeName: String
    
    enum CodingKeys: String, CodingKey {
        case placeName = "place_name"
    }
}

// MARK: - SwiftUI Preview
struct SearchViewControllerPreview: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> SearchViewController {
        return SearchViewController()
    }
    
    func updateUIViewController(_ uiViewController: SearchViewController, context: Context) {}
}

struct SearchViewController_Previews: PreviewProvider {
    static var previews: some View {
        SearchViewControllerPreview()
            .ignoresSafeArea()
    }
}
