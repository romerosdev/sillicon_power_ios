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

import Combine
import SwiftUI
import URLImage

struct MovieView: View {
    
    let movie: Movie
    let baseUrl = UserDefaults.standard.string(forKey: "secure_base_url")
    
    var body: some View {
        if let baseUrl = baseUrl, let path = movie.posterPath, let url = URL(string: baseUrl + "/w780" + path) {
            URLImage(url, identifier: url.absoluteString) {
                // This view is displayed before download starts
                EmptyView()
            } inProgress: { progress in
                // Display progress
                MoviePosterPlaceholderView(movie: movie)
            } failure: { error, retry in
                // Downloading error
                MoviePosterPlaceholderView(movie: movie)
            } content: { image in
                // Downloaded successfully
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .accessibilityLabel(Text(movie.name ?? movie.originalName ?? ""))
            }
            .environment(\.urlImageOptions,
                          .init(fetchPolicy: .returnStoreElseLoad(downloadDelay: nil)))
        } else {
            // No url from API
            MoviePosterPlaceholderView(movie: movie)
        }
    }
}

struct MoviePosterPlaceholderView: View {
    
    let movie: Movie
    
    var body: some View {
        ZStack {
            Image("movie-poster-placeholder")
                .resizable()
                .aspectRatio(contentMode: .fill)
            VStack() {
                Spacer()
                Text(movie.name ?? "")
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .padding(.bottom, 16)
                    .padding(.horizontal, 5)
            }
        }
        .accessibilityLabel(Text(movie.name ?? movie.originalName ?? ""))
    }
}

struct MovieView_Previews: PreviewProvider {
    static var previews: some View {
        MovieView(movie: Movie.dummyData)
            .previewLayout(.fixed(width: 150, height: 250))
    }
}
