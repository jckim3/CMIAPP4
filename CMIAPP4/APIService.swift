//
//  APIService.swift
//  CMIAPP4
//
//  Created by JC Kim on 8/3/24.
//

import Foundation

import Combine

class APIService {
    static let shared = APIService()
    private init() {}
    
    private let baseURL = "https://www.carriagemotorinn.com:444/api/motel"

    private var cancellables = Set<AnyCancellable>()
    
    // 최신 Git 태그를 가져오는 메서드 추가
    func fetchLatestTag(completion: @escaping (Result<String, Error>) -> Void) {
        guard let url = URL(string: "https://www.carriagemotorinn.com:444/api/updates/latest-tag") else {
            completion(.failure(URLError(.badURL)))
            return
        }
        
        URLSession.shared.dataTaskPublisher(for: url)
            .tryMap { result -> Data in
                guard let response = result.response as? HTTPURLResponse, response.statusCode == 200 else {
                    throw URLError(.badServerResponse)
                }
                return result.data
            }
            .decode(type: [String: String].self, decoder: JSONDecoder())
            .compactMap { $0["tag"] }
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { completionResult in
                    switch completionResult {
                    case .finished:
                        break
                    case .failure(let error):
                        completion(.failure(error))
                    }
                },
                receiveValue: { tag in
                    completion(.success(tag))
                }
            )
            .store(in: &cancellables)
    }
    
    func fetchRevenue(for year: Int, completion: @escaping (Result<[Revenue], Error>) -> Void) {
            guard let url = URL(string: "\(baseURL)/revenue/\(year)") else {
                completion(.failure(URLError(.badURL)))
                return
            }
            
            URLSession.shared.dataTaskPublisher(for: url)
                .tryMap { result -> Data in
                    guard let response = result.response as? HTTPURLResponse, response.statusCode == 200 else {
                        throw URLError(.badServerResponse)
                    }
                    return result.data
                }
                .decode(type: [Revenue].self, decoder: JSONDecoder())
                .receive(on: DispatchQueue.main)
                .sink(
                    receiveCompletion: { completionResult in
                        switch completionResult {
                        case .finished:
                            break
                        case .failure(let error):
                            completion(.failure(error))
                        }
                    },
                    receiveValue: { revenues in
                        completion(.success(revenues))
                    }
                )
                .store(in: &cancellables)
        }
    func fetchTodayCheckInRoomList(completion: @escaping (Result<[UInt8], Error>) -> Void) {
        guard let url = URL(string: "\(baseURL)/rooms/today-checkin-list") else {
            completion(.failure(URLError(.badURL)))
            return
        }
        
        URLSession.shared.dataTaskPublisher(for: url)
            .tryMap { result -> Data in
                guard let response = result.response as? HTTPURLResponse, response.statusCode == 200 else {
                    throw URLError(.badServerResponse)
                }
                return result.data
            }
            .decode(type: [UInt8].self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { completionResult in
                    switch completionResult {
                    case .finished:
                        break
                    case .failure(let error):
                        completion(.failure(error))
                    }
                },
                receiveValue: { roomList in
                    completion(.success(roomList))
                }
            )
            .store(in: &cancellables)
    }
    
    func fetchAvailableRoomsCount(completion: @escaping (Result<Int, Error>) -> Void) {
        guard let url = URL(string: "\(baseURL)/available-rooms-count") else {
            completion(.failure(URLError(.badURL)))
            return
        }
        
        URLSession.shared.dataTaskPublisher(for: url)
            .tryMap { result -> Data in
                guard let response = result.response as? HTTPURLResponse, response.statusCode == 200 else {
                    throw URLError(.badServerResponse)
                }
                return result.data
            }
            .decode(type: Int.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { completionResult in
                    switch completionResult {
                    case .finished:
                        break
                    case .failure(let error):
                        completion(.failure(error))
                    }
                },
                receiveValue: { count in
                    completion(.success(count))
                }
            )
            .store(in: &cancellables)
    }
    
    func fetchTodayCheckInCount(completion: @escaping (Result<Int, Error>) -> Void) {
            guard let url = URL(string: "\(baseURL)/rooms/today-checkin-count") else {
                completion(.failure(URLError(.badURL)))
                return
            }
            
            URLSession.shared.dataTaskPublisher(for: url)
                .tryMap { result -> Data in
                    guard let response = result.response as? HTTPURLResponse, response.statusCode == 200 else {
                        throw URLError(.badServerResponse)
                    }
                    return result.data
                }
                .decode(type: Int.self, decoder: JSONDecoder())
                .receive(on: DispatchQueue.main)
                .sink(
                    receiveCompletion: { completionResult in
                        switch completionResult {
                        case .finished:
                            break
                        case .failure(let error):
                            completion(.failure(error))
                        }
                    },
                    receiveValue: { checkInCount in
                        completion(.success(checkInCount))
                    }
                )
                .store(in: &cancellables)
        }
    
    func fetchTodayCheckInAndCheckOutCounts(completion: @escaping (Result<TodayCheckInOutResponse, Error>) -> Void) {
        guard let url = URL(string: "\(baseURL)/rooms/today-checkin-checkout") else {
            completion(.failure(URLError(.badURL)))
            return
        }
        
        URLSession.shared.dataTaskPublisher(for: url)
            .tryMap { result -> Data in
                guard let response = result.response as? HTTPURLResponse, response.statusCode == 200 else {
                    throw URLError(.badServerResponse)
                }
                return result.data
            }
            .decode(type: TodayCheckInOutResponse.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { completionResult in
                    switch completionResult {
                    case .finished:
                        break
                    case .failure(let error):
                        completion(.failure(error))
                    }
                },
                receiveValue: { response in
                    completion(.success(response))
                }
            )
            .store(in: &cancellables)
    }
    
   
    
    func fetchCurrentMonthSales(completion: @escaping (Result<SalesResponse, Error>) -> Void) {
        guard let url = URL(string: "\(baseURL)/sales/current-month") else {
            completion(.failure(URLError(.badURL)))
            return
        }
        
        URLSession.shared.dataTaskPublisher(for: url)
            .tryMap { result -> Data in
                guard let response = result.response as? HTTPURLResponse, response.statusCode == 200 else {
                    throw URLError(.badServerResponse)
                }
                return result.data
            }
            .decode(type: SalesResponse.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { completionResult in
                    switch completionResult {
                    case .finished:
                        break
                    case .failure(let error):
                        completion(.failure(error))
                    }
                },
                receiveValue: { salesResponse in
                    completion(.success(salesResponse))
                }
            )
            .store(in: &cancellables)
    }
    
    func fetchTodaySales(completion: @escaping (Result<SalesResponse, Error>) -> Void) {
        guard let url = URL(string: "\(baseURL)/sales/today") else {
            completion(.failure(URLError(.badURL)))
            return
        }
        
        URLSession.shared.dataTaskPublisher(for: url)
            .tryMap { result -> Data in
                guard let response = result.response as? HTTPURLResponse, response.statusCode == 200 else {
                    throw URLError(.badServerResponse)
                }
                return result.data
            }
            .decode(type: SalesResponse.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { completionResult in
                    switch completionResult {
                    case .finished:
                        break
                    case .failure(let error):
                        completion(.failure(error))
                    }
                },
                receiveValue: { salesResponse in
                    completion(.success(salesResponse))
                }
            )
            .store(in: &cancellables)
    }
    
    
    func fetchRoomRentStatus(completion: @escaping (Result<PaymentTypeCounts, Error>) -> Void) {
        guard let url = URL(string: "\(baseURL)/rooms/payment-types") else {
            completion(.failure(URLError(.badURL)))
            return
        }
        
        URLSession.shared.dataTaskPublisher(for: url)
            .tryMap { result -> Data in
                guard let response = result.response as? HTTPURLResponse, response.statusCode == 200 else {
                    throw URLError(.badServerResponse)
                }
                return result.data
            }
            .decode(type: PaymentTypeCounts.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { completionResult in
                    switch completionResult {
                    case .finished:
                        break
                    case .failure(let error):
                        completion(.failure(error))
                    }
                },
                receiveValue: { paymentTypeCounts in
                    completion(.success(paymentTypeCounts))
                }
            )
            .store(in: &cancellables)
    }
}
