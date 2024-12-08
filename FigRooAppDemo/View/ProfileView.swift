//
//  ProfileView.swift
//  FigRooApp
//
//  Created by 白謹瑜 on 2024/11/30.
//
import SwiftUI

struct ProfileView: View {
  @Binding var isPresented: Bool
  @Binding var basicCalorie: Double
  @State private var name = "白謹瑜"
  @State private var height = "174"
  @State private var weight = "69"
  @State private var year = "24"
  @State private var sex = "男"
  @State private var isEditing = false
  @State private var animationAmount: Double = -90

  var body: some View {
    VStack(spacing: 20) {
      Text("飼養員檔案")
        .font(.system(size: 36, weight: .bold))
        .foregroundColor(.black)
        .padding(.top)
      VStack(alignment: .center, spacing: 15) {
        PersonalInfoField(title: "姓名", value: $name, isEditing: isEditing, unit: "")
        HStack {
          PersonalInfoField(title: "身高", value: $height, isEditing: isEditing, unit: "cm")
          PersonalInfoField(title: "體重", value: $weight, isEditing: isEditing, unit: "kg")
        }
        HStack {
          PersonalInfoField(title: "性別", value: $sex, isEditing: isEditing, unit: "")
          PersonalInfoField(title: "年齡", value: $year, isEditing: isEditing, unit: "歲")

        }
      }

      HStack {
        Button(action: {
          isEditing.toggle()
          calculateBasicCalorie(height: Double(height)!, weight: Double(weight)! , year: Int(year)!, sex: sex)
        }) {
          Text(isEditing ? "儲存" : "編輯")
            .padding(.vertical, 8)
            .padding(.horizontal, 16)
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(8)
        }
        Button(action: {
          withAnimation(.easeInOut) {
            isPresented = false
            isEditing = false
          }
        }) {
          Text("關閉")
            .padding(.vertical, 8)
            .padding(.horizontal, 16)
            .background(Color.red)
            .foregroundColor(.white)
            .cornerRadius(8)
        }
      }
      .padding(.horizontal, 16)
    }
    .padding(.horizontal, 8)
    .padding(.vertical, 10)
    .background{

      Color.yellow.opacity(0.2)
        .background(
          Color.white)
    }
    .cornerRadius(32)

  }
  func calculateBasicCalorie(height: Double, weight: Double, year: Int, sex: String) {
    if (sex == "男") {
      basicCalorie = 66.5 + (13.75 * weight) + (5.003 * height) - (6.775 * Double(year))
    }else {
      basicCalorie = 655.1 + (9.563 * weight) + (1.850 * height) - (4.676 * Double(year))
    }
  }
}

struct PersonalInfoField: View {
  let title: String
  @Binding var value: String
  let isEditing: Bool
  let unit: String

  var body: some View {
    HStack {
      Text("\(title)：")
        .foregroundColor(.black)
      if isEditing {
        HStack {
          TextField("\(title) \(unit)", text: $value)
            .textFieldStyle(PlainTextFieldStyle())
            .padding(.vertical, 4)
            .background(Color.white)
            .cornerRadius(8)
            .foregroundColor(.black)
          Text(unit)
            .foregroundColor(.black)
        }
      } else {
        Text("\(value) \(unit)")
          .foregroundColor(.black)
      }
    }
    .padding(.vertical, 4)
    .padding(.horizontal, 8)
    .background(Color.white.opacity(0.65))
    .cornerRadius(8)
  }
}

#Preview(body: {
  ProfileView(isPresented: .constant(true), basicCalorie: .constant(1865))
})
