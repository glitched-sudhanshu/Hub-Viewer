//
//  NetworkManager.swift
//  GHfollowers
//
//  Created by Sudhanshu Ranjan on 14/07/24.
//

import UIKit

class NetworkManager {
    static let shared = NetworkManager()
    private let baseUrl = "https://api.github.com/users/"
    let cache = NSCache<NSString, UIImage>()
    
    private init() {}
    
    func getFollowers(for username: String, page: Int, completed: @escaping (Result<[Follower], GHError>) -> Void) {
        let endpoint = baseUrl + "\(username)/followers?per_page=100&page=\(page)"
        
    
        guard let url = URL(string: endpoint) else {
            completed(.failure( GHError.invalidUsername))
            return
        }
        
        //ask prakhar
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
                
            if let _ = error {
                completed(.failure( GHError.unableToComplete))
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completed(.failure( GHError.invalidResponse))
                return
            }
            
            guard let data = data else {
                completed(.failure( GHError.invalidData))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let followers = try decoder.decode([Follower].self, from: data)
                completed(.success(followers))
            } catch {
                completed(.failure(.invalidData))
            }
        }
        
        task.resume()
    }
}
