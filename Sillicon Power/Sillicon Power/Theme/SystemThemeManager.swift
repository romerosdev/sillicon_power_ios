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
import UIKit

class SystemThemeManager {
    
    // MARK: - Singleton pattern
    static let shared = SystemThemeManager()
    
    private init() {}
    
    // MARK: - Methods
    
    
    /// Handle app theme (dark or light).
    /// - Parameters:
    ///   - darkMode: Dark mode enabled.
    ///   - system: System theme enabled.
    func handleTheme(darkMode: Bool, system: Bool) {
        
        // Handle System
        guard !system else {
            UIApplication.shared.windows.first?.overrideUserInterfaceStyle = .unspecified
            return
        }
        
        UIApplication.shared.windows.first?.overrideUserInterfaceStyle = darkMode ? .dark : .light
    }
}
