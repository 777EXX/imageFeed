

import UIKit

enum Resourses {
    enum Images {
        enum Profile {
            static let defaultAvatar = UIImage(named: "profile_image")
            static let logOut = UIImage(named: "logout_button")
            static let mockPhoto = UIImage(named: "Alex Vas")
        }
        
        enum TabBar {
            static let imagesList = UIImage(named: "tab_editorial_active")
            static let profile = UIImage(named: "tab_profile_active")
        }
    }
    
    enum Strings {
        enum Profile {
            static let name = "Alex Vas"
            static let nickname = "@alex_vas"
            static let description = "Hello, World!"
        }
    }
}
