//
//  FoodOptionsView.swift
//  FigRooApp
//
//  Created by 白謹瑜 on 2024/12/2.
//

import SwiftUI


struct FoodOptionsView: View {
  let calorieAmount: Double
  let sugarAmount: Double
  let proteinAmount: Double
  let fatAmount: Double
  let fiberAmount: Double
  @Binding var basicCalorie: Double

  var body: some View {
    HStack(spacing: 8) {
      FoodOptionItem(color: .yellow, icon: "🔥", value: calorieAmount, maxValue: basicCalorie, nutrient: "熱量", unit: "大卡")
      FoodOptionItem(color: .orange, icon: "🍳", value: proteinAmount, maxValue: basicCalorie * 0.2 / 4, nutrient: "蛋白質")
      FoodOptionItem(color: .red, icon: "🧈", value: fatAmount, maxValue: basicCalorie * 0.3 / 9, nutrient: "脂肪")
      FoodOptionItem(color: .brown, icon: "🥔", value: sugarAmount, maxValue: basicCalorie * 0.5 / 4, nutrient: "醣類")
      FoodOptionItem(color: .green, icon: "🥬", value: fiberAmount, maxValue: 30, nutrient: "纖維素")
    }
    .padding(.vertical)
  }
}

struct FoodOptionItem: View {
  let color: Color
  let icon: String
  let value: Double
  let maxValue: Double
  let nutrient: String
  var unit: String = "g"

  let frame_size: CGFloat = 0.9

  @State private var isPressed = false
  private var percentage: Double {
    min(value / maxValue, 1.0)
  }

  var body: some View {
    GeometryReader { geometry in
      VStack(spacing: 5) {
        ZStack(alignment: .bottom) {
          RoundedRectangle(cornerRadius: 10)
            .fill(color.opacity(0.2))
            .frame(height: geometry.size.height * frame_size)

          RoundedRectangle(cornerRadius: 10)
            .fill(color)
            .frame(height: geometry.size.height * frame_size * CGFloat(percentage))
        }
        .overlay(alignment: .bottom) {
          VStack(alignment: .center) {
            if isPressed {

              Text("\(String(format: nutrient == "熱量" ? "%.0f" : "%.1f", value))\(unit)")
                .font(.caption)
                .fontWeight(.bold)
                .foregroundColor(.primary)
                .opacity(isPressed ? 1 : 0)
                .scaleEffect(isPressed ? 1 : 0.5)
                .animation(.easeInOut(duration: 0.2), value: isPressed)
            }
            Text(icon)
              .font(.system(size: geometry.size.width * 0.35))
              .padding(.bottom, 5)



          }
        }
        .gesture(
          DragGesture(minimumDistance: 0)
            .onChanged { _ in isPressed = true }
            .onEnded { _ in isPressed = false }
        )

        Text(nutrient)
          .font(.caption)
          .foregroundColor(.gray)



      }
    }
  }
}
