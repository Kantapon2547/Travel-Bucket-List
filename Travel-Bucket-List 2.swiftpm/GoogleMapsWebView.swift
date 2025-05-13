import SwiftUI
import WebKit

struct GoogleMapsWebView: View {
    let urlString: String
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack(spacing: 0) {
            // Top Bar with Back Button
            HStack {
                Button(action: {
                    dismiss()
                }) {
                    Image(systemName: "chevron.left")
                        .font(.title2)
                    Text("Back")
                        .font(.body)
                }
                .padding()
                Spacer()
            }
            .background(Color(.systemGray6))
            
            // WebView Content
            WebView(urlString: urlString)
        }
        .edgesIgnoringSafeArea(.all)
    }
}

struct WebView: UIViewRepresentable {
    let urlString: String
    
    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        if let url = URL(string: urlString) {
            let request = URLRequest(url: url)
            uiView.load(request)
        }
    }
}
