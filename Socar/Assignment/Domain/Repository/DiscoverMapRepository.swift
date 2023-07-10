//
//  MapRepository.swift
//  Assignment
//
//  Created by anna.bae on 2023/06/30.
//

import Foundation

import Moya

enum DiscoverMapTarget {
    case zone
    case carListInZone(id: String)
}

extension DiscoverMapTarget: TargetType {
    var baseURL: URL {
        guard let url = URL(string: "http://localhost:3000/") else {
            fatalError("fatal error - invalid api url")
        }
        return url
    }

    var path: String {
        switch self {
        case .zone:
            return "zones"
        case .carListInZone(_):
            return "cars"
        }
    }

    var method: Moya.Method {
        switch self {
        case .zone:
            return .get
        case .carListInZone(id: _):
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .zone:
            return .requestPlain
        case .carListInZone(let id):
            let parameters: [String: Any] = ["zones_like": "\(id)"]
            return .requestParameters(parameters: parameters, encoding: URLEncoding.queryString)
        }
    }

    var validationType: ValidationType {
        return .successCodes
    }

    var headers: [String: String]? {
        return [:]
    }
}

final class DiscoverMapRepository {

    let provider: MoyaProvider<DiscoverMapTarget>
    init() { provider = MoyaProvider<DiscoverMapTarget>(plugins: [MoyaCacheablePlugin()]) }
}

extension DiscoverMapRepository {

    func requestZone(completion: @escaping (Result<[Zone], Error>) -> Void) {
        provider.request(.zone) { result in
            switch result {
            case .success(let response):
                guard let zones = try? JSONDecoder().decode(ZonesDTO.self, from: response.data) else { return }
                completion(.success(zones.toDomain()))
            case .failure(let error):
                print(error)
                completion(.failure(error))
            }
        }
    }
    
    func requestCars(id: String, completion: @escaping (Result<[Car], Error>) -> Void) {
        provider.request(.carListInZone(id: id)) { result in
            switch result {
            case .success(let response):
                let data = try? JSONDecoder().decode(CarsDTO.self, from: response.data)
                completion(.success(data!.toDomain()))
            case .failure(let error):
                print(error)
                completion(.failure(error))
            }
        }
    }
}

protocol MoyaCacheable {

    typealias MoyaCacheablePolicy = URLRequest.CachePolicy
    var cachePolicy: MoyaCacheablePolicy { get }
}

final class MoyaCacheablePlugin: PluginType {

    func prepare(_ request: URLRequest, target: TargetType) -> URLRequest {
        if let moyaCachableProtocol = target as? MoyaCacheable {
            var cachableRequest = request
            cachableRequest.cachePolicy = moyaCachableProtocol.cachePolicy
            return cachableRequest
        }
        return request
    }
}
