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
    
    @AppStorage("darkModeEnabled") private var darkModeEnabled = false
    @AppStorage("systemThemeEnabled") private var systemThemeEnabled = false
    @EnvironmentObject var languageSettings: LanguageSettings
    
    // MARK: - UI
    
    var body: some View {
        
        TabView {
            MovieListView()
                .tabItem {
                    Image(systemName: "books.vertical")
                    Text("Shows")
                }
            SettingsView(darkModeEnabled: $darkModeEnabled,
                         systemThemeEnabled: $systemThemeEnabled,
                         selectedLanguage: languageSettings.selectedLanguage.rawValue)
                .tabItem {
                    Image(systemName: "gearshape")
                    Text("SETTINGS_TITLE".localized())
                }
        }
        .onAppear {
            SystemThemeManager
                .shared
                .handleTheme(darkMode: darkModeEnabled,
                             system: systemThemeEnabled)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
