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

enum MovieAPI {
    case getMovies
}

extension MovieAPI: APIBuilder {
    
    static let apiKey = "c6aeee5775a38e487b74dfede5deb"
    
    var baseUrl: String {
        switch self {
        case .getMovies:
            return "https://api.themoviedb.org/3"
        }
    }
    
    var path: String {
        switch self {
        case .getMovies:
            return "/tv/popular"
        }
    }
    
    var url: String {
        switch self {
        case .getMovies:
            return self.baseUrl + self.path
        }
    }
}
