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

import AlertToast
import SwiftUI

struct MovieListView: View {
    
    // MARK: - Properties
    
    @StateObject var vm: MovieViewModelImpl
    private var columns: [GridItem] = Array(repeating: .init(.adaptive(minimum: 150)), count: 2)
    
    // MARK: - Initialisation
    
    init() {
        _vm = StateObject(wrappedValue: MovieViewModelImpl(service: MovieServiceImpl(), offlineService: RealmServiceImpl()))
    }
    
    // MARK: - UI
    
    var body: some View {
        NavigationView {
            Group {
                switch vm.state {
                    
                case .loading:
                    AlertToast(type: .loading)
                    
                case .failed(let error):
                    ErrorView(error: error) {
                        Task {
                            await vm.getMovies()
                        }
                    }
                    
                default:
                    ScrollView {
                        LazyVGrid(columns: columns, spacing: 10) {
                            ForEach(vm.content.movies, id:\.id) { movie in
                                MovieView(movie: movie)
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                                    .onAppear {
                                        if vm.content.movies[vm.content.movies.count - 8].id == movie.id {
                                            Task {
                                                await vm.getMovies()
                                            }
                                        }
                                    }
                                    .onTapGesture {
                                        Task {
                                            await vm.getMovieDetail(movie: movie)
                                        }
                                    }
                            }
                        }
                        .padding(16)
                    }
                    .toast(isPresenting: $vm.hasError) {
                        AlertToast(displayMode: .banner(.pop),
                                   type: .systemImage("exclamationmark.circle",
                                                      Theme.textColor),
                                   title: vm.error?.localizedDescription,
                                   style: .style(backgroundColor: Theme.toastBackgroundColor,
                                                 titleColor: Theme.textColor))
                    }
                }
            }
            .navigationBarTitle("MOVIE_LIST_TITLE".localized())
        }
        .onAppear {
            Task {
                await vm.getConfiguration()
                await vm.getMovies()
            }
        }
        .sheet(isPresented: $vm.showDetail) {
            if let movie = vm.selectedMovie {
                MovieDetailView(movie: movie)
            }
        }
    }
}

struct MovieListView_Previews: PreviewProvider {
    static var previews: some View {
        MovieListView()
    }
}
