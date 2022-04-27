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

import SwiftUI
import URLImage

struct MovieDetailView: View {
    
    // MARK: - Properties
    
    @Environment(\.presentationMode) private var presentationMode
    @Environment(\.openURL) var openURL
    let movie: Movie
    let baseUrl = UserDefaults.standard.string(forKey: "secure_base_url")
    
    // MARK: - UI
    
    var body: some View {
        ZStack {
            ScrollView {
                LazyVStack(spacing: 15) {
                    if let baseUrl = baseUrl, let path = movie.backdropPath, let url = URL(string: baseUrl + "/w780" + path) {
                        URLImage(url, identifier: url.absoluteString) {
                            // This view is displayed before download starts
                            EmptyView()
                        } inProgress: { progress in
                            // Display progress
                            MovieBackdropPlaceholderView(movie: movie)
                        } failure: { error, retry in
                            // Downloading error
                            MovieBackdropPlaceholderView(movie: movie)
                        } content: { image in
                            // Downloaded successfully
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .applyHeaderStyle(movie: movie)
                        }
                    } else {
                        // No url from API
                        MovieBackdropPlaceholderView(movie: movie)
                    }
                    
                    VStack(spacing: 15) {
                        
                        if let networks = movie.networks, let baseUrl = baseUrl, !networks.isEmpty {
                            Text("NETWORKS".localized())
                                .font(.system(size: 18, weight: .bold))
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.horizontal, 15)
                                .accessibilityLabel(Text("NETWORKS".localized()))
                            ScrollView(.horizontal, showsIndicators: false) {
                                LazyHStack {
                                    ForEach(networks, id:\.id) { network in
                                        if let path = network.logoPath, let url = URL(string: baseUrl + "/w92" + path) {
                                            URLImage(url, identifier: url.absoluteString) {
                                                // This view is displayed before download starts
                                                EmptyView()
                                            } inProgress: { progress in
                                                // Display progress
                                                ProgressView()
                                                    .applyNetworkStyle()
                                            } failure: { error, retry in
                                                // Downloading error
                                                Text(network.name)
                                                    .applyNetworkStyle()
                                                    .accessibilityLabel(Text(network.name))
                                            } content: { image in
                                                // Downloaded successfully
                                                image
                                                    .resizable()
                                                    .aspectRatio(contentMode: .fit)
                                                    .applyNetworkStyle()
                                                    .accessibilityLabel(Text(network.name))
                                            }
                                        }
                                    }
                                }
                            }
                            .frame(height: 70, alignment: .center)
                            
                            Divider()
                                .background(Color.accentColor)
                        }
                        
                        if let genres = movie.genres, !genres.isEmpty {
                            Text("GENRES".localized())
                                .font(.system(size: 18, weight: .bold))
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.horizontal, 15)
                                .accessibilityLabel(Text("GENRES".localized()))
                            ScrollView(.horizontal, showsIndicators: false) {
                                LazyHStack {
                                    ForEach(genres, id:\.id) { genre in
                                        Text(genre.name)
                                            .padding(8)
                                            .foregroundColor(.white)
                                            .background(Color.accentColor)
                                            .clipShape(RoundedRectangle(cornerRadius: 5))
                                            .padding(.leading, 5)
                                            .accessibilityLabel(Text(genre.name))
                                    }
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                            }
                            .frame(height: 40, alignment: .center)
                            
                            Divider()
                                .background(Color.accentColor)
                        }
                        
                        if let overview = movie.overview, !overview.isEmpty {
                            Group {
                                Text("SYNOPSIS".localized())
                                    .font(.system(size: 18, weight: .bold))
                                    .accessibilityLabel(Text("SYNOPSIS".localized()))
                                Text(overview)
                            }
                            .padding(.horizontal, 15)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        
                        Spacer()
                    }
                    Spacer()
                }
            }
            
            VStack(alignment:.trailing) {
                HStack {
                    Image(systemName: "chevron.down.circle")
                        .resizable()
                        .frame(width: 25, height: 25)
                        .padding(5)
                        .foregroundColor(.white)
                        .background(Color.black.opacity(0.5))
                        .clipShape(Circle())
                        .padding(15)
                        .onTapGesture {
                            self.presentationMode.wrappedValue.dismiss()
                        }
                    Spacer()
                    if let link = movie.homepage, !link.isEmpty {
                        Image(systemName: "arrowshape.turn.up.forward.circle")
                            .resizable()
                            .frame(width: 25, height: 25)
                            .padding(5)
                            .foregroundColor(.white)
                            .background(Color.black.opacity(0.5))
                            .clipShape(Circle())
                            .padding(15)
                            .onTapGesture {
                                load(url: link)
                            }
                    }
                }
                Spacer()
            }
        }
    }
    
    func load(url: String?) {
        guard let url = url,
              let linkUrl = URL(string: url) else {
            return
        }
        openURL(linkUrl)
    }
}

struct MovieBackdropPlaceholderView: View {
    
    // MARK: - Properties
    
    let movie: Movie
    
    // MARK: - UI
    
    var body: some View {
        Image("movie-backdrop-placeholder")
            .resizable()
            .aspectRatio(contentMode: .fill)
            .applyHeaderStyle(movie: movie)
            .clipped()
    }
}

struct MovieDetailView_Previews: PreviewProvider {
    static var previews: some View {
        MovieDetailView(movie: Movie.dummyData)
    }
}
