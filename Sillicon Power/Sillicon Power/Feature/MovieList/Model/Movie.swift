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
import RealmSwift

/// Formatter for ISO8601 (year-month-day).
let iso8601Formatter: DateFormatter = {
    let dateFormatter = DateFormatter()
    dateFormatter.locale = Locale(identifier: "en_US_POSIX")
    dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
    dateFormatter.dateFormat = "yyyy-MM-dd"
    
    return dateFormatter
}()

// MARK: - Movie
class Movie: Object, Codable, Identifiable  {
    @Persisted(primaryKey: true) var id: Int
    @Persisted var firstAirDate: String?
    @Persisted var name: String?
    @Persisted var originalName: String?
    @Persisted var originalLanguage: String?
    @Persisted var overview: String?
    @Persisted var posterPath: String?
    @Persisted var backdropPath: String?
    @Persisted var popularity: Double?
    @Persisted var voteCount: Int?
    @Persisted var voteAverage: Double?
    @Persisted var seasons: Int?
    @Persisted var episodes: Int?
    @Persisted var homepage: String?
    
    var networks: [Network]?
    var episodeRunTime: [Int]?
    var genres: [Genre]?
    
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
        case posterPath = "poster_path"
        case backdropPath = "backdrop_path"
        case popularity
        case voteCount = "vote_count"
        case voteAverage = "vote_average"
        case seasons = "number_of_seasons"
        case episodes = "number_of_episodes"
        case homepage
        
        case networks
        case episodeRunTime = "episode_run_time"
        case genres
    }
    
    convenience init(id: Int, firstAirDate: String?, name: String?, originalName: String?, originalLanguage: String?, overview: String?, posterPath: String?, backdropPath: String?, popularity: Double?, voteCount: Int?, voteAverage: Double?, seasons: Int?, episodes: Int?, homepage: String?, networks: [Network]?, episodeRunTime: [Int]?, genres: [Genre]?) {
        self.init()
        
        self.id = id
        self.firstAirDate = firstAirDate
        self.name = name
        self.originalName = originalName
        self.originalLanguage = originalLanguage
        self.overview = overview
        self.posterPath = posterPath
        self.backdropPath = backdropPath
        self.popularity = popularity
        self.voteCount = voteCount
        self.voteAverage = voteAverage
        self.seasons = seasons
        self.episodes = episodes
        self.homepage = homepage
        
        self.networks = networks
        self.episodeRunTime = episodeRunTime
        self.genres = genres
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
              posterPath: "/x6FsYvt33846IQnDSFxla9j0RX8.jpg",
              backdropPath: "/tGWTz0aQrTaeGjax5Rlyhz7ImWD.jpg",
              popularity: 8112.226,
              voteCount: 373,
              voteAverage: 8.5,
              seasons: 1,
              episodes: 6,
              homepage: "https://www.disneyplus.com/series/moon-knight/4S3oOF1knocS",
              networks: [],
              episodeRunTime: [
                47
              ],
              genres: [
                Genre(id: 9648, name: "Mystery")
              ]
        )
    }
}
