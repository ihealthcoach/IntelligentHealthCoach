//
//  AuthView.swift
//  iHealthCoachApp
//
//  Created by Casper Broe on 26/02/2025.
//

import SwiftUI
import AuthenticationServices
import GoogleSignIn
import Supabase
import UIKit

struct AuthView: View {
    @State private var email = ""
    @State private var password = ""
    @EnvironmentObject var authViewModel: AuthViewModel

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    Spacer().frame(height: 20)

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
                    }

                    // Social Sign-In Buttons
                    VStack(spacing: 8) {
                        Button(action: {
                            // Get a reference to the current UIViewController
                            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                               let rootViewController = windowScene.windows.first?.rootViewController {
                                authViewModel.signInWithGoogle(from: rootViewController)
                            }
                        }) {
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
                        
                        /* Signup with Email */
                        NavigationLink(destination: CreateUserView()) {
                            HStack {
                                Image(systemName: "envelope.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 24, height: 24)
                                    .foregroundColor(Color("gray900"))
                                Text("Sign up with Email")
                                    .foregroundColor(.gray900)
                            }
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color("offwhite"))
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color("gray200"), lineWidth: 1)
                            )
                            .cornerRadius(5)
                        }
                    }

                    NavigationLink(destination: SignInView()) {
                        HStack {
                            Text("Already have an account?")
                                .foregroundColor(.gray400)
                            Text("Sign in")
                                .fontWeight(.bold)
                                .foregroundColor(.indigo600)
                        }
                    }
                }
            }
            .overlay(
                Group {
                    if authViewModel.isLoading {
                        LoadingView(message: "Please wait...")
                            .transition(.opacity)
                            .animation(.easeInOut, value: authViewModel.isLoading)
                    }
                }
            )
            .overlay(
                VStack {
                    Spacer()
                    if let errorMessage = authViewModel.errorMessage {
                        Text(errorMessage)
                            .font(.subheadline)
                            .foregroundColor(.white)
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
            .standardScreen()
        }
    }
}

#Preview {
    AuthView()
        .environmentObject(AuthViewModel.unauthenticated)
}
