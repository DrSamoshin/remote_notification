//
//  ContentView.swift
//  remote_notification
//
//  Created by Siarhei Samoshyn on 18/02/2024.
//

import SwiftUI

struct ContentView: View {
    
    @State var isRequestPresented: Bool = false
    
    var body: some View {
        VStack {
            Button(action: {
                isRequestPresented = true
            }, label: {
                Text("Request notifications")
            })
        }
        .padding()
        .sheet(isPresented: $isRequestPresented, content: {
            NotificationRequest(isPresented: $isRequestPresented)
        })
    }
}

#Preview {
    ContentView()
}
