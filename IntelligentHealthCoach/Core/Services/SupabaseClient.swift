//
//  SupabaseClient.swift
//  IntelligentHealthCoach
//
//  Created by Casper Broe on 27/02/2025.
//

import Foundation

// This is a simplified wrapper for the actual Supabase client
class SupabaseClient {
    private let supabaseURL: URL
    private let supabaseKey: String
    
    // Session and auth data
    private(set) var auth: SupabaseAuth!
    
    init(supabaseURL: URL, supabaseKey: String) {
        self.supabaseURL = supabaseURL
        self.supabaseKey = supabaseKey
        // Initialize auth after all properties are set
        self.auth = SupabaseAuth(client: self)
    }
    
    // Method to interact with a specific table
    func from(_ table: String) -> SupabaseQuery {
        return SupabaseQuery(client: self, table: table)
    }
    
    // Shared HTTP client for all requests
    func makeRequest(_ endpoint: String, method: String, body: Data? = nil) async throws -> (Data, URLResponse) {
        var request = URLRequest(url: supabaseURL.appendingPathComponent(endpoint))
        request.httpMethod = method
        request.addValue("Bearer \(supabaseKey)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if let body = body {
            request.httpBody = body
        }
        
        return try await URLSession.shared.data(for: request)
    }
}

// Auth module for Supabase
class SupabaseAuth {
    private weak var client: SupabaseClient?
    private(set) var session: SupabaseSession?
    
    init(client: SupabaseClient) {
        self.client = client
    }
    
    // Sign in method
    func signIn(email: String, password: String) async throws -> SupabaseAuthResponse {
        guard let client = client else {
            throw NSError(domain: "SupabaseAuth", code: 1, userInfo: [NSLocalizedDescriptionKey: "Client is nil"])
        }
        
        let parameters: [String: Any] = [
            "email": email,
            "password": password
        ]
        
        let jsonData = try JSONSerialization.data(withJSONObject: parameters)
        
        let (data, _) = try await client.makeRequest("auth/v1/token?grant_type=password", method: "POST", body: jsonData)
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let response = try decoder.decode(SupabaseAuthResponse.self, from: data)
        self.session = response.session
        return response
    }
    
    // Sign up method
    func signUp(email: String, password: String) async throws -> SupabaseAuthResponse {
        guard let client = client else {
            throw NSError(domain: "SupabaseAuth", code: 1, userInfo: [NSLocalizedDescriptionKey: "Client is nil"])
        }
        
        let parameters: [String: Any] = [
            "email": email,
            "password": password
        ]
        
        let jsonData = try JSONSerialization.data(withJSONObject: parameters)
        
        let (data, _) = try await client.makeRequest("auth/v1/signup", method: "POST", body: jsonData)
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let response = try decoder.decode(SupabaseAuthResponse.self, from: data)
        self.session = response.session
        return response
    }
    
    // Sign out method
    func signOut() async throws {
        guard let client = client else {
            throw NSError(domain: "SupabaseAuth", code: 1, userInfo: [NSLocalizedDescriptionKey: "Client is nil"])
        }
        
        _ = try await client.makeRequest("auth/v1/logout", method: "POST")
        self.session = nil
    }
}

// Query builder for Supabase
class SupabaseQuery {
    private weak var client: SupabaseClient?
    private let table: String
    private var queryParameters: [String: String] = [:]
    
    init(client: SupabaseClient, table: String) {
        self.client = client
        self.table = table
    }
    
    // Select method
    func select(_ columns: String = "*") -> Self {
        queryParameters["select"] = columns
        return self
    }
    
    // Equality filter
    func eq(_ column: String, value: Any) -> Self {
        queryParameters[column] = "eq.\(value)"
        return self
    }
    
    // Order results
    func order(_ column: String, ascending: Bool = true) -> Self {
        queryParameters["order"] = "\(column).\(ascending ? "asc" : "desc")"
        return self
    }
    
    // Ensure single result
    func single() -> Self {
        queryParameters["single"] = "true"
        return self
    }
    
    // Execute the query
    func execute() async throws -> SupabaseResponse {
        guard let client = client else {
            throw NSError(domain: "SupabaseQuery", code: 1, userInfo: [NSLocalizedDescriptionKey: "Client is nil"])
        }
        
        var endpoint = "rest/v1/\(table)"
        
        // Add query parameters
        if !queryParameters.isEmpty {
            let queryString = queryParameters.map { "\($0.key)=\($0.value)" }.joined(separator: "&")
            endpoint += "?\(queryString)"
        }
        
        let (data, _) = try await client.makeRequest(endpoint, method: "GET")
        return SupabaseResponse(data: data)
    }
    
    // Insert data
    func insert<T: Encodable>(_ value: T) async throws -> SupabaseResponse {
        guard let client = client else {
            throw NSError(domain: "SupabaseQuery", code: 1, userInfo: [NSLocalizedDescriptionKey: "Client is nil"])
        }
        
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        let jsonData = try encoder.encode(value)
        
        let endpoint = "rest/v1/\(table)"
        let (data, _) = try await client.makeRequest(endpoint, method: "POST", body: jsonData)
        
        return SupabaseResponse(data: data)
    }
    
    // Update data
    func update(_ values: [String: Any]) async throws -> SupabaseResponse {
        guard let client = client else {
            throw NSError(domain: "SupabaseQuery", code: 1, userInfo: [NSLocalizedDescriptionKey: "Client is nil"])
        }
        
        let jsonData = try JSONSerialization.data(withJSONObject: values)
        
        var endpoint = "rest/v1/\(table)"
        
        // Add filter parameters
        if !queryParameters.isEmpty {
            let queryString = queryParameters.map { "\($0.key)=\($0.value)" }.joined(separator: "&")
            endpoint += "?\(queryString)"
        }
        
        let (data, _) = try await client.makeRequest(endpoint, method: "PATCH", body: jsonData)
        return SupabaseResponse(data: data)
    }
}
