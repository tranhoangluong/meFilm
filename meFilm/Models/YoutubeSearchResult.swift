//
//  YoutubeSearchResult.swift
//  meFilm
//
//  Created by Tran Chu Hoang Luong on 26/9/24.
//

import Foundation

struct YoutubeSearchResult: Codable{
    let items: [Video]
}

struct Video: Codable{
    let id: IdVideo
}

struct IdVideo: Codable{
    let kind: String
    let videoId: String
}
