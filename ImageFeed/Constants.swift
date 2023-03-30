import Foundation

enum UnsplashParam {
static let AccessKey = "3iLI-LkNkVLdIxO48kWM4x70YaVk8UycuMu9-LrBvgU"
static let SecretKey = "gD94Gnoza9p1dG2wkzSqmzzws1In49EzB8NjsehQa3w"
static let RedirectURI = "urn:ietf:wg:oauth:2.0:oob"
static let AccessScope = "public+read_user+write_likes"
static let DefaultBaseURL = URL(string: "https://api.unsplash.com")!
static let authorizeURL = URLComponents(string: "https://unsplash.com/oauth/authorize")!
}

enum SegueIdentifier {
static let showAuthenticationScreenSegueIdentifier = "ShowAuthenticationScreen"
static let showWebViewSegueIdentifier = "ShowWebView"
}
