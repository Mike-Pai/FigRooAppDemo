//
//  ProfileButton.swift
//  FigRooApp
//
//  Created by 白謹瑜 on 2024/11/30.
//

import SwiftUI

struct ProfileButton: View {
    @Binding var showingProfile: Bool

    var body: some View {
        Button(action: {
            withAnimation(.easeInOut) {
                showingProfile = true
            }
        }) {
            Image("小袋鼠")
                .resizable()
                .scaledToFit()
//                .foregroundColor(.orange)
        }
        .frame(width: 50, height: 50)
        .clipShape(Circle())
        .background{
            Circle()
            .fill(Color.white.opacity(0.5))
        }
    }
}

#Preview {
  ProfileButton(showingProfile: .constant(true))

}
