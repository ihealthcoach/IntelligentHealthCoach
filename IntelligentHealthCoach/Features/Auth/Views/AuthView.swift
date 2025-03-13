//
//  AuthView.swift
//  iHealthCoachApp
//
//  Created by Casper Broe on 26/02/2025.
//


//  AuthView.swift
import SwiftUI

struct AuthView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var isSignUp = false
    @State private var isPasswordVisible = false
    @State private var rememberMe = false
    @State private var showForgotPassword = false
    
    var body: some View {
        ZStack {
            // Background with gradient
            LinearGradient(
                gradient: Gradient(colors: [Color.indigo.opacity(0.6), Color.blue.opacity(0.2)]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            // Content
            ScrollView {
                VStack(spacing: 25) {
                    // Logo and App Name
                    VStack(spacing: 15) {
                        Image(systemName: "heart.circle.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 80, height: 80)
                            .foregroundColor(.white)
                        
                        Text("iHealth Coach")
                            .font(.system(size: 30, weight: .bold))
                            .foregroundColor(.white)
                        
                        Text(isSignUp ? "Create your account" : "Welcome back")
                            .font(.system(size: 16))
                            .foregroundColor(.white.opacity(0.8))
                    }
                    .padding(.top, 30)
                    .padding(.bottom, 40)
                    
                    // Auth Form
                    VStack(spacing: 20) {
                        // Email Field
                        inputField(
                            title: "Email",
                            text: $email,
                            placeholder: "Enter your email",
                            icon: "envelope",
                            isSecure: false
                        )
                        
                        // Password Field
                        HStack {
                            if isPasswordVisible {
                                inputField(
                                    title: "Password",
                                    text: $password,
                                    placeholder: "Enter your password",
                                    icon: "lock",
                                    isSecure: false
                                )
                            } else {
                                inputField(
                                    title: "Password",
                                    text: $password,
                                    placeholder: "Enter your password",
                                    icon: "lock",
                                    isSecure: true
                                )
                            }
                            
                            Button(action: {
                                isPasswordVisible.toggle()
                            }) {
                                Image(systemName: isPasswordVisible ? "eye.slash" : "eye")
                                    .foregroundColor(.gray)
                            }
                            .padding(.trailing, 8)
                        }
                        
                        // Show additional fields for signup
                        if isSignUp {
                            if isPasswordVisible {
                                inputField(
                                    title: "Confirm Password",
                                    text: $confirmPassword,
                                    placeholder: "Confirm your password",
                                    icon: "lock",
                                    isSecure: false
                                )
                            } else {
                                inputField(
                                    title: "Confirm Password",
                                    text: $confirmPassword,
                                    placeholder: "Confirm your password",
                                    icon: "lock",
                                    isSecure: true
                                )
                            }
                            
                            inputField(
                                title: "First Name",
                                text: $firstName,
                                placeholder: "Enter your first name",
                                icon: "person",
                                isSecure: false
                            )
                            
                            inputField(
                                title: "Last Name",
                                text: $lastName,
                                placeholder: "Enter your last name",
                                icon: "person",
                                isSecure: false
                            )
                        }
                        
                        // Remember me & Forgot password (only for sign in)
                        if !isSignUp {
                            HStack {
                                Button(action: {
                                    rememberMe.toggle()
                                }) {
                                    HStack {
                                        Image(systemName: rememberMe ? "checkmark.square.fill" : "square")
                                            .foregroundColor(rememberMe ? .blue : .gray)
                                        
                                        Text("Remember me")
                                            .foregroundColor(.gray)
                                            .font(.system(size: 14))
                                    }
                                }
                                
                                Spacer()
                                
                                Button(action: {
                                    showForgotPassword = true
                                }) {
                                    Text("Forgot Password?")
                                        .foregroundColor(.blue)
                                        .font(.system(size: 14))
                                }
                            }
                            .padding(.horizontal, 8)
                        }
                        
                        // Error message
                        if let errorMessage = authViewModel.errorMessage {
                            Text(errorMessage)
                                .foregroundColor(.red)
                                .font(.system(size: 14))
                                .padding(.horizontal, 8)
                                .multilineTextAlignment(.center)
                        }
                        
                        // Sign In / Sign Up Button
                        Button(action: {
                            if isSignUp {
                                if validateSignUp() {
                                    authViewModel.signUp(
                                        email: email,
                                        password: password,
                                        firstName: firstName,
                                        lastName: lastName
                                    )
                                }
                            } else {
                                authViewModel.signIn(email: email, password: password)
                            }
                        }) {
                            HStack {
                                Text(isSignUp ? "Sign Up" : "Sign In")
                                    .font(.system(size: 16, weight: .bold))
                                
                                if authViewModel.isLoading {
                                    ProgressView()
                                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                        .padding(.leading, 5)
                                }
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.indigo)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                        }
                        .disabled(authViewModel.isLoading)
                        
                        // Switch between Sign In / Sign Up
                        Button(action: {
                            withAnimation {
                                isSignUp.toggle()
                                authViewModel.errorMessage = nil
                                
                                // Clear fields when switching modes
                                if isSignUp {
                                    password = ""
                                    confirmPassword = ""
                                } else {
                                    password = ""
                                    confirmPassword = ""
                                    firstName = ""
                                    lastName = ""
                                }
                            }
                        }) {
                            HStack {
                                Text(isSignUp ? "Already have an account?" : "Don't have an account?")
                                    .foregroundColor(.gray)
                                
                                Text(isSignUp ? "Sign In" : "Sign Up")
                                    .foregroundColor(.blue)
                            }
                            .font(.system(size: 14))
                        }
                    }
                    .padding(25)
                    .background(Color.white)
                    .cornerRadius(20)
                    .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
                    
                    Spacer(minLength: 50)
                }
                .padding(.horizontal)
            }
            .alert("Reset Password", isPresented: $showForgotPassword) {
                VStack {
                    TextField("Enter your email", text: $email)
                        .autocapitalization(.none)
                        .keyboardType(.emailAddress)
                    
                    HStack {
                        Button("Cancel", role: .cancel) { }
                        
                        Button("Reset") {
                            if isValidEmail(email) {
                                authViewModel.resetPassword(email: email)
                            }
                        }
                    }
                }
            } message: {
                Text("Enter your email address to receive a password reset link.")
            }
            
            // Password reset confirmation
            if authViewModel.passwordResetSent {
                VStack {
                    Spacer()
                    
                    VStack(spacing: 20) {
                        Image(systemName: "envelope.circle.fill")
                            .font(.system(size: 50))
                            .foregroundColor(.green)
                        
                        Text("Password Reset Email Sent")
                            .font(.headline)
                        
                        Text("Please check your email inbox for instructions to reset your password.")
                            .multilineTextAlignment(.center)
                            .padding()
                        
                        Button("OK") {
                            authViewModel.passwordResetSent = false
                        }
                        .buttonStyle(PrimaryButtonStyle())
                        .padding(.horizontal, 40)
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(15)
                    .shadow(radius: 10)
                    .padding()
                    
                    Spacer()
                }
                .background(Color.black.opacity(0.4).ignoresSafeArea())
                .transition(.opacity)
                .zIndex(1)
            }
        }
    }
    
    // Helper function to create consistent input fields
    func inputField(title: String, text: Binding<String>, placeholder: String, icon: String, isSecure: Bool) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.gray)
            
            HStack {
                Image(systemName: icon)
                    .foregroundColor(.gray)
                    .frame(width: 20)
                
                if isSecure {
                    SecureField(placeholder, text: text)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                } else {
                    TextField(placeholder, text: text)
                        .autocapitalization(icon == "envelope" ? .none : .words)
                        .disableAutocorrection(true)
                        .keyboardType(icon == "envelope" ? .emailAddress : .default)
                }
            }
            .padding()
            .background(Color.gray.opacity(0.1))
            .cornerRadius(10)
        }
    }
    
    // Validation for sign up
    func validateSignUp() -> Bool {
        // Validate email
        if email.isEmpty || !isValidEmail(email) {
            authViewModel.errorMessage = "Please enter a valid email address."
            return false
        }
        
        // Validate password
        if password.isEmpty || password.count < 6 {
            authViewModel.errorMessage = "Password must be at least 6 characters."
            return false
        }
        
        // Validate password match
        if password != confirmPassword {
            authViewModel.errorMessage = "Passwords do not match."
            return false
        }
        
        // First and last name are optional but recommended
        if firstName.isEmpty && lastName.isEmpty {
            // Show a warning but allow to proceed
            authViewModel.errorMessage = "Adding your name is recommended but optional."
            return true
        }
        
        return true
    }
    
    // Simple email validation
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
}

// Preview
struct AuthView_Previews: PreviewProvider {
    static var previews: some View {
        AuthView()
            .environmentObject(AuthViewModel.unauthenticated)
    }
}
