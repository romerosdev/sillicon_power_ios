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

// MARK: - Movie Content
struct MovieContent: Equatable {
    var page: Int = 0
    var canLoadNextPage = true
    var movies: [Movie] = []
}

// MARK: - Movie Response
struct MovieResponse: Codable, Equatable {
    let page: Int
    let totalPages: Int
    let totalResults: Int
    let movies: [Movie]
    
    enum CodingKeys: String, CodingKey {
        case page
        case totalPages = "total_pages"
        case totalResults = "total_results"
        case movies = "results"
    }
}

// MARK: - Movie
struct Movie: Codable, Identifiable, Equatable, Hashable {
    let id: Int
    let firstAirDate: Date
    let name: String
    let originalName: String
    let originalLanguage: String
    let overview: String
    let genreIDS: [Int]
    let originCountry: [String]
    let posterPath: String? // Can be nil
    let backdropPath: String? // Can be nil
    let popularity: Double
    let voteCount: Int
    let voteAverage: Double

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
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

extension Movie {
    
    static var dummyData: [Movie] {
        [
            .init(id: 31917,
                  firstAirDate: Date(timeIntervalSince1970: 1275998400),
                  name: "Pretty Little Liars",
                  originalName: "Pretty Little Liars",
                  originalLanguage: "en",
                  overview: "Based on the Pretty Little Liars series of young adult novels by Sara Shepard, the series follows the lives of four girls — Spencer, Hanna, Aria, and Emily — whose clique falls apart after the disappearance of their queen bee, Alison. One year later, they begin receiving messages from someone using the name \"A\" who threatens to expose their secrets — including long-hidden ones they thought only Alison knew.",
                  genreIDS: [18, 9648],
                  originCountry: ["US"],
                  posterPath: "/vC324sdfcS313vh9QXwijLIHPJp.jpg",
                  backdropPath: "/rQGBjWNveVeF8f2PGRtS85w9o9r.jpg",
                  popularity: 47.432451,
                  voteCount: 133,
                  voteAverage: 5.04),
            .init(id: 62560,
                  firstAirDate: Date(timeIntervalSince1970: 1432728000),
                  name: "Mr. Robot",
                  originalName: "Mr. Robot",
                  originalLanguage: "en",
                  overview: "A contemporary and culturally resonant drama about a young programmer, Elliot, who suffers from a debilitating anti-social disorder and decides that he can only connect to people by hacking them. He wields his skills as a weapon to protect the people that he cares about. Elliot will find himself in the intersection between a cybersecurity firm he works for and the underworld organizations that are recruiting him to bring down corporate America.",
                  genreIDS: [18, 80],
                  originCountry: ["US"],
                  posterPath: "/esN3gWb1P091xExLddD2nh4zmi3.jpg",
                  backdropPath: "/v8Y9yurHuI7MujWQMd8iL3Gy4B5.jpg",
                  popularity: 37.882356,
                  voteCount: 287,
                  voteAverage: 7.5),
            .init(id: 37680,
                  firstAirDate: Date(timeIntervalSince1970: 1308830400),
                  name: "Suits",
                  originalName: "Suits",
                  originalLanguage: "en",
                  overview: "While running from a drug deal gone bad, Mike Ross, a brilliant young college-dropout, slips into a job interview with one of New York City's best legal closers, Harvey Specter. Tired of cookie-cutter law school grads, Harvey takes a gamble by hiring Mike on the spot after he recognizes his raw talent and photographic memory. Mike and Harvey are a winning team. Even though Mike is a genius, he still has a lot to learn about law. And while Harvey may seem like an emotionless, cold-blooded shark, Mike's sympathy and concern for their cases and clients will help remind Harvey why he went into law in the first place. Mike's other allies in the office include the firm's best paralegal Rachel and Harvey's no-nonsense assistant Donna to help him serve justice. Proving to be an irrepressible duo and invaluable to the practice, Mike and Harvey must keep their secret from everyone including managing partner Jessica and Harvey's arch nemesis Louis, who seems intent on making Mike's life as difficult as possible.",
                  genreIDS: [18],
                  originCountry: ["US"],
                  posterPath: "/i6Iu6pTzfL6iRWhXuYkNs8cPdJF.jpg",
                  backdropPath: "/8SAQqivlp74MZ7u55ccR1xa0Nby.jpg",
                  popularity: 34.376914,
                  voteCount: 161,
                  voteAverage: 6.94),
            .init(id: 1399,
                  firstAirDate: Date(timeIntervalSince1970: 1303041600),
                  name: "Game of Thrones",
                  originalName: "Game of Thrones",
                  originalLanguage: "en",
                  overview: "Seven noble families fight for control of the mythical land of Westeros. Friction between the houses leads to full-scale war. All while a very ancient evil awakens in the farthest north. Amidst the war, a neglected military order of misfits, the Night's Watch, is all that stands between the realms of men and icy horrors beyond.",
                  genreIDS: [18, 10759, 10765],
                  originCountry: ["US"],
                  posterPath: "/jIhL6mlT7AblhbHJgEoiBIOUVl1.jpg",
                  backdropPath: "/mUkuc2wyV9dHLG0D0Loaw5pO2s8.jpg",
                  popularity: 29.780826,
                  voteCount: 1172,
                  voteAverage: 7.91),
        ]
    }
}
