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
                    VStack(spacing: 12) {
                        Button("Sign Out") {
                            showingSignOutConfirmation = true
                        }
                        .buttonStyle(SecondaryButtonStyle())
                        
                        #if DEBUG
                        Button("Debug: Force Sign Out") {
                            // Skip confirmation and sign out immediately
                            authViewModel.signOut()
                        }
                        .font(.footnote)
                        .foregroundColor(.red)
                        .padding(.top, 4)
                        #endif
                    }
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
                Task {
                    await viewModel.loadUserProfile()
                }
            }
            .onAppear {
                Task {
                    await viewModel.loadUserProfile()
                    authViewModel.refreshUserProfile()
                    print("🔍 ProfileView - currentUser: \(String(describing: authViewModel.currentUser))")
                    print("🔍 ProfileView - firstName: \(authViewModel.currentUser?.firstName ?? "nil")")
                    print("🔍 ProfileView - fullName: \(authViewModel.currentUser?.fullName ?? "nil")")
                }
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
                                Image("chevron-right-mini")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 20, height: 20)
                                    .foregroundColor(Color("gray400"))
                            }
                        }
                        .padding(.horizontal)
                        .padding(.vertical, 16)
                        .contentShape(Rectangle())
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                    if options.last?.id != option.id {
                        Divider()
                            .padding(.leading)
                    }
                }
            }
            .background(Color.offwhite)
            .cornerRadius(12)
            .padding(.horizontal)
            .overlay(
                RoundedRectangle(cornerRadius: 8) // Stroke layer
                    .stroke(Color(.gray200), lineWidth: 1)
            )
        }
    }
    
    // Preview
    struct ProfileView_Previews: PreviewProvider {
        static var previews: some View {
            ProfileView()
                .environmentObject(AuthViewModel.preview)
        }
    }
    
    // EditProfileView addition to ProfileView.swift
    struct EditProfileView: View {
        @Environment(\.presentationMode) var presentationMode
        @State private var firstName = ""
        @State private var lastName = ""
        @State private var bio = ""
        @State private var selectedImage: UIImage?
        @State private var showingImagePicker = false
        
        var body: some View {
            NavigationView {
                Form {
                    Section(header: Text("Profile Photo")) {
                        HStack {
                            Spacer()
                            
                            Button(action: {
                                showingImagePicker = true
                            }) {
                                if let image = selectedImage {
                                    Image(uiImage: image)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 100, height: 100)
                                        .clipShape(Circle())
                                } else {
                                    Image(systemName: "person.crop.circle.badge.plus")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 100, height: 100)
                                        .foregroundColor(.indigo)
                                }
                            }
                            
                            Spacer()
                        }
                        .padding(.vertical)
                    }
                    
                    Section(header: Text("Personal Information")) {
                        TextField("First Name", text: $firstName)
                        TextField("Last Name", text: $lastName)
                        TextField("Bio", text: $bio)
                    }
                    
                    Section {
                        Button("Save Changes") {
                            // Save profile changes here
                            presentationMode.wrappedValue.dismiss()
                        }
                        .frame(maxWidth: .infinity, alignment: .center)
                        .foregroundColor(.indigo)
                    }
                }
                .navigationTitle("Edit Profile")
                .navigationBarItems(leading: Button("Cancel") {
                    presentationMode.wrappedValue.dismiss()
                })
                .sheet(isPresented: $showingImagePicker) {
                    ImagePicker(selectedImage: $selectedImage)
                }
            }
        }
    }
    
    // Add this utility struct for picking images
    struct ImagePicker: UIViewControllerRepresentable {
        @Binding var selectedImage: UIImage?
        @Environment(\.presentationMode) var presentationMode
        
        class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
            let parent: ImagePicker
            
            init(_ parent: ImagePicker) {
                self.parent = parent
            }
            
            func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
                if let image = info[.originalImage] as? UIImage {
                    parent.selectedImage = image
                }
                parent.presentationMode.wrappedValue.dismiss()
            }
            
            func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
                parent.presentationMode.wrappedValue.dismiss()
            }
        }
        
        func makeCoordinator() -> Coordinator {
            Coordinator(self)
        }
        
        func makeUIViewController(context: Context) -> UIImagePickerController {
            let picker = UIImagePickerController()
            picker.delegate = context.coordinator
            return picker
        }
        
        func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    }
}

#Preview {
    ProfileView()
        .environmentObject(AuthViewModel.preview)
}
