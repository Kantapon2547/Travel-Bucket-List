import SwiftUI

struct LoginView: View {
    @Binding var isLoggedIn: Bool
    @State private var username = "username"
    @State private var password = "1234"
    @State private var showError = false
    @State private var showSignUp = false
    @AppStorage("savedUsername") private var savedUsername = ""
    @AppStorage("savedPassword") private var savedPassword = ""
    
    var body: some View {
        NavigationStack {
            ZStack {
                Image("LoginPage")
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
                
                VStack {
                    Spacer()
                    VStack(spacing: 20) {
                        Image(systemName: "person.circle.fill")
                            .resizable()
                            .frame(width: 100, height: 100)
                            .background(Circle().fill(Color.white))
                            .clipShape(Circle())
                        
                        Text("Sign In")
                            .font(.title)
                            .foregroundColor(.white)
                        
                        TextField("Enter Name:", text: $username)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(8)
                            .foregroundColor(.black)
                        
                        SecureField("Enter Password:", text: $password)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(8)
                            .foregroundColor(.black)
                        
                        if showError {
                            Text("Invalid username or password")
                                .foregroundColor(.red)
                                .font(.caption)
                        }
                        
                        Button(action: {
                            if username == savedUsername && password == savedPassword {
                                isLoggedIn = true
                                showError = false
                            } else {
                                showError = true
                            }
                        }) {
                            Text("Sign In")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.black)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                        
                        HStack {
                            Button("Forgot Password?") {
                                // Handle forgot password
                            }
                            Spacer()
                            Button("Sign Up?") {
                                showSignUp = true
                            }
                        }
                        .foregroundColor(.white)
                        .navigationDestination(isPresented: $showSignUp) {
                            SignUpView(username: $username, password: $password, showSignUp: $showSignUp)
                        }
                    }
                    .padding()
                    .background(Color.teal.opacity(0.8))
                    .cornerRadius(20)
                    .padding(.horizontal)
                    Spacer()
                }
            }
        }
    }
}



