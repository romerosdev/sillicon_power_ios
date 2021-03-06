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

struct MovieDetailHeaderViewModifier: ViewModifier {
    
    // MARK: - Properties
    
    let movie: Movie
    
    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd, yyyy"
        return formatter
    }()
    
    // MARK: - UI
    
    func body(content: Content) -> some View {
        ZStack {
            content
            Rectangle()
                .foregroundColor(.clear)
                .background(
                    LinearGradient(gradient: Gradient(colors: [.clear, .black]),
                                   startPoint: .top,
                                   endPoint: .bottom)
                )
        }
        .frame(height: UIScreen.main.bounds.width * (UIScreen.main.bounds.width < 500 ? 0.56 : 0.3 ))
        .overlay(
            VStack(spacing: 10) {
                Spacer()
                
                // Movie name, if it is nil, use original one.
                let name = movie.name ?? movie.originalName ?? ""
                Text(name)
                    .font(.system(size: 30, weight: .heavy))
                    .padding(.horizontal, 15)
                    .accessibilityLabel(Text(name))
                
                // Rating block
                if let voteAverage = movie.voteAverage, let voteCount = movie.voteCount {
                    HStack {
                        Image(systemName: "star")
                        Text("\(String(format:"%.1f", voteAverage)) (\(voteCount))")
                    }
                    .font(.system(size: 15, weight: .light))
                    .accessibilityLabel(Text(String(voteAverage)))
                }
                
                // General information block
                HStack {
                    if let seasons = movie.seasons {
                        let seasonsStr = "\(seasons) " + "SEASONS".localized()
                        Text(seasonsStr)
                            .accessibilityLabel(Text(seasonsStr))
                    }
                    
                    if let episodes = movie.episodes {
                        let episodesStr = "\(episodes) " + "EPISODES".localized()
                        Text(episodesStr)
                            .accessibilityLabel(Text(episodesStr))
                    }
                    
                    if let date = movie.date {
                        Image(systemName: "calendar")
                        Text(date, formatter: Self.dateFormatter)
                            .accessibilityLabel(Text(date, formatter: Self.dateFormatter))
                    }
                    
                    if let runTime = movie.episodeRunTime?.first {
                        Image(systemName: "timer")
                        let runTimeStr = "\(runTime) min"
                        Text(runTimeStr)
                            .accessibilityLabel(Text(runTimeStr))
                    }
                }
                .font(.system(size: 12, weight: .light))
                .padding(.bottom, 12)
            }
                .foregroundColor(.white)
        )
    }
}

extension View {
    
    /// Apply header style to any view.
    /// - Parameter movie: Movie information.
    /// - Returns: New view.
    func applyHeaderStyle(movie: Movie) -> some View {
        self.modifier(MovieDetailHeaderViewModifier(movie: movie))
    }
}
