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
    func getConfiguration() async
    func getMovies() async
    func getMovieDetail(movie: Movie) async
    func reset() async
}

/// View model implementation (part of MVVM arch)
@MainActor
final class MovieViewModelImpl: ObservableObject, MovieViewModel {
    
    // MARK: - Enums
    
    /// Used to control view states (related to networking calls)
    enum State {
        case na
        case loading
        case success(data: MovieContent)
        case failed(error: Error)
    }
    
    // MARK: - Properties
    
    // Combine properties
    @Published private(set) var state: State = .na
    @Published var hasError: Bool = false
    private(set) var error: Error?
    @Published var showDetail: Bool = false
    @Published var selectedMovie: Movie?
    
    // Network service
    private let service: MovieService
    // Offline service
    private let offlineService: RealmService
    
    // Content used on pagination feature
    private(set) var content = MovieContent()
    
    // MARK: - Initialisation
    
    /// View model initialisation.
    /// - Parameter service: Movie service instance.
    /// - Parameter offlineService: Movie offline service instance.
    init(service: MovieService, offlineService: RealmService) {
        self.service = service
        self.offlineService = offlineService
    }
    
    // MARK: - Methods
    
    /// Get the system wide configuration information.
    func getConfiguration() async {
        let defaults = UserDefaults.standard
        if let updated = defaults.object(forKey: "updated") as? Date, Calendar.current.numberOfDaysBetween(updated, and: Date()) < 5 { }
        else {
            do {
                let data = try await service.getConfiguration()
                defaults.set(data.images.secureBaseURL, forKey: "secure_base_url")
                defaults.set(Date(), forKey: "updated")
            } catch {
                // Harcoded option, not save updated key.
                defaults.set("https://image.tmdb.org/t/p/", forKey: "secure_base_url")
            }
        }
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
            let data = try await service.getMovies(language: "locale".localized(),
                                                   page: self.content.page + 1)
            content.movies += data.movies
            content.movies.removeDuplicates()
            offlineService.addMovies(movies: content.movies)
            content.page = data.page
            content.canLoadNextPage = data.page <= data.totalPages
            state = .success(data: content)
        } catch {
            self.error = error
            if case APIError.transportError(_) = error {
                let offlineMovies = offlineService.getMovies()
                content.movies += offlineMovies
                content.movies.removeDuplicates()
                if content.movies.isEmpty {
                    state = .failed(error: error)
                } else {
                    state = .success(data: content)
                }
            } else {
                if content.movies.isEmpty {
                    state = .failed(error: error)
                } else {
                    hasError.toggle()
                }
            }
        }
    }
    
    /// Get a list of the current popular TV shows on TMDB.
    func getMovieDetail(movie: Movie) async {
        
        // Get movies bussiness logic
        do {
            let data = try await service.getMovieDetail(id: movie.id,
                                                        language: "locale".localized())
            selectedMovie = data
            offlineService.addMovie(movie: data)
        } catch {
            selectedMovie = movie
        }
        showDetail.toggle()
    }
    
    /// Reset all, e.g. used on pull to refresh feature.
    func reset() async {
        self.content = MovieContent()
        await getMovies()
    }
}
