//
//  MovieDetailView.swift
//  Sillicon Power
//
//  Created by Raul Romero on 24/4/22.
//

import SwiftUI
import URLImage

struct MovieDetailView: View {
    
    @Environment(\.presentationMode) private var presentationMode
    let movie: Movie
    let baseUrl = UserDefaults.standard.string(forKey: "secure_base_url")
    
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
                            Rectangle()
                                .foregroundColor(Color.gray.opacity(0.2))
                                .overlay(
                                    ProgressView()
                                )
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
                        .environment(\.urlImageOptions,
                                      .init(fetchPolicy: .returnStoreElseLoad(downloadDelay: nil)))
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
                                            } failure: { error, retry in
                                                // Downloading error
                                            } content: { image in
                                                // Downloaded successfully
                                                image
                                                    .resizable()
                                                    .aspectRatio(contentMode: .fit)
                                                    .frame(width: 60, height: 60)
                                                    .padding(5)
                                                    .cornerRadius(5)
                                                    .overlay(
                                                        RoundedRectangle(cornerRadius: 5)
                                                            .stroke(Color.accentColor, lineWidth: 2)
                                                    )
                                                    .padding(.leading, 5)
                                                    .accessibilityLabel(Text(network.name))
                                            }
                                            .environment(\.urlImageOptions,
                                                          .init(fetchPolicy: .returnStoreElseLoad(downloadDelay: nil)))
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
                    Spacer()
                    Image(systemName: "xmark")
                        .resizable()
                        .frame(width: 15, height: 15)
                        .padding(10)
                        .foregroundColor(.white)
                        .background(Color.black.opacity(0.5))
                        .clipShape(Circle())
                        .padding(15)
                        .onTapGesture {
                            self.presentationMode.wrappedValue.dismiss()
                        }
                }
                Spacer()
            }
        }
    }
}

struct MovieBackdropPlaceholderView: View {

    let movie: Movie
    
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
