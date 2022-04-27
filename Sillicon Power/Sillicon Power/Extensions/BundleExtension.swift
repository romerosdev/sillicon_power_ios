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

extension Bundle {
    
    // MARK: - Properties
    
    public var appName: String { getInfo("CFBundleName") }
    public var displayName: String { getInfo("CFBundleDisplayName") }
    public var language: String { getInfo("CFBundleDevelopmentRegion") }
    public var identifier: String { getInfo("CFBundleIdentifier") }
    public var copyright: String { getInfo("NSHumanReadableCopyright").replacingOccurrences(of: "\\\\n", with: "\n") }
    
    public var appBuild: String { getInfo("CFBundleVersion") }
    public var appVersionLong: String { getInfo("CFBundleShortVersionString") }
    public var appVersionShort: String { getInfo("CFBundleShortVersion") }
    
    fileprivate func getInfo(_ str: String) -> String { infoDictionary?[str] as? String ?? "⚠️" }
    
    // MARK: - Localization
    
    /// Method swizzling is the process of changing the implementation of an existing
    /// selector at runtime. Simply speaking, we can change the functionality of a
    /// method at runtime.
    /// Original method -> localizedString(forKey:value:table:)
    /// Modified method -> customLocalizedString(forKey:value:table:)
    static func swizzleLocalization() {
        let orginalSelector = #selector(localizedString(forKey:value:table:))
        guard let orginalMethod = class_getInstanceMethod(self, orginalSelector) else { return }
        
        let mySelector = #selector(customLocalizedString(forKey:value:table:))
        guard let myMethod = class_getInstanceMethod(self, mySelector) else { return }
        
        if class_addMethod(self, orginalSelector, method_getImplementation(myMethod), method_getTypeEncoding(myMethod)) {
            class_replaceMethod(self, mySelector, method_getImplementation(orginalMethod), method_getTypeEncoding(orginalMethod))
        } else {
            method_exchangeImplementations(orginalMethod, myMethod)
        }
    }
    
    /// Method for retrieving localized strings with user language.
    /// - Parameters:
    ///   - key: String key.
    ///   - value: String value.
    ///   - table: Strings table.
    /// - Returns: Localized string.
    @objc private func customLocalizedString(forKey key: String,value: String?, table: String?) -> String {
        guard let language = UserDefaults.standard.string(forKey: "CustomLanguage"),
              let bundlePath = Bundle.main.path(forResource: language, ofType: "lproj"),
              let bundle = Bundle(path: bundlePath) else {
            return Bundle.main.customLocalizedString(forKey: key, value: value, table: table)
        }
        return bundle.customLocalizedString(forKey: key, value: value, table: table)
    }
}
