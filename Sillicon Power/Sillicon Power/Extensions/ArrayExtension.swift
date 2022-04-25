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

extension Array where Element: Hashable {
    /// Remove duplicates from an array.
    /// - Returns: Array with unique elemants.
    func removingDuplicates() -> [Element] {
        var addedDict = [Element: Bool]()
        
        return filter {
            addedDict.updateValue(true, forKey: $0) == nil
        }
    }
    
    /// Remove duplicates from an array.
    mutating func removeDuplicates() {
        self = self.removingDuplicates()
    }
}
