////////////////////////////////////////////////////////////////////////////
//
// Copyright 2022. All rights reserved.
//
// Author: Raul Romero (raulromerodev@gmail.com)
//
// For the full copyright and license information, please view the LICENSE
// file that was distributed with this source code.
//
////////////////////////////////////////////////////////////////////////////

import Foundation

/// Formatter for ISO8601 (year-month-day).
let iso8601Formatter: DateFormatter = {
    let dateFormatter = DateFormatter()
    dateFormatter.locale = Locale(identifier: "en_US_POSIX")
    dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
    dateFormatter.dateFormat = "yyyy-MM-dd"
    
    return dateFormatter
}()

// MARK: - Movie
struct Movie: Codable, Identifiable, Equatable, Hashable {
    let id: Int
    let firstAirDate: String?
    let name: String?
    let originalName: String?
    let originalLanguage: String?
    let overview: String?
    let genreIDS: [Int]?
    let originCountry: [String]?
    let posterPath: String?
    let backdropPath: String?
    let popularity: Double?
    let voteCount: Int?
    let voteAverage: Double?
    
    let networks: [Network]?
    let episodeRunTime: [Int]?
    let genres: [Genre]?
    let languages: [String]?
    let seasons: Int?
    let episodes: Int?
    
    var date: Date? {
        guard let firstAirDate = firstAirDate else { return nil }
        let formatter = iso8601Formatter
        return formatter.date(from: firstAirDate)
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case firstAirDate = "first_air_date"
        case name
        case originalName = "original_name"
        case originalLanguage = "original_language"
        case overview
        case genreIDS = "genre_ids"
        case originCountry = "origin_country"
        case posterPath = "poster_path"
        case backdropPath = "backdrop_path"
        case popularity
        case voteCount = "vote_count"
        case voteAverage = "vote_average"
        
        case networks
        case episodeRunTime = "episode_run_time"
        case genres
        case languages
        case seasons = "number_of_seasons"
        case episodes = "number_of_episodes"
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

// MARK: - Genre
struct Genre: Codable, Identifiable, Equatable {
    let id: Int
    let name: String
}

// MARK: - Network
struct Network: Codable, Identifiable, Equatable {
    let id: Int
    let name: String
    let logoPath: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case logoPath = "logo_path"
    }
}

extension Movie {
    
    static var dummyData: Movie {
        .init(id: 92749,
              firstAirDate: "2022-03-30",
              name: "Moon Knight",
              originalName: "Moon Knight",
              originalLanguage: "en",
              overview: "When Steven Grant, a mild-mannered gift-shop employee, becomes plagued with blackouts and memories of another life, he discovers he has dissociative identity disorder and shares a body with mercenary Marc Spector. As Steven/Marc’s enemies converge upon them, they must navigate their complex identities while thrust into a deadly mystery among the powerful gods of Egypt.",
              genreIDS: [9648, 10759, 10765],
              originCountry: ["US"],
              posterPath: "/x6FsYvt33846IQnDSFxla9j0RX8.jpg",
              backdropPath: "/tGWTz0aQrTaeGjax5Rlyhz7ImWD.jpg",
              popularity: 8112.226,
              voteCount: 373,
              voteAverage: 8.5,
              networks: [],
              episodeRunTime: [47],
              genres: [
                Genre(id: 9648, name: "Mystery")
              ],
              languages: ["en"],
              seasons: 1,
              episodes: 6
        )
    }
}
