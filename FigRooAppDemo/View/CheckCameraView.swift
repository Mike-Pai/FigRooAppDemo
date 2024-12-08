//
//  CheckCameraView.swift
//  FigRooApp
//
//  Created by 白謹瑜 on 2024/11/30.
//

import SwiftUI

struct CheckCameraView: View {
  @Binding var capturedImage: UIImage?
  @Binding var showCheckView: Bool
  @Binding var aiMessage: String? // Add aiMessage bindin
  @Binding var TotalcalorieAmount: Double
  @Binding  var TotalsugarAmount: Double
  @Binding  var TotalproteinAmount: Double
  @Binding  var TotalfatAmount: Double
  @Binding  var TotalfiberAmount: Double
  @Binding var calorieAmount: Double
  @Binding  var sugarAmount: Double
  @Binding  var proteinAmount: Double
  @Binding  var fatAmount: Double
  @Binding var fiberAmount: Double
  let onAction: (CheckAction) -> Void

  var body: some View {
    VStack(spacing: 4) {
                Text("這是你這餐的營養素含量：")
        .font(.title)
        .fontWeight(.bold)
                    .padding(.top)

                HStack(spacing: 8) {
                    NutritionComparisonView(
                        title: "Before",
                        calorieAmount: TotalcalorieAmount,
                        sugarAmount: TotalsugarAmount,
                        proteinAmount: TotalproteinAmount,
                        fatAmount: TotalfatAmount,
                        fiberAmount: TotalfiberAmount
                    )
                    NutritionComparisonView(
                        title: "After",
                        calorieAmount: calorieAmount + TotalcalorieAmount,
                        sugarAmount: sugarAmount + TotalsugarAmount,
                        proteinAmount: proteinAmount + TotalproteinAmount,
                        fatAmount: fatAmount + TotalfatAmount,
                        fiberAmount: fiberAmount + TotalfiberAmount
                    )
                }
                .frame(height: 240)
                .padding(.horizontal, 4)

      VStack(spacing: 10) {
        Text("準備好餵你的袋鼠了嗎？")
          .font(.body)

        GeometryReader { geometry in
          HStack(spacing: 8) {
            ZStack {
              if let image = capturedImage {
                Image(uiImage: image)
                  .resizable()
                  .scaledToFill()
                  .frame(width: geometry.size.width * 0.45, height: geometry.size.width * 0.45)
                  .clipShape(RoundedRectangle(cornerRadius: 20))
              } else {
                RoundedRectangle(cornerRadius: 20)
                  .fill(Color.orange.opacity(0.2))
                  .overlay(
                    Image(systemName: "camera.fill")
                      .resizable()
                      .scaledToFit()
                      .foregroundColor(.orange)
                      .frame(width: 40, height: 40)
                  )
              }
            }
            .frame(width: geometry.size.width * 0.45, height: geometry.size.width * 0.45)
            VStack(alignment: .center, spacing: 0) {
                       Text("AI分析結果")
                         .font(.headline)
                         .fontWeight(.bold)
                         .foregroundColor(.white)
                         .padding([.top, .bottom], 8)
                         .frame(maxWidth: .infinity)
                         .background(Color.orange.opacity(0.8))
                         .cornerRadius(16, corners: [.topLeft, .topRight])

                       ScrollView {
                         if let message = aiMessage {
                           Text(message)
                             .font(.subheadline)
                             .foregroundColor(.black)
                             .frame(maxWidth: .infinity, alignment: .leading)
                             .padding()
                         } else {
                           Text("AI 分析失敗，請再試一次。")
                             .font(.subheadline)
                             .foregroundColor(.red)
                             .padding()
                         }
                       }
                       .background(Color.brown.opacity(0.1))
            }
            .frame(width: geometry.size.width * 0.45, height: geometry.size.width * 0.45)
            .background(Color.white.opacity(0.5))
            .overlay(content: {
              RoundedRectangle(cornerRadius: 16)
                .stroke(Color.orange, lineWidth: 2)
            })
            .cornerRadius(16)
          }
          .frame(width: geometry.size.width, height: geometry.size.width * 0.45)
        }
        .frame(height: UIScreen.main.bounds.width * 0.45)
      }

      HStack {
        Button(action: { onAction(.retake) }) {
          Text("再試一次")
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.red.opacity(0.8))
            .foregroundColor(.white)
            .cornerRadius(10)
        }

        Button(action: { onAction(.confirm) }) {
          Text("餵他！")
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.green.opacity(0.8))
            .foregroundColor(.white)
            .cornerRadius(10)
        }
      }
      .padding(.horizontal)
    }
    .padding()
    .background(
      ZStack {
        Color.white.opacity(0.9)
        VisualEffectView(effect: UIBlurEffect(style: .systemMaterial))
      }
    )
    .cornerRadius(20)
    .shadow(radius: 10)
  }
}

struct NutritionComparisonView: View {
    let title: String
    let calorieAmount: Double
    let sugarAmount: Double
    let proteinAmount: Double
    let fatAmount: Double
    let fiberAmount: Double

    var body: some View {
        VStack(spacing: 5) {
            Text(title)
            .font(.title)
            .fontWeight(.bold)
                .foregroundColor(.brown)

            HStack(alignment: .bottom, spacing: 2) {
                NutritionBar(value: calorieAmount, color: .yellow, icon: "🔥", label: "熱量", unit: "大卡")
                NutritionBar(value: proteinAmount, color: .orange, icon: "🍳", label: "蛋白質")
                NutritionBar(value: fatAmount, color: .red, icon: "🥩", label: "脂肪")
                NutritionBar(value: sugarAmount, color: .brown, icon: "🥔", label: "醣類")
                NutritionBar(value: fiberAmount, color: .green, icon: "🥬", label: "纖維素")
            }
        }
    }
}


struct NutritionBar: View {
  let value: Double
  let color: Color
  let icon: String
  let label: String
  let unit: String

  init(value: Double, color: Color, icon: String, label: String, unit: String = "g") {
        self.value = value
        self.color = color
        self.icon = icon
        self.label = label
        self.unit = unit
    }

  var body: some View {
    VStack(spacing: 2) {
      ZStack(alignment: .bottom) {
        Rectangle()
          .fill(color.opacity(0.2))
          .frame(width: 22, height: 120)

        Rectangle()
          .fill(color)
          .frame(width: 22, height: CGFloat(min( label == "熱量" ? value/1800 * 120 : value, 120)))
      }
      .cornerRadius(3)

      Text(icon)
        .font(.system(size: 14))

      Text("\(String(format: label == "熱量" ? "%.0f" : "%.1f", value))\(unit)")
        .font(.system(size: 10))
        .fontWeight(.bold)
        .foregroundColor(color)
    }
  }
}

#Preview(body: {
  CheckCameraView(capturedImage: .constant(nil), showCheckView: .constant(true), aiMessage: .constant("糖類：30 g\n蛋白質：20\n脂肪：20 g"), TotalcalorieAmount: .constant(10), TotalsugarAmount: .constant(10.35), TotalproteinAmount: .constant(20.8), TotalfatAmount: .constant(30.7), TotalfiberAmount: .constant(100), calorieAmount: .constant(1000),  sugarAmount: .constant(100), proteinAmount: .constant(100), fatAmount: .constant(100.98), fiberAmount: .constant(100), onAction: { _ in })
})
