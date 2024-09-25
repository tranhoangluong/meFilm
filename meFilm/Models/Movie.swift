//
//  Movies.swift
//  meFilm
//
//  Created by Tran Chu Hoang Luong on 26/8/24.
//

struct TrendingAllResponse: Codable{
    let results : [Movie]
}

struct PopularMoviesResponse: Codable{
    let results: [Movie]
}

struct PopularTVSeriesResponse: Codable{
    let results: [Movie]
}


struct TopRatedMoviesResponse: Codable{
    let results: [Movie]
}

struct UpComingMoviesResponse: Codable{
    let results: [Movie]
}

struct SearchMoviesResponse: Codable{
    let results: [Movie]
}

struct SimilarMoviesResponse: Codable{
    let results: [Movie]
}

struct Movie: Codable{
    let id: Int
    let media_type: String?
    let original_name: String?
    let original_title: String?
    let poster_path: String?
    let overview: String?
    let vote_count: Int
    let release_date: String?
    let vote_average: Double
}

struct MovieDetail: Codable{
    let id: Int
    let original_name: String?
    let original_title: String?
    let poster_path: String?
    let overview: String?
    let release_date: String?
    let vote_average: Double
    let runtime: Int
    let genres: [Genres]
    let status: String
}

struct Genres: Codable{
    let id: Int
    let name: String?
}
