import SwiftUI

struct EntryView: View {
    @State private var isLoggedIn = false
    @State private var isPlaceholderVisible = false
    var body: some View {
        if isLoggedIn {
            ContentView() // This is your menu/main view
        } else {
            LoginView(isLoggedIn: $isLoggedIn)
        }
    }
}

