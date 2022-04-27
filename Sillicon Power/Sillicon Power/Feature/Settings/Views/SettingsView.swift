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
    
    @EnvironmentObject var languageSettings: LanguageSettings
    @Environment(\.openURL) var openURL
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
                
                Section(header: Text("ABOUT".localized())) {
                    HStack {
                        Text("VERSION".localized())
                        Spacer()
                        Text(Bundle.main.appVersionLong)
                    }
                }
                
                Section {
                    Label("The Movie DB", systemImage: "link")
                        .onTapGesture {
                            guard let url = URL(string: "https://www.themoviedb.org") else {
                                return
                            }
                            openURL(url)
                        }
                }
                .foregroundColor(.black)
                .font(.system(size: 16, weight: .semibold))
            }
            .navigationTitle("SETTINGS_TITLE".localized())
            .transition(.slide)
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(selectedLanguage: "en")
    }
}
