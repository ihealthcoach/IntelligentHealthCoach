//
//  SignInView.swift
//  IntelligentHealthCoach
//
//  Created by Casper Broe on 29/03/2025.
//

import SwiftUI

struct SignInView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var authViewModel: AuthViewModel
    
    @State private var email = ""
    @State private var password = ""
    @State private var showPassword = false
    @State private var showResetPassword = false
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                // Back button (left-aligned)
                BackButton {
                    presentationMode.wrappedValue.dismiss()
                }
                .padding(.bottom, 8)
            
                VStack(spacing: 8) {
                    Text("Welcome back")
                        .font(.system(size: 30, weight: .bold))
                        .foregroundColor(.gray900)
                    
                    Text("Sign in to continue")
                        .font(.system(size: 16))
                        .foregroundColor(.gray400)
                }
                .frame(maxWidth: .infinity)
                .padding(.top, 12)
                
                // Email & Password Fields
                VStack(spacing: 16) {
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
                                    .stroke(Color.gray200, lineWidth: 1)
                            )
                            .keyboardType(.emailAddress)
                            .autocapitalization(.none)
                            .disableAutocorrection(true)
                            .textContentType(.emailAddress)
                    }
                    
                    // Password field
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Password")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.gray700)
                        
                        HStack {
                            if showPassword {
                                TextField("Enter your password", text: $password)
                                    .padding()
                                    .autocapitalization(.none)
                                    .textContentType(.password)
                            } else {
                                SecureField("Enter your password", text: $password)
                                    .padding()
                                    .autocapitalization(.none)
                                    .textContentType(.password)
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
                                .stroke(Color.gray200, lineWidth: 1)
                        )
                    }
                    
                    // Forgot password link
                    HStack {
                        Spacer()
                        Button(action: {
                            showResetPassword = true
                        }) {
                            Text("Forgot password?")
                                .font(.system(size: 14))
                                .foregroundColor(.indigo600)
                        }
                    }
                }
                
                // Sign In Button
                Button(action: {
                    authViewModel.signIn(email: email, password: password)
                }) {
                    Text("Sign In")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.offwhite)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(email.isEmpty || password.isEmpty ? Color.gray300 : Color.indigo600)
                        .cornerRadius(5)
                }
                .disabled(email.isEmpty || password.isEmpty)
                .padding(.horizontal)
                .padding(.top, 16)
                
                // Don't have an account section
                HStack {
                    Text("Don't have an account?")
                        .foregroundColor(.gray400)
                    
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Text("Sign up")
                            .fontWeight(.bold)
                            .foregroundColor(.indigo600)
                    }
                }
                .padding(.top, 24)
                
                Spacer()
            }
        }
        .standardScreen()
        .navigationBarBackButtonHidden(true)
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
        .sheet(isPresented: $showResetPassword) {
            ResetPasswordView()
        }
    }
}

// Reset Password View for the sheet
struct ResetPasswordView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var email = ""
    
    var body: some View {
        NavigationView {
            VStack(spacing: 24) {
                Text("Enter your email address and we'll send you a link to reset your password.")
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                
                TextField("Email", text: $email)
                    .padding()
                    .background(Color.offwhite)
                    .cornerRadius(5)
                    .overlay(
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(Color.gray200, lineWidth: 1)
                    )
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                    .padding(.horizontal)
                
                Button(action: {
                    authViewModel.resetPassword(email: email)
                }) {
                    Text("Send Reset Link")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.offwhite)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(email.isEmpty ? Color.gray300 : Color.indigo600)
                        .cornerRadius(5)
                }
                .disabled(email.isEmpty)
                .padding(.horizontal)
                
                if authViewModel.passwordResetSent {
                    Text("Reset link sent! Check your email.")
                        .foregroundColor(.green)
                        .padding()
                }
                
                Spacer()
            }
            .padding(.top, 32)
            .navigationTitle("Reset Password")
            .navigationBarItems(trailing: Button("Cancel") {
                presentationMode.wrappedValue.dismiss()
            })
            .loadingOverlay(isLoading: authViewModel.isLoading)
        }
    }
}

// Preview provider
struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            SignInView()
                .environmentObject(AuthViewModel.unauthenticated)
        }
    }
}
