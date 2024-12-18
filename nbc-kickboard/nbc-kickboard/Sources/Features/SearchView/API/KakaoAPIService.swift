import Foundation

// Kakao API 서비스
class KakaoAPIService {
    static let shared = KakaoAPIService()
    private init() {}
    
    func searchPlaces(query: String, apiKey: String, completion: @escaping (Result<[Place], Error>) -> Void) {
        let urlString = "\(APIConstants.kakaoBaseURL)\(APIConstants.searchKeywordPath)?query=\(query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")"
        
        guard let url = URL(string: urlString) else {
            return
        }
        
        var request = URLRequest(url: url)
        request.setValue("KakaoAK \(apiKey)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "No data", code: 0, userInfo: nil)))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let result = try decoder.decode(KakaoPlaceSearchResult.self, from: data)
                completion(.success(result.documents))
            } catch {
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
}

