//
//  NotificationRequest.swift
//  remote_notification
//
//  Created by Kanstantsin Ausianovich on 18.02.24.
//

import SwiftUI

struct NotificationRequest: View {
    @Binding var isPresented: Bool
    
    var body: some View {
        VStack {
            Spacer()
            Text("Notifications")
                .font(.system(.title, design: .rounded))
            Text("Set up notifications so as not to forget.")
                .multilineTextAlignment(.center)
                .font(.system(.headline, design: .rounded))
                .padding(.horizontal, 20.0)
            Spacer()
            Button(action: {
                Task {
                    if await NotificationProcessor.shared.shouldSendToSettings {
                        guard let url = URL(string: UIApplication.openNotificationSettingsURLString) else { return }
                        await UIApplication.shared.open(url)
                    } else {
                        try await NotificationProcessor.shared.requestAuthorization()
                    }
                    isPresented = false
                }
            }, label: {
                Text("Allow")
                    .font(.system(.body, design: .rounded, weight: .semibold))
                    .frame(height: 44.0)
                    .containerRelativeFrame(.horizontal, alignment: .center) { length, axis in
                        return length - 60.0
                    }
            })
            .buttonStyle(.borderedProminent)
            .buttonBorderShape(.roundedRectangle)
            Button(action: {
                isPresented = false
            }, label: {
                Text("Ask me later")
                    .font(.system(.body, design: .rounded))
                    .frame(height: 44.0)
                    .containerRelativeFrame(.horizontal, alignment: .center) { length, axis in
                        return length - 60.0
                    }
            })
            .buttonStyle(.bordered)
            .buttonBorderShape(.roundedRectangle)
        }
    }
}

#Preview {
    NotificationRequest(isPresented: .constant(false))
}
