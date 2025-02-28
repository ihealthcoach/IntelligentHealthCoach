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
typealias SupabaseClient = Supabase.Client
typealias SupabaseAuth = Auth.GotrueClient
typealias SupabaseQuery = PostgrestClient
typealias SupabaseStorage = Storage.StorageClient
typealias SupabaseFunctions = Functions.FunctionsClient
typealias PostgrestResponse = PostgREST.PostgrestResponse
