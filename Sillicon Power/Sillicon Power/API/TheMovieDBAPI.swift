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

protocol APIBuilder {
    var baseUrl: String { get }
    var path: String { get }
    var url: String { get }
}

enum TheMovieDBAPI {
    case configuration
    case getMovies
    case getMovieDetail(Int)
}

extension TheMovieDBAPI: APIBuilder {
    
    static let apiKey = "c6aeee577586ba38e487b74dfede5deb"
    
    var baseUrl: String {
        return "https://api.themoviedb.org/3"
    }
    
    var path: String {
        switch self {
        case .configuration:
            return "/configuration"
        case .getMovies:
            return "/tv/popular"
        case .getMovieDetail(let id):
            return "/tv/\(id)"
        }
    }
    
    var url: String {
        return self.baseUrl + self.path
    }
}
