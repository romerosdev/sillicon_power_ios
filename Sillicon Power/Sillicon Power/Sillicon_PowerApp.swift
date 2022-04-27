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

@main
struct Sillicon_PowerApp: App {
    
    // MARK: - Properties
    
    let urlImageService = URLImageService(fileStore: URLImageFileStore(),
                                          inMemoryStore: URLImageInMemoryStore())
    
    // MARK: - Initialisation
    
    init() {
        Bundle.swizzleLocalization()
    }
    
    // MARK: - UI
    
    var body: some Scene {
        
        // Store images in cache (offline mode)
        let urlImageService = URLImageService(fileStore: URLImageFileStore(),
                                              inMemoryStore: URLImageInMemoryStore())
        
        WindowGroup {
            ContentView()
                .environment(\.urlImageService, urlImageService)
        }
    }
}
