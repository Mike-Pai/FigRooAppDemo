//
//  BunnyCharacterView.swift
//  FigRooApp
//
//  Created by 白謹瑜 on 2024/12/2.
//

import SwiftUI

struct BunnyCharacterView: View {
  @Binding var isShowingCamera: Bool
  @Binding var showHint: Bool
  @State private var offsetY: CGFloat = 0
  @Binding  var scale: CGFloat

  var body: some View {
    ZStack {
      Image("袋鼠")
        .resizable()
        .scaledToFit()
        .frame(height: 200)

//      if showHint {
        CuteFeedTextView(text: "點擊餵食")
          .offset(y: -110)
          .scaleEffect(scale)
          .animation(Animation.easeInOut(duration: 0.6).repeatForever(autoreverses: true), value: scale)
          .onAppear {
            withAnimation(.easeInOut(duration: 0.6).repeatForever(autoreverses: true)) {
              scale = 1.1
            }
            DispatchQueue.main.asyncAfter(deadline: .now()+1) {
              withAnimation {
//                showHint = false
                scale = 1
              }
            }
          }
//      }
    }
    .onTapGesture {
      isShowingCamera = true
    }
  }
}

struct CuteFeedTextView: View {
  let text: String

  var body: some View {
    Text(text)
      .font(.system(size: 20, weight: .bold, design: .rounded))
      .foregroundColor(.white)
      .padding(.horizontal, 12)
      .padding(.vertical, 8)
      .background(
        ZStack {
          Capsule()
            .fill(Color.orange)
          Capsule()
            .stroke(Color.white, lineWidth: 3)
        }
      )
      .shadow(color: Color.black.opacity(0.2), radius: 2, x: 0, y: 2)
      .overlay(
        Image(systemName: "arrow.down")
          .font(.system(size: 24, weight: .bold))
          .foregroundColor(.primary)
          .offset(y: 30)
      )
  }
}
