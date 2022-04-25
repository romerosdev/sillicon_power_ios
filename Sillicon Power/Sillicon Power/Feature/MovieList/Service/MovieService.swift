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
    func getConfiguration() async throws -> ConfigurationResponse
    func getMovies(language: String, page: Int) async throws -> MovieResponse
    func getMovieDetail(id: Int, language: String) async throws -> Movie
}

/// Service implementation.
struct MovieServiceImpl: MovieService {
    
    /// Get the system wide configuration information.
    /// - Returns: Response with configuration information.
    func getConfiguration() async throws -> ConfigurationResponse {
        // Pre-configuration
        let urlSession = URLSession.shared
        
        // Add query params
        var urlComps = URLComponents(string: TheMovieDBAPI.configuration.url)
        var queryItems: [URLQueryItem] = urlComps?.queryItems ?? []
        queryItems.append(URLQueryItem(name: "api_key", value: TheMovieDBAPI.apiKey))
        urlComps?.queryItems = queryItems
        
        guard let url = urlComps?.url else {
            throw APIError.invalidRequestError
        }
        
        // Get from API
        do {
            let (data, response) = try await urlSession.data(from: url)
            
            try handleErrors(data: data, response: response)
            
            let decoder = JSONDecoder()
            return try decoder.decode(ConfigurationResponse.self, from: data)
            
        } catch let error as DecodingError {
            throw APIError.decodingError(error)
        } catch let error as URLError {
            throw APIError.transportError(error)
        }
    }
    
    /// Get a list of the current popular TV shows on TMDB. This list updates daily.
    /// - Parameters:
    ///   - language: Pass a ISO 639-1 value to display translated data for the fields that support it.
    ///   - page: Specify which page to query.
    /// - Returns: Response with a list of the current popular TV shows.
    func getMovies(language: String, page: Int) async throws -> MovieResponse {
        // Pre-configuration
        let urlSession = URLSession.shared
        
        // Add query params
        var urlComps = URLComponents(string: TheMovieDBAPI.getMovies.url)
        var queryItems: [URLQueryItem] = urlComps?.queryItems ?? []
        queryItems.append(URLQueryItem(name: "api_key", value: TheMovieDBAPI.apiKey))
        queryItems.append(URLQueryItem(name: "language", value: language))
        queryItems.append(URLQueryItem(name: "page", value: String(page)))
        urlComps?.queryItems = queryItems
        
        guard let url = urlComps?.url else {
            throw APIError.invalidRequestError
        }
        
        // Get from API
        do {
            let (data, response) = try await urlSession.data(from: url)
            
            try handleErrors(data: data, response: response)
            
            let decoder = JSONDecoder()
            return try decoder.decode(MovieResponse.self, from: data)
            
        } catch let error as DecodingError {
            throw APIError.decodingError(error)
        } catch let error as URLError {
            throw APIError.transportError(error)
        }
    }
    
    /// Get the primary TV show details by id.
    /// - Parameters:
    ///   - id: Movie id.
    ///   - language: Pass a ISO 639-1 value to display translated data for the fields that support it.
    /// - Returns: Response with all movie details.
    func getMovieDetail(id: Int, language: String) async throws -> Movie {
        // Pre-configuration
        let urlSession = URLSession.shared
        
        // Add query params
        var urlComps = URLComponents(string: TheMovieDBAPI.getMovieDetail(id).url)
        var queryItems: [URLQueryItem] = urlComps?.queryItems ?? []
        queryItems.append(URLQueryItem(name: "api_key", value: TheMovieDBAPI.apiKey))
        queryItems.append(URLQueryItem(name: "language", value: language))
        urlComps?.queryItems = queryItems
        
        guard let url = urlComps?.url else {
            throw APIError.invalidRequestError
        }
        
        // Get from API
        do {
            let (data, response) = try await urlSession.data(from: url)
            
            try handleErrors(data: data, response: response)
            
            let decoder = JSONDecoder()
            return try decoder.decode(Movie.self, from: data)
            
        } catch let error as DecodingError {
            throw APIError.decodingError(error)
        } catch let error as URLError {
            throw APIError.transportError(error)
        }
    }
    
    /// Handle common API errors.
    /// - Parameters:
    ///   - data: Received data.
    ///   - response: Reveived response.
    private func handleErrors(data: Data, response: URLResponse) throws {
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
    }
}
