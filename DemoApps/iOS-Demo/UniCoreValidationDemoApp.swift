// UniCoreValidationDemoApp.swift
// Main app entry point for iOS Demo

import SwiftUI
import UniCoreValidation

@main
struct UniCoreValidationDemoApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

// MARK: - Main Navigation View

struct ContentView: View {
    var body: some View {
        NavigationStack {
            List {
                NavigationLink(destination: EmailValidationDemoView()) {
                    HStack {
                        Image(systemName: "envelope.circle.fill")
                            .foregroundColor(.blue)
                            .font(.title2)
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Email Validation")
                                .font(.headline)
                            Text("Real-time email feedback")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding(.vertical, 8)
                }
                
                NavigationLink(destination: PasswordValidationDemoView()) {
                    HStack {
                        Image(systemName: "lock.circle.fill")
                            .foregroundColor(.green)
                            .font(.title2)
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Password Validation")
                                .font(.headline)
                            Text("Strength indicator & confirmation")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding(.vertical, 8)
                }
                
                NavigationLink(destination: SignUpFormDemoView()) {
                    HStack {
                        Image(systemName: "doc.text.circle.fill")
                            .foregroundColor(.purple)
                            .font(.title2)
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Complete Sign-Up Form")
                                .font(.headline)
                            Text("6-field form with validation")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding(.vertical, 8)
                }
            }
            .navigationTitle("UniCore Validation")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}

// MARK: - Preview
#Preview {
    ContentView()
}
