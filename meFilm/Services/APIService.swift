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
    
    static let YOUTUBE_API_KEY = "AIzaSyB3Cvph9oNXqU7mluOTCTbxvZuiqwrcY5A"
    static let youtubeBase_URL = "https://youtube.googleapis.com/youtube/v3/search?"
}

enum APIError: Error{
    case failedGetData
}

class APICaller{
    
    static let shared = APICaller()
    
    func getTrendingMovies(completion: @escaping (Result<[Movie], Error>) -> Void){
        guard let url = URL(string: "\(Constants.base_URL)/3/trending/movie/day?api_key=\(Constants.API_KEY)") else {return}
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, response, error in
            guard let data = data, error == nil else {
                return
            }
            
            do {
                let results = try JSONDecoder().decode(Results.self, from: data)
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
                let results = try JSONDecoder().decode(Results.self, from: data)
                completion(.success(results.results))
            }
            catch{
                completion(.failure(APIError.failedGetData))
            }
        }
        task.resume()
    }
    
    func getNowPlayingMovies(completion: @escaping (Result<[Movie], Error>) -> Void){
        guard let url = URL(string: "\(Constants.base_URL)/3/movie/now_playing?api_key=\(Constants.API_KEY)") else {return}
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, response, error in
            guard let data = data, error == nil else {
                return
            }
            
            do {
                let results = try JSONDecoder().decode(Results.self, from: data)
                completion(.success(results.results))
            }
            catch{
                completion(.failure(APIError.failedGetData))
            }
        }
        task.resume()
    }
    
    func getTopRatedMovies(completion: @escaping (Result<[Movie], Error>) -> Void){
        guard let url = URL(string: "\(Constants.base_URL)/3/movie/top_rated?api_key=\(Constants.API_KEY)") else {return}
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, response, error in
            guard let data = data, error == nil else {
                return
            }
            
            do {
                let results = try JSONDecoder().decode(Results.self, from: data)
                completion(.success(results.results))
            }
            catch{
                completion(.failure(APIError.failedGetData))
            }
        }
        task.resume()
    }
    
    func getUpComingMovies(completion: @escaping (Result<[Movie], Error>) -> Void){
        guard let url = URL(string: "\(Constants.base_URL)/3/movie/upcoming?api_key=\(Constants.API_KEY)") else {return}
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, response, error in
            guard let data = data, error == nil else {
                return
            }
            
            do {
                let results = try JSONDecoder().decode(Results.self, from: data)
                completion(.success(results.results))
            }
            catch{
                completion(.failure(APIError.failedGetData))
            }
        }
        task.resume()
    }
    
    func search(with query: String, completion: @escaping (Result<[Movie], Error>) -> Void) {
        guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {return}
        guard let url = URL(string: "\(Constants.base_URL)/3/search/movie?api_key=\(Constants.API_KEY)&query=\(query)") else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            do {
                let results = try JSONDecoder().decode(Results.self, from: data)
                completion(.success(results.results))

            } catch {
                completion(.failure(APIError.failedGetData))
            }

        }
        task.resume()
    }
    
    func getSimilarMovies(movieId: Int, completion: @escaping (Result<[Movie], Error>) -> Void){
        guard let url = URL(string: "\(Constants.base_URL)/3/movie/\(movieId)/similar?api_key=\(Constants.API_KEY)") else {return}
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, response, error in
            guard let data = data, error == nil else {
                return
            }
            
            do {
                let results = try JSONDecoder().decode(Results.self, from: data)
                completion(.success(results.results))
            }
            catch{
                completion(.failure(APIError.failedGetData))
            }
        }
        task.resume()
    }
    
    func getDetailMovie(movieId: Int, completion: @escaping (Result<MovieDetail, Error>) -> Void){
        guard let url = URL(string: "\(Constants.base_URL)/3/movie/\(movieId)?api_key=\(Constants.API_KEY)") else {return}
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, response, error in
            guard let data = data, error == nil else {
                return
            }
            
            do {
                let results = try JSONDecoder().decode(MovieDetail.self, from: data)
                completion(.success(results))
            }
            catch{
                completion(.failure(APIError.failedGetData))
            }
        }
        task.resume()
    }
    
    func getTrailer(with query: String, completion: @escaping (Result<Video, Error>) -> Void) {
           guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {return}
           guard let url = URL(string: "\(Constants.youtubeBase_URL)q=\(query)&key=\(Constants.YOUTUBE_API_KEY)") else {return}
           let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
               guard let data = data, error == nil else {
                   return
               }
               
               do {
                   let results = try JSONDecoder().decode(YoutubeSearchResult.self, from: data)
                   
                   completion(.success(results.items[0]))
                   

               } catch {
                   completion(.failure(error))
                   print(error.localizedDescription)
               }

           }
           task.resume()
       }
    
}
