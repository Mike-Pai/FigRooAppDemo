//
//  EndDayView.swift
//  FigRooApp
//
//  Created by 白謹瑜 on 2024/12/4.
//

import SwiftUI


struct EndDayView: View {
  @State private var showKangaroo = false
  @State private var kangarooScale: CGFloat = 0.1
  @Binding var keepKangaroo: String
  @Binding var showEndDayView: Bool
  @State private var displayedText = ""
  @State private var fullText = "恭喜！你今天養了一隻..."
  @State private var currentIndex = 0

  @State private var showCloseButton = false

  var body: some View {
    VStack {
      Text(displayedText)
        .font(.system(size: 28, weight: .bold, design: .rounded))
        .foregroundColor(.orange)
        .padding()
        .multilineTextAlignment(.center)

      if showKangaroo {
        Image(keepKangaroo)
          .resizable()
          .scaledToFit()
          .frame(height: 200)
          .scaleEffect(kangarooScale)
          .animation(.spring(response: 0.5, dampingFraction: 0.5, blendDuration: 0.5), value: kangarooScale)
        Text(keepKangaroo)
          .font(.system(size: 28, weight: .bold, design: .rounded))
          .foregroundColor(.orange)
          .padding()
          .animation(.spring(response: 0.5, dampingFraction: 0.5, blendDuration: 0.5), value: kangarooScale)
      }

      Button(action: {
        showEndDayView = false
        
      }) {
        Text("關閉")
          .font(.system(size: 16, weight: .bold, design: .rounded))
          .foregroundColor(.white)
          .padding()
          .background(Color.orange)
          .cornerRadius(10)
      }
      .padding(.bottom, 8)
      .opacity(showCloseButton ? 1 : 0)
      .animation(.easeInOut(duration: 0.5), value: showCloseButton)
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(Color.yellow.opacity(0.2))
    .onAppear {
      startTypewriterEffect()

      // Modify the delay to include showing the close button
      DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
        withAnimation {
          showKangaroo = true
        }
        withAnimation(.spring(response: 0.5, dampingFraction: 0.5, blendDuration: 0.5).delay(0.3)) {
          kangarooScale = 1.0
        }
        // Add this to show the close button after a short delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
          withAnimation {
            showCloseButton = true
          }
        }
      }
    }
  }

  func startTypewriterEffect() {
    Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
      if currentIndex < fullText.count {
        let index = fullText.index(fullText.startIndex, offsetBy: currentIndex)
        displayedText += String(fullText[index])
        currentIndex += 1
      } else {
        timer.invalidate()
      }
    }
  }

 
}
