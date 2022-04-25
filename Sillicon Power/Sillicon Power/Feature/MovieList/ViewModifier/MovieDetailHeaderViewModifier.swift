//
//  MovieDetailHeaderViewModifier.swift
//  Sillicon Power
//
//  Created by Raul Romero on 25/4/22.
//

import SwiftUI

struct MovieDetailHeaderViewModifier: ViewModifier {
    
    let movie: Movie
    
    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd, yyyy"
        return formatter
    }()
    
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
        .frame(height: UIScreen.main.bounds.width * 0.56)
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
