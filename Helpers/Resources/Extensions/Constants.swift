import Foundation

struct Constants {
    static let accessKey = "3iLI-LkNkVLdIxO48kWM4x70YaVk8UycuMu9-LrBvgU"
    static let secretKey = "gD94Gnoza9p1dG2wkzSqmzzws1In49EzB8NjsehQa3w"
    static let redirectURI = "urn:ietf:wg:oauth:2.0:oob"
    static let accessScope = "public+read_user+write_likes"
    static let defaultBaseURL = URL(string: "https://api.unsplash.com")!
    static let unsplashAuthorizeURLString = "https://unsplash.com/oauth/authorize"
    static let urlPathToAutorize = "/oauth/authorize/native"
    static let urlToFetchAuthToken = "https://unsplash.com/oauth/token"
}

struct ParametersNames {
static let clientID = "client_id"
static let clientSecret = "client_secret"
static let redirectUri = "redirect_uri"
static let responseType = "response_type"
static let code = "code"
static let scope = "scope"
static let grantType = "grant_type"
static let authorizationCode = "authorization_code"
}
