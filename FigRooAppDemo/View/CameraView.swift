//
//  CameraView.swift
//  FigRooApp
//
//  Created by 白謹瑜 on 2024/12/2.
//  目前測試有BUG...開相機與相簿那邊再修正

import SwiftUI

struct CameraView: View {
    @Binding var image: UIImage? // 選擇/拍攝的圖片
    @Binding var isPresented: Bool // 控制視圖的顯示狀態
    @Binding var selectedModel: AIModel // 選擇的 AI 模型
  @State private var sourceType: UIImagePickerController.SourceType = .photoLibrary // 控制圖片來源（相機或相簿）
    @State private var showImagePicker = false // 控制圖片選擇器的顯示狀態
    @State private var tempImage: UIImage? // 暫存選擇/拍攝的圖片
    @State private var kangarooOffset: CGFloat = -130
    @State private var isMovingRight = true


    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color.orange.opacity(0.2), Color.yellow.opacity(0.2)]), startPoint: .topLeading, endPoint: .bottomTrailing)
                .edgesIgnoringSafeArea(.all)

            VStack(spacing: 30) {


                if let image = tempImage {
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 300)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color.white, lineWidth: 4))
                        .shadow(radius: 10)

                    HStack(spacing: 50) {
                      Button(action: {
                        tempImage = nil
                      }) {
                            ButtonContent(systemName: "arrow.counterclockwise", text: "重新選擇", color: .red)

                        }

                        Button(action: {
                            self.image = tempImage
                            isPresented = false
                        }) {
                            ButtonContent(systemName: "checkmark.circle.fill", text: "確認", color: .green)
                        }
                    }
                  HStack(spacing: 0) {
                    Image("袋鼠")
                      .resizable()
                      .scaledToFit()
                      .frame(height: 150)
                      .shadow(radius: 5)
                    Menu {
                        ForEach(AIModel.allCases, id: \.self) { model in
                            Button(action: {
                                selectedModel = model
                            }) {
                                Text(model.rawValue)
                            }
                        }
                    } label: {
                        HStack {
                            Text("目前模型: \(selectedModel.rawValue)")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.orange)
                            Image(systemName: "chevron.down")
                        }
                        .padding()
                        .background(Color.white.opacity(0.8))
                        .cornerRadius(10)
                    }
                    .menuOrder(.priority)
                  }

                } else {
                    Text("選擇照片來源")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.orange)

                    HStack(spacing: 20) {
                        Button(action: {
                          if(!UIImagePickerController.isSourceTypeAvailable(sourceType)){
                            sourceType = .photoLibrary
                          }else{
                            sourceType = .camera
                          }
                            showImagePicker = true
                        }) {
                            BigButtonContent(systemName: "camera.fill", text: "拍照", color: .blue)
                        }

                        Button(action: {
                          if(!UIImagePickerController.isSourceTypeAvailable(sourceType)){
                            sourceType = .camera
                          }else{
                            sourceType = .photoLibrary
                          }

                            showImagePicker = true
                        }) {
                            BigButtonContent(systemName: "photo.on.rectangle.angled", text: "相簿", color: .purple)
                        }
                    }
                  HStack(spacing: 0) {
                    Image("袋鼠")
                      .resizable()
                      .scaledToFit()
                      .frame(height: 150)
                      .shadow(radius: 5)
                    Menu {
                        ForEach(AIModel.allCases, id: \.self) { model in
                            Button(action: {
                                selectedModel = model
                            }) {
                                Text(model.rawValue)
                            }
                        }
                    } label: {
                        HStack {
                            Text("目前模型: \(selectedModel.rawValue)")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.orange)
                            Image(systemName: "chevron.down")
                        }
                        .padding()
                        .background(Color.white.opacity(0.8))
                        .cornerRadius(10)
                    }
                    .menuOrder(.priority)
                  }


                }
            }
            .padding()
        }
        .sheet(isPresented: $showImagePicker) {
            CustomImagePicker(image: $tempImage, sourceType: sourceType)
        }
    }




}



struct ButtonContent: View {
    let systemName: String
    let text: String
    let color: Color

    var body: some View {
        VStack {
            Image(systemName: systemName)
                .font(.system(size: 30))
            Text(text)
                .font(.caption)
        }
        .foregroundColor(color)
        .padding()
        .background(Color.white.opacity(0.8))
        .clipShape(Capsule())
        .shadow(radius: 5)
    }
}

struct BigButtonContent: View {
    let systemName: String
    let text: String
    let color: Color

    var body: some View {
        VStack {
            Image(systemName: systemName)
                .font(.system(size: 50))
            Text(text)
                .font(.headline)
        }
        .foregroundColor(.white)
        .frame(width: 150, height: 150)
        .background(color)
        .clipShape(RoundedRectangle(cornerRadius: 25))
        .overlay(RoundedRectangle(cornerRadius: 25).stroke(Color.white, lineWidth: 4))
        .shadow(radius: 10)
    }
}

struct CustomImagePicker: UIViewControllerRepresentable {
    @Binding var image: UIImage?
    let sourceType: UIImagePickerController.SourceType



    func makeUIViewController(context: Context) -> UIImagePickerController { // 配置和創建圖片選擇器

        let picker = UIImagePickerController()

        picker.sourceType = sourceType
        picker.delegate = context.coordinator
        if sourceType == .camera {
            picker.cameraDevice = .rear
            picker.cameraCaptureMode = .photo
            picker.cameraFlashMode = .off
        }else{

        }
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    // 要實現 delegate & data source 等進階功能，需搭配 coordinator 這裡我沒懂直接加上去
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate { // 處理圖片選擇的委託方法
        let parent: CustomImagePicker

        init(_ parent: CustomImagePicker) {
            self.parent = parent
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.originalImage] as? UIImage {
                parent.image = image
            }
            picker.dismiss(animated: true)
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated: true)
        }
    }
}



#Preview(body: {
  CameraView(image: .constant(nil), isPresented: .constant(true), selectedModel: .constant(.OpenAI))
})
