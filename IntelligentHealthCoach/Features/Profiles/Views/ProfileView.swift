// ProfileView.swift
import SwiftUI
import Kingfisher

struct ProfileView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @StateObject private var viewModel = ProfileViewModel()
    @State private var showingEditProfile = false
    @State private var showingSignOutConfirmation = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    profileHeader
                    
                    // Settings sections
                    settingsSection(title: "Account", options: viewModel.accountOptions)
                    settingsSection(title: "Workout", options: viewModel.workoutOptions)
                    settingsSection(title: "More", options: viewModel.moreOptions)
                    
                    // Sign out button
                    Button("Sign Out") {
                        showingSignOutConfirmation = true
                    }
                    .buttonStyle(SecondaryButtonStyle())
                    .padding(.horizontal)
                    .padding(.bottom, 50)
                }
                .padding(.top)
            }
            .navigationBarTitle("Profile", displayMode: .large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showingEditProfile = true
                    }) {
                        Text("Edit")
                            .foregroundColor(.indigo)
                    }
                }
            }
            .sheet(isPresented: $showingEditProfile) {
                EditProfileView()
            }
            .alert("Sign Out", isPresented: $showingSignOutConfirmation) {
                Button("Cancel", role: .cancel) { }
                Button("Sign Out", role: .destructive) {
                    authViewModel.signOut()
                }
            } message: {
                Text("Are you sure you want to sign out?")
            }
            .refreshable {
                await viewModel.loadUserProfile()
            }
            .onAppear {
                viewModel.loadUserProfile()
            }
        }
    }
    
    // MARK: - Profile Header
    var profileHeader: some View {
        VStack(spacing: 15) {
            // Profile photo
            if let avatarUrl = authViewModel.currentUser?.avatarUrl, !avatarUrl.isEmpty {
                KFImage(URL(string: avatarUrl))
                    .placeholder {
                        profilePlaceholder
                    }
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 100, height: 100)
                    .clipShape(Circle())
                    .shadow(radius: 5)
            } else {
                profilePlaceholder
            }
            
            // User name
            Text(authViewModel.currentUser?.fullName ?? "User")
                .font(.title2)
                .fontWeight(.bold)
            
            // User email
            Text(authViewModel.currentUser?.email ?? "")
                .font(.subheadline)
                .foregroundColor(.gray)
            
            // Stats row
            HStack(spacing: 30) {
                statView(value: "\(viewModel.workoutsCount)", title: "Workouts")
                
                Divider()
                    .frame(height: 40)
                
                statView(value: "\(viewModel.streakDays)", title: "Day Streak")
                
                Divider()
                    .frame(height: 40)
                
                statView(value: "\(viewModel.achievementsCount)", title: "Achievements")
            }
            .padding(.vertical, 15)
            .padding(.horizontal, 20)
            .background(Color.gray.opacity(0.1))
            .cornerRadius(10)
            .padding(.horizontal)
            .padding(.top, 10)
        }
        .padding(.vertical)
    }
    
    // Profile placeholder image
    var profilePlaceholder: some View {
        ZStack {
            Circle()
                .fill(Color.gray.opacity(0.3))
                .frame(width: 100, height: 100)
            
            Image(systemName: "person.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 40, height: 40)
                .foregroundColor(.gray)
        }
    }
    
    // User stats view
    func statView(value: String, title: String) -> some View {
        VStack(spacing: 5) {
            Text(value)
                .font(.title3)
                .fontWeight(.bold)
            
            Text(title)
                .font(.caption)
                .foregroundColor(.gray)
        }
    }
    
    // MARK: - Settings Section
    func settingsSection(title: String, options: [SettingOption]) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.system(size: 24, weight: .semibold))
                .padding(.horizontal)
            
            VStack(spacing: 0) {
                ForEach(options) { option in
                    Button(action: {
                        viewModel.handleSettingTap(option)
                    }) {
                        HStack {
                            HStack {
                                Image(systemName: option.iconName)
                                    .frame(width: 24, height: 24)
                                    .foregroundColor(.primary)
                                
                                Text(option.title)
                                    .font(.system(size: 16, weight: .medium))
                            }
                            
                            Spacer()
                            
                            if let value = option.value {
                                Text(value)
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundColor(.gray)
                            }
                            
                            if option.hasToggle {
                                Toggle("", isOn: Binding(
                                    get: { viewModel.toggleStates[option.id] ?? false },
                                    set: { viewModel.toggleStates[option.id] = $0 }
                                ))
                                .labelsHidden()
                            } else {
                                Image(systemName: "chevron.right")
                                    .foregroundColor(.gray)
                            }
                        }
                        .padding(.horizontal)
                        .padding(.vertical, 12)
                        .contentShape(Rectangle())
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                    if options.last?.id != option.id {
                        Divider()
                            .padding(.leading)
                    }
                }
            }
            .background(Color.white)
            .cornerRadius(12)
            .padding(.horizontal)
        }
    }
    
    // Preview
    #Preview {
        ProfileView()
            .environmentObject(AuthViewModel.preview)
    }
}

// Edit Profile View
struct EditProfileView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var bio = ""
    @State private var selectedImage: UIImage?
    @State private var showingImagePicker
