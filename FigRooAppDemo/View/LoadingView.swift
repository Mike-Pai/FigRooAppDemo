//
//  LoadingView.swift
//  FigRooApp
//
//  Created by 白謹瑜 on 2024/12/1.
//
import SwiftUI

struct LoadingView: View {
    @State private var isAnimating = false
    @State private var jumpOffset: CGFloat = 0

    var body: some View {
        ZStack {
            Color.orange.opacity(0.35)
                .edgesIgnoringSafeArea(.all)

            VStack {
                KangarooFigure(jumpOffset: jumpOffset)
                    .frame(width: 100, height: 100)
                    .foregroundColor(.orange)

                Text("正在分析中...")
                    .font(.system(size: 20, weight: .bold, design: .rounded))
                    .foregroundColor(.orange)
                    .padding(.top, 20)

                HStack(spacing: 4) {
                    ForEach(0..<3) { index in
                        Circle()
                            .fill(Color.orange)
                            .frame(width: 10, height: 10)
                            .scaleEffect(isAnimating ? 1.0 : 0.5)
                            .animation(Animation.easeInOut(duration: 0.5).repeatForever().delay(Double(index) * 0.2), value: isAnimating)
                    }
                }
            }
        }
        .onAppear {
            isAnimating = true
            withAnimation(Animation.easeInOut(duration: 0.6).repeatForever()) {
                jumpOffset = -20
            }
        }
    }
}

struct KangarooFigure: View {
    var jumpOffset: CGFloat

    var body: some View {
        ZStack {
          Image("胖袋鼠")
            .resizable()
            .scaledToFit()
            .frame(width: 100, height: 100)
            .offset(y: jumpOffset)
        }
    }
}


struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingView()
    }
}

