//
//  CreateUserView.swift
//  IntelligentHealthCoach
//
//  Created by Casper Broe on 29/03/2025.
//

import SwiftUI

struct CreateUserView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var authViewModel: AuthViewModel
    
    // Form fields
    @State private var firstName: String = ""
    @State private var lastName: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    
    // Validation states
    @State private var isPasswordValid: Bool = true
    @State private var passwordsMatch: Bool = true
    @State private var isEmailValid: Bool = true
    
    // UI States
    @State private var showPassword: Bool = false
    @State private var showConfirmPassword: Bool = false
    
    // Checking for existing email
    @State private var isCheckingEmail = false
    @State private var emailExists = false
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                // Back button (left-aligned)
                BackButton {
                    presentationMode.wrappedValue.dismiss()
                }
                .padding(.bottom, 8)
                
                VStack(spacing: 8) {
                    Text("Create your account")
                        .font(.system(size: 30, weight: .bold))
                        .foregroundColor(.gray900)
                    
                    Text("Please provide your details")
                        .font(.system(size: 16))
                        .foregroundColor(.gray400)
                }
                .frame(maxWidth: .infinity)
                .padding(.top, 12)
                
                // Form fields
                VStack(spacing: 16) {
                    // First Name field
                    VStack(alignment: .leading, spacing: 8) {
                        Text("First Name")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.gray700)
                        
                        TextField("Your first name", text: $firstName)
                            .padding()
                            .background(Color.offwhite)
                            .cornerRadius(5)
                            .overlay(
                                RoundedRectangle(cornerRadius: 5)
                                    .stroke(Color.gray200, lineWidth: 1)
                            )
                            .textContentType(.givenName)
                            .disableAutocorrection(true)
                            .autocapitalization(.words)
                    }
                    
                    // Last Name field
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Last Name")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.gray700)
                        
                        TextField("Your last name", text: $lastName)
                            .padding()
                            .background(Color.offwhite)
                            .cornerRadius(5)
                            .overlay(
                                RoundedRectangle(cornerRadius: 5)
                                    .stroke(Color.gray200, lineWidth: 1)
                            )
                            .textContentType(.familyName)
                            .disableAutocorrection(true)
                            .autocapitalization(.words)
                    }
                    
                    // Email field
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Email")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.gray700)
                        
                        TextField("Your email address", text: $email)
                            .padding()
                            .background(Color.offwhite)
                            .cornerRadius(5)
                            .overlay(
                                RoundedRectangle(cornerRadius: 5)
                                    .stroke(isEmailValid ? Color.gray200 : Color.red, lineWidth: 1)
                            )
                            .keyboardType(.emailAddress)
                            .autocapitalization(.none)
                            .disableAutocorrection(true)
                            .textContentType(.emailAddress)
                            .onChange(of: email) { newValue in
                                validateEmail()
                                if isEmailValid && !newValue.isEmpty {
                                    checkExistingEmail(newValue)
                                }
                            }

                        if !isEmailValid {
                            Text("Please enter a valid email address")
                                .font(.system(size: 12))
                                .foregroundColor(.red)
                        }

                        if emailExists {
                            Text("Email is already registered. Try signing in instead.")
                                .font(.system(size: 12))
                                .foregroundColor(.red)
                        }
                    }
                    
                    // Password field
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Password")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.gray700)
                        
                        HStack {
                            if showPassword {
                                TextField("Create a password", text: $password)
                                    .padding()
                                    .autocapitalization(.none)
                                    .textContentType(.newPassword)
                            } else {
                                SecureField("Create a password", text: $password)
                                    .padding()
                                    .autocapitalization(.none)
                                    .textContentType(.newPassword)
                            }
                            
                            Button(action: { showPassword.toggle() }) {
                                Image(systemName: showPassword ? "eye.slash" : "eye")
                                    .foregroundColor(.gray400)
                            }
                            .padding(.trailing)
                        }
                        .background(Color.offwhite)
                        .cornerRadius(5)
                        .overlay(
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(isPasswordValid ? Color.gray200 : Color.red, lineWidth: 1)
                        )
                        .onChange(of: password) { _ in
                            validatePassword()
                            checkPasswordsMatch()
                        }
                        
                        if !isPasswordValid {
                            Text("Password must be at least 8 characters")
                                .font(.system(size: 12))
                                .foregroundColor(.red)
                        }
                    }
                    
                    // Confirm Password field
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Confirm Password")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.gray700)
                        
                        HStack {
                            if showConfirmPassword {
                                TextField("Confirm your password", text: $confirmPassword)
                                    .padding()
                                    .autocapitalization(.none)
                            } else {
                                SecureField("Confirm your password", text: $confirmPassword)
                                    .padding()
                                    .autocapitalization(.none)
                            }
                            
                            Button(action: { showConfirmPassword.toggle() }) {
                                Image(systemName: showConfirmPassword ? "eye.slash" : "eye")
                                    .foregroundColor(.gray400)
                            }
                            .padding(.trailing)
                        }
                        .background(Color.offwhite)
                        .cornerRadius(5)
                        .overlay(
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(passwordsMatch ? Color.gray200 : Color.red, lineWidth: 1)
                        )
                        .onChange(of: confirmPassword) { _ in
                            checkPasswordsMatch()
                        }
                        
                        if !passwordsMatch {
                            Text("Passwords do not match")
                                .font(.system(size: 12))
                                .foregroundColor(.red)
                        }
                    }
                }
                
                // Create Account Button
                Button(action: {
                    if validateForm() {
                        createAccount()
                    }
                }) {
                    Text("Create Account")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.offwhite)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(formIsValid() ? Color.indigo600 : Color.gray300)
                        .cornerRadius(5)
                }
                .disabled(!formIsValid())

                .padding(.top, 16)
                
                Spacer()
            }
        }
        .navigationBarBackButtonHidden(true)
        .standardScreen()
        .loadingOverlay(isLoading: authViewModel.isLoading)
        .overlay(
            VStack {
                Spacer()
                if let errorMessage = authViewModel.errorMessage {
                    Text(errorMessage)
                        .font(.subheadline)
                        .foregroundColor(.offwhite)
                        .padding()
                        .background(Color.red.opacity(0.8))
                        .cornerRadius(10)
                        .padding(.horizontal)
                        .padding(.bottom, 20)
                        .transition(.move(edge: .bottom))
                        .animation(.easeInOut, value: authViewModel.errorMessage != nil)
                }
            },
            alignment: .bottom
        )
    }
    
    // MARK: - Validation Methods
    
    private func validateEmail() {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        isEmailValid = NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: email)
    }
    
    private func validatePassword() {
        isPasswordValid = password.count >= 8
    }
    
    private func checkPasswordsMatch() {
        passwordsMatch = password == confirmPassword
    }
    
    private func validateForm() -> Bool {
        validateEmail()
        validatePassword()
        checkPasswordsMatch()
        
        return isEmailValid && isPasswordValid && passwordsMatch && !firstName.isEmpty && !lastName.isEmpty
    }
    
    private func formIsValid() -> Bool {
        return isEmailValid && isPasswordValid && passwordsMatch && !firstName.isEmpty && !lastName.isEmpty && !email.isEmpty && !password.isEmpty && !confirmPassword.isEmpty
    }
    
    // MARK: - Email Existence Check
    
    private func checkExistingEmail(_ email: String) {
        isCheckingEmail = true
        
        Task {
            // Add the email: label to the parameter
            let exists = await authViewModel.checkUserExists(email: email)
            
            await MainActor.run {
                emailExists = exists
                isCheckingEmail = false
            }
        }
    }
    
    // MARK: - Account Creation
    
    private func createAccount() {
        authViewModel.signUp(
            email: email,
            password: password,
            firstName: firstName,
            lastName: lastName
        )
    }
}

struct CreateUserView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            CreateUserView()
                .environmentObject(AuthViewModel.unauthenticated)
        }
    }
}
