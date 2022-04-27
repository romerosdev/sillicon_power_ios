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
import AlertToast

typealias EmptyStateActionHandler = () -> Void

class ErrorSettings: ObservableObject {
    var nTaps: Int = 0
    @Published var showingAlert: Bool = false
}

struct ErrorView: View {
    
    // MARK: - Properties
    
    @StateObject var settings = ErrorSettings()
    private let handler: EmptyStateActionHandler
    private var error: Error
    
    // MARK: - Initialisation
    
    internal init(
        error: Error,
        handler: @escaping EmptyStateActionHandler) {
            self.error = error
            self.handler = handler
        }
    
    // MARK: - UI
    
    var body: some View {
        ZStack {
            VStack(spacing: 21) {
                if case APIError.transportError(_) = error {
                    Image(systemName: "wifi.exclamationmark")
                        .resizable()
                        .frame(width: 50, height: 50)
                } else {
                    Image(systemName: "xmark.octagon")
                        .resizable()
                        .frame(width: 50, height: 50)
                        .onTapGesture {
                            settings.nTaps += 1
                            if settings.nTaps == 10 {
                                settings.showingAlert.toggle()
                                settings.nTaps = 0
                            }
                        }
                }
                
                VStack(spacing: 11) {
                    if case APIError.transportError(_) = error {
                        Text("ERR_NO_INTERNET_TITLE".localized())
                            .foregroundColor(Theme.textColor)
                            .font(.system(size: 20, weight: .regular))
                    }
                    Text(error.localizedDescription)
                        .foregroundColor(Color.gray)
                        .font(.system(size: 16, weight: .light))
                        .multilineTextAlignment(.center)
                        .padding(.bottom, 10)
                }
                .padding(.horizontal, 15)
            }
            .toast(isPresenting: $settings.showingAlert) {
                let apiError = error as? APIError
                return AlertToast(type: .error(.red),subTitle: apiError?.failureReason)
            }
            if case APIError.transportError(_) = error {
                VStack {
                    Spacer()
                    Button("ERR_TRY_AGAIN".localized()) {
                        handler()
                    }
                    .frame(height: 50)
                    .padding(.horizontal, 30)
                    .font(.system(size: 15, weight: .regular))
                    .background(Color.red.opacity(0.7))
                    .foregroundColor(.white)
                    .cornerRadius(100)
                    Spacer()
                        .frame(height: 15)
                }
            }
        }
    }
}

struct ErrorView_Previews: PreviewProvider {
    static var previews: some View {
        ErrorView(error: APIError.transportError(URLError(.notConnectedToInternet))) {
            
        }
        ErrorView(error: APIError.invalidResponse) {
            
        }
    }
}

