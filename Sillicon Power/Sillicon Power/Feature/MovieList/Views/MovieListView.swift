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
    
    @StateObject var vm: MovieViewModelImpl
    
    init() {
        _vm = StateObject(wrappedValue: MovieViewModelImpl(service: MovieServiceImpl(), offlineService: RealmServiceImpl()))
    }
    
    var columns: [GridItem] = Array(repeating: .init(.adaptive(minimum: 150)), count: 2)
    
    var body: some View {
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
                NavigationView {
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
                        AlertToast(displayMode: .banner(.pop), type: .systemImage("exclamationmark.circle", Color.white), title: vm.error?.localizedDescription, style: .style(backgroundColor: Color.black.opacity(0.5), titleColor: Color.white))
                    }
                    .navigationTitle("MOVIE_LIST_TITLE".localized())
                }
            }
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
