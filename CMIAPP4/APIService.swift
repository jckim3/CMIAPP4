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
    //https://www.carriagemotorinn.com:444/api/motel/room-metrics/by-year-month?year=2025&month=1
    func fetchRoomMetrics(year: Int, month: Int, completion: @escaping (Result<[RoomMetric], Error>) -> Void) {
           guard let url = URL(string: "\(baseURL)/room-metrics/by-year-month?year=\(year)&month=\(month)") else {
           //guard let url = URL(string: "\(baseURL)/room-metrics/by-year-month?year=2025&month=1") else {
               completion(.failure(URLError(.badURL)))
               return
           }

           URLSession.shared.dataTask(with: url) { data, response, error in
               if let error = error {
                   DispatchQueue.main.async {
                       completion(.failure(error))
                   }
                   return
               }

               guard let data = data else {
                   DispatchQueue.main.async {
                       completion(.failure(URLError(.badServerResponse)))
                   }
                   return
               }

               do {
                   let metrics = try JSONDecoder().decode([RoomMetric].self, from: data)
                   DispatchQueue.main.async {
                       completion(.success(metrics))
                   }
               } catch {
                   DispatchQueue.main.async {
                       completion(.failure(error))
                   }
               }
           }.resume()
       }
    
    
    
    
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
        // URL 출력
            print("Fetching revenue for year: \(year), URL: \(url)")
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
    
    func fetchRoomOccupancy(completion: @escaping (Result<RoomOccupancyResponse, Error>) -> Void) {
        guard let url = URL(string: "\(baseURL)/rooms/occupancy-data") else {
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
            .decode(type: RoomOccupancyResponse.self, decoder: JSONDecoder())
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
                receiveValue: { occupancyResponse in
                    completion(.success(occupancyResponse))
                }
            )
            .store(in: &cancellables)
    }
}
