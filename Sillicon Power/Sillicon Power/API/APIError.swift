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

/// Error data model.
struct APIErrorMessage: Decodable {
    var statusCode: Int
    var statusMsg: String
    
    enum CodingKeys: String, CodingKey {
        case statusCode = "status_code"
        case statusMsg = "status_message"
    }
}

/// Available error values.
enum APIError: LocalizedError {
    /// Invalid request, e.g. invalid URL
    case invalidRequestError
    
    /// Indicates an error on the transport layer, e.g. not being able to connect to the server
    case transportError(Error)
    
    /// Received an invalid response, e.g. non-HTTP result
    case invalidResponse
    
    /// Server-side validation error.
    case validationError(statusCode: Int, reason: String? = nil)
    
    /// The server sent data in an unexpected format.
    case decodingError(Error)
    
    /// General server-side error.
    case serverError(statusCode: Int)
    
    /// Unknown error.
    case unknownError(Error)
    
    /// Internal reason for logging.
    var failureReason: String? {
        switch self {
        case .invalidRequestError:
            return "Invalid request"
        case .transportError(let error):
            return "Transport error: \(error)"
        case .invalidResponse:
            return "Invalid response"
        case .validationError(let statusCode, let reason):
            return "Validation error with code \(statusCode), reason: \(reason ?? "no reason given")"
        case .decodingError:
            return "The server returned data in an unexpected format"
        case .serverError(let statusCode):
            return "Server error with code \(statusCode)"
        case .unknownError(let error):
            return "Unknown error: \(error)"
        }
    }
    
    /// Error description for users.
    var errorDescription: String? {
        switch self {
        case .transportError(_):
            return "ERR_NO_INTERNET_DESCRIPTION".localized()
        default:
            return "MSG_SERVICE_NOT_AVAILABLE".localized()
        }
    }
}
