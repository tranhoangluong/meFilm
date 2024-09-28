//
//  Movies.swift
//  meFilm
//
//  Created by Tran Chu Hoang Luong on 26/8/24.
//

struct Results: Codable{
    let results : [Movie]
}

struct Movie: Codable{
    let id: Int
    let media_type: String?
    let original_title: String?
    let poster_path: String?
    let overview: String?
    let vote_count: Int
    let release_date: String?
    let vote_average: Double
}

struct MovieDetail: Codable{
    let id: Int
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
