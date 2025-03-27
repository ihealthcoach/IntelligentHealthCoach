//
//  AuthView.swift
//  iHealthCoachApp
//
//  Created by Casper Broe on 26/02/2025.
//
/*
import SwiftUI
import AuthenticationServices

struct AuthView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var showingSignIn = false
    
    // Form fields
    @State private var email = ""
    @State private var password = ""
    @State private var firstName = ""
    @State private var lastName = ""
    
    // Form validation and state
    @State private var isPasswordVisible = false
    @State private var forgotPasswordEmail = ""
    @State private var showingForgotPassword = false
    @State private var showingPasswordResetConfirmation = false
    @State private var showAdvancedSignUp = false
    
    // Animation state
    @State private var buttonScale: CGFloat = 1.0
    
    var body: some View {
        ZStack {
            // Background
            Color(UIColor.systemGray6)
                .ignoresSafeArea()
            
            // Main content
            VStack(spacing: 24) {
                Spacer().frame(height: 40)
                
                // App logo
                Image("app-logo") // Replace with your actual logo
                    .resizable()
                    .renderingMode(.template)
                    .foregroundColor(Color.mint)
                    .frame(width: 80, height: 80)
                    .padding(.bottom, 20)
                
                // Title and subtitle
                VStack(spacing: 8) {
                    if showingSignIn {
                        Text("Sign in")
                            .font(.system(size: 28, weight: .bold))
                            .foregroundColor(.gray900)
                    } else {
                        Text("Create your account")
                            .font(.system(size: 28, weight: .bold))
                            .foregroundColor(.gray900)
                        
                        Text("and unlock your true potential with")
                            .font(.system(size: 16))
                            .foregroundColor(.gray)
                        
                        Text("Intelligent Health Coach")
                            .font(.system(size: 16))
                            .foregroundColor(.gray)
                    }
                }
                .padding(.bottom, 20)
                
                if !showAdvancedSignUp {
                    // Social sign in buttons
                    VStack(spacing: 12) {
                        socialButton(
                            text: "Sign up with Google",
                            logo: "google-logo",
                            action: {
                                // Handle Google sign up
                            }
                        )
                        
                        socialButton(
                            text: "Sign up with Facebook",
                            logo: "facebook-logo",
                            action: {
                                // Handle Facebook sign up
                            }
                        )
                        
                        socialButton(
                            text: "Sign up with Apple",
                            logo: "apple-logo",
                            isSFSymbol: true,
                            action: {
                                // Handle Apple sign up
                                handleAppleSignIn()
                            }
                        )
                    }
                    .padding(.horizontal, 16)
                    
                    // Or sign up with email text
                    Text("or sign up with your email")
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                        .padding(.vertical, 16)
                    
                    // Email and password fields
                    VStack(spacing: 12) {
                        // Email field
                        TextField("Email", text: $email)
                            .autocapitalization(.none)
                            .keyboardType(.emailAddress)
                            .disableAutocorrection(true)
                            .padding()
                            .background(Color.offwhite)
                            .cornerRadius(8)
                            .shadow(color: Color.gray900.opacity(0.05), radius: 2, x: 0, y: 1)
                        
                        // Password field
                        HStack {
                            if isPasswordVisible {
                                TextField("Password", text: $password)
                                    .autocapitalization(.none)
                                    .disableAutocorrection(true)
                            } else {
                                SecureField("Password", text: $password)
                                    .autocapitalization(.none)
                                    .disableAutocorrection(true)
                            }
                            
                            Button(action: {
                                isPasswordVisible.toggle()
                            }) {
                                Text(isPasswordVisible ? "Hide" : "Show")
                                    .font(.system(size: 14))
                                    .foregroundColor(.gray)
                            }
                        }
                        .padding()
                        .background(Color.offwhite)
                        .cornerRadius(8)
                        .shadow(color: Color.gray900.opacity(0.05), radius: 2, x: 0, y: 1)
                    }
                    .padding(.horizontal, 16)
                    
                    // Continue with email button
                    Button(action: {
                        if showingSignIn {
                            loginWithEmail()
                        } else {
                            // Show advanced signup or directly sign up
                            showAdvancedSignUp = true
                        }
                    }) {
                        Text(showingSignIn ? "Sign in" : "Continue with email")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.offwhite)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(Color(UIColor.systemGray5))
                            .cornerRadius(8)
                    }
                    .disabled(email.isEmpty || password.isEmpty)
                    .padding(.horizontal, 16)
                    .padding(.top, 16)
                } else {
                    // Advanced signup form (name fields)
                    VStack(spacing: 12) {
                        // First Name field
                        TextField("First Name", text: $firstName)
                            .autocapitalization(.words)
                            .disableAutocorrection(true)
                            .padding()
                            .background(Color.offwhite)
                            .cornerRadius(8)
                            .shadow(color: Color.gray900.opacity(0.05), radius: 2, x: 0, y: 1)
                        
                        // Last Name field
                        TextField("Last Name", text: $lastName)
                            .autocapitalization(.words)
                            .disableAutocorrection(true)
                            .padding()
                            .background(Color.offwhite)
                            .cornerRadius(8)
                            .shadow(color: Color.gray900.opacity(0.05), radius: 2, x: 0, y: 1)
                    }
                    .padding(.horizontal, 16)
                    
                    // Create account button
                    Button(action: {
                        createAccount()
                    }) {
                        Text("Create Account")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.offwhite)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(Color(UIColor.systemGray5))
                            .cornerRadius(8)
                    }
                    .disabled(firstName.isEmpty || lastName.isEmpty)
                    .padding(.horizontal, 16)
                    .padding(.top, 16)
                    
                    // Back button
                    Button(action: {
                        showAdvancedSignUp = false
                    }) {
                        Text("Back")
                            .font(.system(size: 16))
                            .foregroundColor(.gray)
                    }
                    .padding(.top, 16)
                }
                
                Spacer()
                
                // Already have an account or Sign up link
                Button(action: {
                    withAnimation {
                        showingSignIn.toggle()
                    }
                }) {
                    if showingSignIn {
                        HStack(spacing: 4) {
                            Text("Don't have an account?")
                                .foregroundColor(.gray)
                            Text("Sign up")
                                .foregroundColor(.blue)
                        }
                        .font(.system(size: 14))
                    } else {
                        HStack(spacing: 4) {
                            Text("Already have an account?")
                                .foregroundColor(.gray)
                            Text("Sign in")
                                .foregroundColor(.blue)
                        }
                        .font(.system(size: 14))
                    }
                }
                .padding(.bottom, 16)
            }
            
            // Loading overlay
            if authViewModel.isLoading {
                LoadingView(message: "Processing...")
                    .transition(.opacity)
                    .zIndex(100)
            }
            
            // Error message
            if let errorMessage = authViewModel.errorMessage {
                VStack {
                    Spacer()
                    Text(errorMessage)
                        .font(.subheadline)
                        .foregroundColor(.offwhite)
                        .padding()
                        .background(Color.red.opacity(0.8))
                        .cornerRadius(10)
                        .padding(.horizontal)
                        .padding(.bottom, 20)
                }
                .transition(.move(edge: .bottom))
                .animation(.easeInOut, value: authViewModel.errorMessage != nil)
                .zIndex(90)
            }
            
            // Password reset confirmation
            if showingPasswordResetConfirmation {
                passwordResetConfirmationView
            }
        }
    }
    
    // MARK: - Helper Views
    
    // Password reset confirmation view
    var passwordResetConfirmationView: some View {
        ZStack {
            Color.gray900.opacity(0.4)
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                Image(systemName: "envelope.circle.fill")
                    .font(.system(size: 50))
                    .foregroundColor(.green)
                
                Text("Password Reset Email Sent")
                    .font(.headline)
                
                Text("We've sent password reset instructions to your email. Please check your inbox.")
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                    .font(.body)
                
                Button("OK") {
                    showingPasswordResetConfirmation = false
                }
                .font(.headline)
                .foregroundColor(.offwhite)
                .padding(.horizontal, 50)
                .padding(.vertical, 12)
                .background(Color.mint)
                .cornerRadius(10)
            }
            .padding(30)
            .background(Color.offwhite)
            .cornerRadius(20)
            .shadow(radius: 10)
            .padding(40)
        }
        .transition(.opacity)
        .animation(.easeInOut, value: showingPasswordResetConfirmation)
    }
    
    // MARK: - Helper Functions
    
    // Social button styled according to the design
    func socialButton(text: String, logo: String, isSFSymbol: Bool = false, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack {
                if isSFSymbol {
                    Image(systemName: logo)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20, height: 20)
                } else {
                    Image(logo) // Use your own logo assets
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20, height: 20)
                }
                
                Text(text)
                    .font(.system(size: 16))
                    .foregroundColor(.gray900)
                
                Spacer()
            }
            .padding(.vertical, 16)
            .padding(.horizontal, 16)
            .background(Color.offwhite)
            .cornerRadius(8)
            .shadow(color: Color.gray900.opacity(0.05), radius: 2, x: 0, y: 1)
        }
    }
    
    // Form validation
    private func validateForm() {
        // Not needed for this simplified UI, validation is handled directly in button disabled states
    }
    
    // Handle account creation with email
    private func createAccount() {
        authViewModel.signUp(
            email: email,
            password: password,
            firstName: firstName,
            lastName: lastName
        )
    }
    
    // Handle login with email
    private func loginWithEmail() {
        authViewModel.signIn(email: email, password: password)
    }
    
    // Handle password reset
    private func resetPassword(email: String) {
        Task {
            // This prevents any issues with state updates in alert closures
            try? await Task.sleep(nanoseconds: 100_000_000)
            
            authViewModel.resetPassword(email: email)
            showingPasswordResetConfirmation = true
        }
    }
    
    // Handle Apple Sign In
    private func handleAppleSignIn() {
        // This is where you'd implement Apple Sign In
        // Since the implementation depends on additional setup,
        // this is a placeholder for now
    }
}


// MARK: - Extensions

// TextField placeholder modifier
extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content) -> some View {
        
        ZStack(alignment: alignment) {
            placeholder().opacity(shouldShow ? 1 : 0)
            self
        }
    }
}

#Preview {
    AuthView()
        .environmentObject(AuthViewModel.unauthenticated)
}
*/

import SwiftUI
import AuthenticationServices

struct AuthView: View {
    @State private var email = ""
    @State private var password = ""

    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                Spacer()

                // Logo Placeholder
                Image("logo-ihealth")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 68, height: 68)
                
                VStack(spacing: 4) {
                    // Heading Text
                    Text("Create your account")
                        .font(.system(size: 30, weight: .bold))
                        .foregroundColor(.gray900)
                    
                    // Subheading Text
                    Text("and unlock your true potential with Intelligent Health Coach")
                        .font(.system(size: 20))
                        .multilineTextAlignment(.center)
                        .foregroundColor(.gray400)
                        .padding(.horizontal, 16)
                }

                // Social Sign-In Buttons
                VStack(spacing: 8) {
                    Button(action: {}) {
                        HStack {
                            Image("logo-google")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 24, height: 24)
                            Text("Sign up with Google")
                                .foregroundColor(.gray900)
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color("offwhite")) // Background color
                        .overlay(
                            RoundedRectangle(cornerRadius: 10) // Stroke layer
                                .stroke(Color("gray200"), lineWidth: 1)
                        )
                        .cornerRadius(5)
                    }

                    Button(action: {}) {
                        HStack {
                            Image("logo-facebook")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 24, height: 24)
                            Text("Sign up with Facebook")
                                .foregroundColor(.gray900)
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color("offwhite")) // Background color
                        .overlay(
                            RoundedRectangle(cornerRadius: 10) // Stroke layer
                                .stroke(Color("gray200"), lineWidth: 1)
                        )
                        .cornerRadius(5)
                    }

                    Button(action: {}) {
                        HStack {
                            Image("logo-apple")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 24, height: 24)
                                .foregroundColor(Color("gray900"))
                            Text("Sign up with Apple")
                                .foregroundColor(.gray900)
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color("offwhite")) // Background color
                        .overlay(
                            RoundedRectangle(cornerRadius: 10) // Stroke layer
                                .stroke(Color("gray200"), lineWidth: 1)
                        )
                        .cornerRadius(5)
                    }
                }

                Text("or sign up with your email")
                    .foregroundColor(.gray400)
                    .padding(.vertical, 0)

                // Email & Password Fields
                VStack(spacing: 8) {
                    TextField("Email", text: $email)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color("offwhite")) // Background color
                        .overlay(
                            RoundedRectangle(cornerRadius: 5) // Stroke layer
                                .stroke(Color("gray200"), lineWidth: 1)
                        )
                        .cornerRadius(5)

                    SecureField("Password", text: $password)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color("offwhite")) // Background color
                        .overlay(
                            RoundedRectangle(cornerRadius: 5) // Stroke layer
                                .stroke(Color("gray200"), lineWidth: 1)
                        )
                        .cornerRadius(5)

                // Continue Button
                Button(action: {}) {
                    Text("Continue with email")
                        .foregroundColor(.offwhite)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(email.isEmpty || password.isEmpty ? Color(.gray200) : Color.indigo600)
                        .cornerRadius(5)
                }
                .disabled(email.isEmpty || password.isEmpty)
                }

                // Already have an account?
                HStack {
                    Text("Already have an account?")
                        .foregroundColor(.gray400)
                    NavigationLink(destination: Text("Sign In View")) {
                        Text("Sign in")
                            .fontWeight(.bold)
                            .foregroundColor(.gray400)
                    }
                }
            }
            .padding(.bottom, 48)
            .padding(.horizontal, 16)
            .withSafeAreaSpacer()
            .appBackground()
        }
    }
}

struct AuthView_Previews: PreviewProvider {
    static var previews: some View {
        AuthView()
    }
}

