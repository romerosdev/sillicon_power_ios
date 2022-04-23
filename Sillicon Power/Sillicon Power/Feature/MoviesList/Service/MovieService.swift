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
import Combine

/// Protocol to implement on service implementation.
protocol MovieService {
    func getMovies(language: String, page: Int) async throws -> MovieResponse
}

/// Service implementation.
struct MovieServiceImpl: MovieService {
    
    /// Formatter for ISO8601 (year-month-day).
    static let iso8601Formatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        return dateFormatter
    }()
    
    /// Get a list of the current popular TV shows on TMDB. This list updates daily.
    /// - Parameters:
    ///   - language: Pass a ISO 639-1 value to display translated data for the fields that support it.
    ///   - page: Specify which page to query.
    /// - Returns: Response with a list of the current popular TV shows.
    func getMovies(language: String, page: Int) async throws -> MovieResponse {
        // Pre-configuration
        let urlSession = URLSession.shared
        
        // Add query params
        var urlComps = URLComponents(string: MovieAPI.getMovies.url)
        var queryItems: [URLQueryItem] = urlComps?.queryItems ?? []
        queryItems.append(URLQueryItem(name: "api_key", value: MovieAPI.apiKey))
        queryItems.append(URLQueryItem(name: "language", value: language))
        queryItems.append(URLQueryItem(name: "page", value: String(page)))
        urlComps?.queryItems = queryItems
        
        guard let url = urlComps?.url else {
            throw APIError.invalidRequestError
        }
        
        // Get a list from API if not exist some error
        do {
            let (data, response) = try await urlSession.data(from: url)
            
            guard let urlResponse = response as? HTTPURLResponse else {
                throw APIError.invalidResponse
            }
            
            if !(200...299).contains(urlResponse.statusCode) {
                if (400..<500) ~= urlResponse.statusCode {
                    let decoder = JSONDecoder()
                    let apiError = try decoder.decode(APIErrorMessage.self, from: data)
                    throw APIError.validationError(statusCode: urlResponse.statusCode, reason: apiError.statusMsg)
                } else if (500..<600) ~= urlResponse.statusCode {
                    throw APIError.serverError(statusCode: urlResponse.statusCode)
                }
            }
            
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .custom({ (decoder) -> Date in
                let data = try decoder.singleValueContainer().decode(String.self)
                let formatter = MovieServiceImpl.iso8601Formatter
                return formatter.date(from: data) ?? Date(timeIntervalSince1970: 0)
            })
            return try decoder.decode(MovieResponse.self, from: data)
            
        } catch let error as DecodingError {
            throw APIError.decodingError(error)
        } catch let error as URLError {
            throw APIError.transportError(error)
        }
    }
}
