//
//  NetworkService.swift
//  HouseManagerApp
//
//  Created by Anastasia Larina on 06.02.2025.
//
import Foundation

// MARK: - NetworkService

protocol NetworkServiceProtocol {
    func fetchObjects(completion: @escaping (Result<[ObjectData], Error>) -> Void)
}

final class NetworkService: NetworkServiceProtocol {
    func fetchObjects(completion: @escaping (Result<[ObjectData], Error>) -> Void) {
        guard let url = URL(string: "https://rozentalgroup.ru/test/test_ios.php") else {
            completion(.failure(NSError(domain: "Invalid URL", code: -1, userInfo: nil)))
            return
        }

        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let data = data else {
                completion(.failure(NSError(domain: "No data received", code: -2, userInfo: nil)))
                return
            }

            do {
                let apiResponse = try JSONDecoder().decode(APIResponse.self, from: data)
                completion(.success(apiResponse.data))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}
