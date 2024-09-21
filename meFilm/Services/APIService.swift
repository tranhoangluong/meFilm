//
//  APIService.swift
//  meFilm
//
//  Created by Tran Chu Hoang Luong on 11/9/24.

import Foundation

struct Constants{
    
    static let API_KEY = "45962c4e7ae642360f74813a91c83582"
    static let base_URL = "https://api.themoviedb.org"
    static let imageBase_URL = "https://image.tmdb.org/t/p/w500/"
}

enum APIError: Error{
    case failedGetData
}

class APICaller{
    
    static let shared = APICaller()
    
    func getTrendingAll(completion: @escaping (Result<[Movie], Error>) -> Void){
        guard let url = URL(string: "\(Constants.base_URL)/3/trending/all/day?api_key=\(Constants.API_KEY)") else {return}
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, response, error in
            guard let data = data, error == nil else {
                return
            }
            
            do {
                let results = try JSONDecoder().decode(TrendingAllResponse.self, from: data)
                completion(.success(results.results))
            }
            catch{
                completion(.failure(APIError.failedGetData))
            }
        }
        task.resume()
    }
 
    
    func getPopularMovies(completion: @escaping (Result<[Movie], Error>) -> Void){
        guard let url = URL(string: "\(Constants.base_URL)/3/movie/popular?api_key=\(Constants.API_KEY)") else {return}
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, response, error in
            guard let data = data, error == nil else {
                return
            }
            
            do {
                let results = try JSONDecoder().decode(PopularMoviesResponse.self, from: data)
                completion(.success(results.results))
            }
            catch{
                completion(.failure(APIError.failedGetData))
            }
        }
        task.resume()
    }
    
    func getPopularTVSeries(completion: @escaping (Result<[Movie], Error>) -> Void){
        guard let url = URL(string: "\(Constants.base_URL)/3/tv/popular?api_key=\(Constants.API_KEY)") else {return}
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, response, error in
            guard let data = data, error == nil else {
                return
            }
            
            do {
                let results = try JSONDecoder().decode(PopularTVSeriesResponse.self, from: data)
                completion(.success(results.results))
            }
            catch{
                completion(.failure(APIError.failedGetData))
            }
        }
        task.resume()
    }
    
}
