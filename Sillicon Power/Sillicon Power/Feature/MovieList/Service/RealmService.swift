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
import os

/// Protocol to implement on service implementation.
protocol RealmService {
    func addMovie(movie: Movie)
    func addMovies(movies: [Movie])
    func getMovies() -> [Movie]
    func deleteMovie(id: Int)
    func deleteAll()
}

/// Service implementation.
class RealmServiceImpl: RealmService {
    
    // MARK: - Properties
    
    let logger = Logger(subsystem: Bundle.main.bundleIdentifier!, category: "offline")
    private(set) var localRealm: Realm?
    
    // MARK: - Initialisation methods
    
    /// Custom initialisation.
    init() {
        openRealm()
    }
    
    /// Open local database.
    private func openRealm() {
        do {
            let config = Realm.Configuration(schemaVersion: 1, migrationBlock: { migration, oldSchemaVersion in
                if oldSchemaVersion > 1 {
                    // Do something, usually updating the schema's variables here
                }
            })
            
            Realm.Configuration.defaultConfiguration = config
            
            localRealm = try Realm()
        } catch {
            logger.error("📚 Offline - Initialisation error: \(error.localizedDescription)")
        }
    }
    
    // MARK: - Realm CRUD methods
    
    /// Add movie to local database.
    /// - Parameter movie: Movie to be added.
    func addMovie(movie: Movie) {
        if let localRealm = localRealm {
            do {
                try localRealm.write {
                    localRealm.add(movie, update: .modified)
                    logger.info("📚 Offline - Added new movie - ID: \(movie.id)")
                }
            } catch {
                logger.error("📚 Offline - Error adding movie: \(error.localizedDescription)")
            }
        }
    }
    
    /// Add a list of movies to local database.
    /// - Parameter movies: List of movies to be added.
    func addMovies(movies: [Movie]) {
        if let localRealm = localRealm {
            do {
                try localRealm.write {
                    localRealm.add(movies, update: .modified)
                    logger.info("📚 Offline - Added list of movies - Count: \(movies.count)")
                }
            } catch {
                logger.error("📚 Offline - Error adding list of movies - \(error.localizedDescription)")
            }
        }
    }
    
    /// Get movies from local database.
    /// - Returns: List of saved movies.
    func getMovies() -> [Movie] {
        var movies: [Movie] = []
        if let localRealm = localRealm {
            let allMovies = localRealm.objects(Movie.self)
            allMovies.forEach { movie in
                movies.append(movie)
            }
        }
        return movies
    }
    
    /// Delete movie from local database.
    /// - Parameter id: Movie identifier.
    func deleteMovie(id: Int) {
        if let localRealm = localRealm {
            let allMovies = localRealm.objects(Movie.self)
            let movie = allMovies.filter("id == \(id)")
            guard !movie.isEmpty else { return }
            
            do {
                try localRealm.write {
                    localRealm.delete(movie)
                    logger.info("📚 Offline - Movie deleted - ID: \(id)")
                }
            } catch {
                logger.error("📚 Offline - Error deleting movie - \(error.localizedDescription)")
            }
            
        }
    }
    
    /// Delete all movies from local database.
    func deleteAll() {
        if let localRealm = localRealm {
            do {
                try localRealm.write {
                    localRealm.deleteAll()
                    logger.info("📚 Offline - All movies deleted")
                }
            } catch {
                logger.error("📚 Offline - Error deleting all movies - \(error.localizedDescription)")
            }
            
        }
    }
}
