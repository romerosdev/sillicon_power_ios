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

import Foundation

extension String {
    
    /// Returns a localized string, with an optional comment for translators.
    /// - Parameter comment: Optional comment for translators.
    /// - Returns: Localized string.
    func localized(comment: String = "") -> String {
        return NSLocalizedString(self, comment: comment)
    }
}
