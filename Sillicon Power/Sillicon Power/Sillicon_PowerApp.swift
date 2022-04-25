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
    
    let urlImageService = URLImageService(fileStore: URLImageFileStore(),
                                          inMemoryStore: URLImageInMemoryStore())
    
    var body: some Scene {
        WindowGroup {
            MovieListView()
                .environment(\.urlImageService, urlImageService)
        }
    }
}
