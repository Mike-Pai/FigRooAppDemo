//
//  HelpView.swift
//  FigRooApp
//
//  Created by 白謹瑜 on 2024/11/30.
//

import SwiftUI

struct HelpView: View {
  @Binding var isPresented: Bool
  @Binding var showHint: Bool
  @Binding var scale: CGFloat
  var body: some View {
    ZStack {
      Color.white.opacity(0.9)
        .edgesIgnoringSafeArea(.all)
      VStack {
        Text("點擊你的袋鼠並拍下你的餐點")
          .font(.headline)
        //                    .padding()
          .foregroundColor(.black)
        Text("由FigRoo來幫你計算這餐的營養素含量")
          .font(.headline)
        //                  .padding()
          .foregroundColor(.black)
        Image("說明圖去背")
          .resizable()
          .scaledToFit()
        Button("我知道了!") {
          withAnimation(.easeInOut) {
            isPresented = false
            showHint = true
          }
        }
        .padding()
        .background(Color.blue)
        .foregroundColor(.white)
        .cornerRadius(10)
      }
      .padding()
    }
    .background(
      ZStack {
        Color.orange.opacity(0.5)
      }
    )
    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .trailing)
    .transition(.move(edge: .trailing))
  }
}
