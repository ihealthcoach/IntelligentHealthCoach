//
//  Supabasetypes.swift
//  IntelligentHealthCoach
//
//  Created by Casper Broe on 28/02/2025.
//


import Foundation
import Supabase
import Auth
import PostgREST
import Realtime
import Storage
import Functions

// Bridge between Supabase SDK types and our app
typealias SupabaseClient = Supabase.SupabaseClient  // Updated from Client to SupabaseClient
typealias SupabaseAuth = Auth.AuthClient  // Updated from GotrueClient to AuthClient
typealias SupabaseQuery = PostgrestClient
typealias SupabaseStorage = Storage.StorageClient  // This may need adjustment based on SDK
typealias SupabaseFunctions = Functions.FunctionsClient
typealias PostgrestResponse<T: Decodable> = PostgREST.PostgrestResponse<T>  // Added generic constraint
