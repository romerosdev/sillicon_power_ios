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
import URLImageStore
import LanguageManagerSwiftUI

@main
struct Sillicon_PowerApp: App {
    
    // MARK: - Properties
    
    private(set) var language: Languages = .en
    let urlImageService = URLImageService(fileStore: URLImageFileStore(),
                                          inMemoryStore: URLImageInMemoryStore())
    
    // MARK: - Initialisation
    
    init() {
        // Multilanguage setup (independent from Apple standard one)
        if let lang = UserDefaults.standard.string(forKey: "CustomLanguage") {
            // Get persisted language.
            language = Languages(rawValue: lang)!
        } else {
            // Get iPhone language as initial value.
            let lang = "locale".localized()
            UserDefaults.standard.set(lang, forKey: "CustomLanguage")
            language = Languages(rawValue: lang)!
        }
        Bundle.swizzleLocalization()
    }
    
    // MARK: - UI
    
    var body: some Scene {
        
        // Store images in cache (offline mode)
        let urlImageService = URLImageService(fileStore: URLImageFileStore(),
                                              inMemoryStore: URLImageInMemoryStore())
        
        WindowGroup {
            LanguageManagerView(language) {
                ContentView()
                    .environment(\.urlImageService, urlImageService)
                    .transition(.slide)
            }
        }
    }
}
