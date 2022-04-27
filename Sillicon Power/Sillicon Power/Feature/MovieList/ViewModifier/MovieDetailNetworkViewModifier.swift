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

struct MovieDetailNetworkViewModifier: ViewModifier {
    
    // MARK: - UI
    
    func body(content: Content) -> some View {
        content
            .frame(width: 60, height: 60)
            .padding(5)
            .cornerRadius(5)
            .overlay(
                RoundedRectangle(cornerRadius: 5)
                    .stroke(Color.accentColor, lineWidth: 2)
            )
            .padding(.leading, 5)
    }
}

extension View {
    
    /// Apply network style to any view.
    /// - Returns: New view.
    func applyNetworkStyle() -> some View {
        self.modifier(MovieDetailNetworkViewModifier())
    }
}
