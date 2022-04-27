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

struct SettingsView: View {
    
    // MARK: - Properties
    
    @Binding var darkModeEnabled: Bool
    @Binding var systemThemeEnabled: Bool
    
    @EnvironmentObject var languageSettings: LanguageSettings
    @State var selectedLanguage: String
    private let languages = ["en", "es", "fr", "it"]
    
    // MARK: - UI
    
    var body: some View {
        
        NavigationView {
            Form {
                Section(header: Text("LANGUAGE".localized().uppercased())) {
                    Picker("LANGUAGE".localized(), selection: $selectedLanguage) {
                        ForEach(languages, id: \.self) {
                            Text($0.localized())
                        }
                    }
                    .onChange(of: selectedLanguage) { lang in
                        UserDefaults.standard.set(lang, forKey: "CustomLanguage")
                        languageSettings.selectedLanguage = Languages(rawValue: lang)!
                    }
                }
                
                Section(header: Text("DISPLAY".localized().uppercased()),
                        footer: Text("DISPLAY_FOOTER".localized())) {
                    Toggle(isOn: $darkModeEnabled) {
                        Text("DISPLAY_DARK_MODE".localized())
                    }
                    .onChange(of: darkModeEnabled) { _ in
                        SystemThemeManager
                            .shared
                            .handleTheme(darkMode: darkModeEnabled,
                                         system: systemThemeEnabled)
                    }
                    Toggle(isOn: $systemThemeEnabled) {
                        Text("DISPLAY_SYSTEM_MODE".localized())
                    }
                    .onChange(of: systemThemeEnabled) { _ in
                        SystemThemeManager
                            .shared
                            .handleTheme(darkMode: darkModeEnabled,
                                         system: systemThemeEnabled)
                    }
                }
                
                Section(header: Text("ABOUT".localized())) {
                    HStack {
                        Text("VERSION".localized())
                        Spacer()
                        Text(Bundle.main.appVersionLong)
                    }
                }
                
                Section {
                    Link(destination: URL(string: "https://www.themoviedb.org")!) {
                        Label("The Movie DB", systemImage: "link")
                    }
                }
                .foregroundColor(Theme.textColor)
                .font(.system(size: 16, weight: .semibold))
            }
            .navigationBarTitle("SETTINGS_TITLE".localized())
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(darkModeEnabled: .constant(false),
                     systemThemeEnabled: .constant(false),
                     selectedLanguage: "en")
    }
}
