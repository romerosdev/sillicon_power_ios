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
import LanguageManagerSwiftUI

struct ContentView: View {
    
    // MARK: - Properties
    
    @EnvironmentObject var languageSettings: LanguageSettings
    
    // MARK: - UI
    
    var body: some View {
        
        TabView {
            MovieListView()
                .tabItem {
                    Image(systemName: "books.vertical")
                    Text("Shows")
                }
            SettingsView(selectedLanguage: languageSettings.selectedLanguage.rawValue)
                .tabItem {
                    Image(systemName: "gearshape")
                    Text("SETTINGS_TITLE".localized())
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
