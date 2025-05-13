import SwiftUI

struct SignUpView: View {
    @Binding var username: String
    @Binding var password: String
    @Binding var showSignUp: Bool
    
    @AppStorage("savedUsername") private var savedUsername = ""
    @AppStorage("savedPassword") private var savedPassword = ""
    
    var body: some View {
        ZStack {
            Image("LoginPage")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
                .allowsHitTesting(false)
            
            VStack(spacing: 20) {
                Text("Create Account")
                    .font(.largeTitle)
                    .bold()
                    .foregroundColor(.white)
                
                TextField("New Username", text: $username)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(8)
                    .foregroundColor(.black)
                
                SecureField("New Password", text: $password)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(8)
                    .foregroundColor(.black)
                
                Button("Sign Up") {
                    if !username.isEmpty && !password.isEmpty {
                        savedUsername = username
                        savedPassword = password
                        showSignUp = false // 👈 Dismiss sign-up view
                    }
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
            }
            .padding()
            .background(Color.teal.opacity(0.85))
            .cornerRadius(20)
            .padding(.horizontal)
        }
        .navigationTitle("Sign Up")
    }
}
