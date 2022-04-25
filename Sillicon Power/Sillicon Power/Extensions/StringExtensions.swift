//
//  StringExtensions.swift
//  Sillicon Power
//
//  Created by Raul Romero on 25/4/22.
//

import Foundation

extension String {
    
    /// Returns a localized string, with an optional comment for translators.
    /// - Parameter comment: Optional comment for translators.
    /// - Returns: Localized string.
    func localized(comment: String = "") -> String {
        return NSLocalizedString(self, comment: comment)
    }
}
