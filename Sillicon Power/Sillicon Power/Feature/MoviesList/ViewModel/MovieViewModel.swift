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

/// Protocol to implement on view model implementation.
protocol MovieViewModel {
    func getMovies() async
    func reset() async
}

/// View model implementation (part of MVVM arch)
@MainActor
final class MovieViewModelImpl: ObservableObject, MovieViewModel {
    
    /// Used to control view states (related to networking calls)
    enum State {
        case na
        case loading
        case success(data: MovieContent)
        case failed(error: Error)
    }
    
    // Combine properties
    @Published private(set) var state: State = .na
    @Published var hasError: Bool = false
    
    // Network service
    private let service: MovieService
    
    // Content used on pagination feature
    private(set) var content = MovieContent()
    
    /// View model initialisation.
    /// - Parameter service: Movie service instance.
    init(service: MovieService) {
        self.service = service
    }
    
    /// Get a list of the current popular TV shows on TMDB.
    func getMovies() async {
        // Control end of pagination
        guard self.content.canLoadNextPage else { return }
        
        // Loading state
        if content.movies.isEmpty {
            state = .loading
        }
        
        // Reset error flag
        hasError = false
        
        // Get movies bussiness logic
        do {
            let data = try await service.getMovies(language: "en-US", page: self.content.page + 1)
            content.movies += data.movies
            content.movies.removeDuplicates()
            content.page = data.page
            content.canLoadNextPage = data.page <= data.totalPages
            state = .success(data: content)
        } catch {
            state = .failed(error: error)
            hasError = true
        }
    }
    
    /// Reset all, e.g. used on pull to refresh feature.
    func reset() async {
        self.content = MovieContent()
        await getMovies()
    }
}
