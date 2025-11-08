import Foundation
import shared

#if DEBUG

extension User {
    public static func mock(
        id: Int64 = 1,
        username: String = "jdoe",
        name: String = "John Doe",
        state: String = "state",
        avatarUrl: String? = nil,
        webUrl: String = "https://gitlab.example.com/jdoe",
        email: String? = "john.doe@example.com"
    ) -> User {
        // Adjust argument labels to match your generated Swift initializer for shared.User
        User(
            id: id,
            username: username,
            name: name,
            state: state,
            avatarUrl: avatarUrl,
            webUrl: webUrl,
            email: email
        )
    }
}

#endif
