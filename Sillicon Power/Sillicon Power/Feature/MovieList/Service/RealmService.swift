//
//  RealmManager.swift
//  Sillicon Power
//
//  Created by Raul Romero on 25/4/22.
//

import Foundation
import RealmSwift

/// Protocol to implement on service implementation.
protocol RealmService {
    func addMovie(movie: Movie)
    func addMovies(movies: [Movie])
    func getMovies() -> [Movie]
    func deleteMovie(id: Int)
}

/// Service implementation.
class RealmServiceImpl: RealmService {
    
    private(set) var localRealm: Realm?
    
    init() {
        openRealm()
    }

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
            print("Error opening Realm", error)
        }
    }
    
    func addMovie(movie: Movie) {
        if let localRealm = localRealm {
            do {
                try localRealm.write {
                    localRealm.add(movie, update: .modified)
                    print("Added new movie to Realm!")
                }
            } catch {
                print("Error adding movie to Realm", error)
            }
        }
    }
    
    func addMovies(movies: [Movie]) {
        if let localRealm = localRealm {
            do {
                try localRealm.write {
                    localRealm.add(movies, update: .modified)
                    print("Added list of movies to Realm!")
                }
            } catch {
                print("Error adding list of movies to Realm", error)
            }
        }
    }
    
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
    
    func deleteMovie(id: Int) {
        if let localRealm = localRealm {
            let allMovies = localRealm.objects(Movie.self)
            let movie = allMovies.filter("id == \(id)")
            guard !movie.isEmpty else { return }

            do {
                try localRealm.write {
                    localRealm.delete(movie)
                    print("Movie deleted from Realm")
                }
            } catch {
                print("Error deleting movie", error)
            }

        }
    }
}
