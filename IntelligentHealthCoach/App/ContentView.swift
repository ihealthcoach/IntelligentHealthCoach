//
//  ContentView.swift
//  IntelligentHealthCoach
//
//  Created by Casper Broe on 27/02/2025.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    
    var body: some View {
        ZStack {
            if authViewModel.isAuthenticated {
                // Show main app content when user is logged in
                DashboardView()
                    .environmentObject(authViewModel)
            } else {
                // Show authentication screen when user is not logged in
                AuthView()
                    .environmentObject(authViewModel)
            }
        }
        .onAppear {
            // Check if user is already logged in
            authViewModel.checkSession()
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(AuthViewModel.unauthenticated)
}
