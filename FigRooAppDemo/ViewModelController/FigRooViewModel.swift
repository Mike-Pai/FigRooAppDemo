import SwiftUI
import PhotosUI

let apiKey = ""

enum CheckAction {
  case retake
  case confirm
}

struct FigRooViewModel: View {
  @State private var progressDots: [Bool] = [true, true, false, true, false]
  @AppStorage("storedshowingHelp") private var storedshowingHelp: Bool = true
  @State private var showingHelp = true
  @State private var showingProfile = false
  @State private var showCheckView = false
  @State private var capturedImage: UIImage? = nil
  @State private var isShowingCamera = false
  @State private var aiMessage: String?
  @State private var isLoading = false
  @State var calorieAmount: Double = 0
  @State  var sugarAmount: Double = 0
  @State  var proteinAmount: Double = 0
  @State  var fatAmount: Double = 0
  @State  var fiberAmount: Double = 0
  @State var TotalcalorieAmount: Double = 0
  @State  var TotalsugarAmount: Double = 0
  @State  var TotalproteinAmount: Double = 0
  @State  var TotalfatAmount: Double = 0
  @State var TotalfiberAmount: Double = 0
  @State var basicCalorie: Double = 2000
  @State var selectedModel: AIModel = .Groq

  @State var showHint = false
  @State var scale: CGFloat = 1.0
  @State private var shouldShowErrorAlert: Bool = false // 錯誤提示狀態
  @State private var showEndDaySheet = false

  @State var todayFig = "袋鼠"

  var body: some View {
    ZStack {

      VStack{
        HStack {
          ProfileButton(showingProfile: $showingProfile)
            .frame(width: 40, height: 40)
          Spacer()
          Text("基礎代謝率：\(String(format: "%.0f", basicCalorie)) 大卡")
            .font(.headline)

          Spacer()
        }
        .padding()
        .background(Color.orange.opacity(0.3))

        HStack{
          Spacer()
          Button(action: {
            withAnimation(.easeInOut) {
              showingHelp = true
            }
          }) {
            Image(systemName: "questionmark.circle")
              .resizable()
              .scaledToFit()
              .fontWeight(.thin)
              .frame(width: 50, height: 50)
              .foregroundColor(.black)
              .background {
                Circle()
                  .fill(Color.orange)
                  .opacity(0.5)
              }
              .padding()
          }
        }
        BunnyCharacterView( isShowingCamera: $isShowingCamera, showHint: $showHint, scale: $scale)
          .frame(height: 200)

        Spacer()
        FoodOptionsView(calorieAmount: TotalcalorieAmount,sugarAmount: TotalsugarAmount, proteinAmount: TotalproteinAmount, fatAmount: TotalfatAmount, fiberAmount: TotalfiberAmount, basicCalorie: $basicCalorie)
          .frame(maxWidth: 350)
          .cornerRadius(15, corners: [.topLeft, .topRight])
          .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: -2)

        Button(action: {


          if TotalcalorieAmount > basicCalorie*1.3{
           todayFig = "超胖袋鼠"
          }else if TotalcalorieAmount > basicCalorie*1.1 {
            todayFig = "胖袋鼠"
          } else if TotalcalorieAmount > basicCalorie*0.9 {
            todayFig = "健康袋鼠"
          } else if TotalcalorieAmount > basicCalorie*0.7 {
            todayFig = "瘦袋鼠"
          }else{
            todayFig = "小袋鼠"
          }
          resetNutrientsAll()
          showEndDaySheet = true
        }) {
          Text("结束這一天")
            .font(.system(size: 20, weight: .bold, design: .rounded))
            .foregroundColor(.white)
            .padding()
            .background(
              RoundedRectangle(cornerRadius: 20)
                .fill(LinearGradient(gradient: Gradient(colors: [Color.pink, Color.orange]), startPoint: .leading, endPoint: .trailing))
            )
            .overlay(
              RoundedRectangle(cornerRadius: 20)
                .stroke(Color.white, lineWidth: 2)
            )
            .shadow(color: Color.orange.opacity(0.3), radius: 10, x: 0, y: 5)
        }
        .padding(.bottom)
      }
      HelpView(isPresented: $showingHelp, showHint: $showHint, scale: $scale)
        .offset(x: showingHelp ? 0 : UIScreen.main.bounds.width)

      GeometryReader { geometry in
        ProfileView(isPresented: $showingProfile, basicCalorie: $basicCalorie)
        //          .frame(width: geometry.size.width * 0.7)
          .offset(x: showingProfile ? 0 : -geometry.size.width * 0.72, y: 75)
          .transition(.move(edge: .leading))
      }
      if showCheckView {
        Color.clear
          .background(Color.white.opacity(0.9))
          .edgesIgnoringSafeArea(.all)
        VisualEffectView(effect: UIBlurEffect(style: .systemMaterial))
        CheckCameraView(capturedImage: $capturedImage, showCheckView: $showCheckView, aiMessage: $aiMessage, TotalcalorieAmount: $TotalcalorieAmount,TotalsugarAmount: $TotalsugarAmount, TotalproteinAmount: $TotalproteinAmount, TotalfatAmount: $TotalfatAmount, TotalfiberAmount: $TotalfiberAmount, calorieAmount: $calorieAmount, sugarAmount: $sugarAmount, proteinAmount: $proteinAmount, fatAmount: $fatAmount, fiberAmount: $fiberAmount) { action in
          switch action {
          case .retake:
            resetNutrients()
            showCheckView = false
            isShowingCamera = true
          case .confirm:
            showCheckView = false
            withAnimation {
              TotalcalorieAmount += calorieAmount
              TotalsugarAmount += sugarAmount
              TotalproteinAmount += proteinAmount
              TotalfatAmount += fatAmount
              TotalfiberAmount += fiberAmount
            }
            resetNutrients()

          }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.clear)
      }
      if isLoading {
        Color.clear
          .background(Color.white.opacity(0.9))
          .edgesIgnoringSafeArea(.all)
        VisualEffectView(effect: UIBlurEffect(style: .systemMaterial))
        LoadingView()

      }
    }
    .sheet(isPresented: $isShowingCamera) {
      CameraView(image: $capturedImage, isPresented: $isShowingCamera, selectedModel: $selectedModel)
    }
    .sheet(isPresented: $showEndDaySheet) {
      EndDayView(keepKangaroo: $todayFig, showEndDayView: $showEndDaySheet)
    }
    .onChange(of: capturedImage) { newImage in
      guard let image = newImage else { return }
      capturedImage = image
      isShowingCamera = false
      isLoading = true
      let choosAPI = loadAPI(selectedModel: selectedModel)
      print(choosAPI)
      sendMutilMessage(image: image, api: choosAPI)
      showCheckView = true

    }
    .onAppear {
      showingHelp = storedshowingHelp
      storedshowingHelp = false
    }
    .alert("無法完成您的請求", isPresented: $shouldShowErrorAlert) {  } message: {
      Text("請確認您的網路連線狀態。")
    }
  }
  func resetNutrientsAll() {
    calorieAmount = 0
    sugarAmount = 0
    proteinAmount = 0
    fatAmount = 0
    fiberAmount = 0

    TotalcalorieAmount = 0
    TotalsugarAmount = 0
    TotalproteinAmount = 0
    TotalfatAmount = 0
    TotalfiberAmount = 0

  }
  func resetNutrients() {
    calorieAmount = 0
    sugarAmount = 0
    proteinAmount = 0
    fatAmount = 0
    fiberAmount = 0

  }
  // ApiKey-ChatGPT
  func loadAPI(selectedModel: AIModel) -> ModelFrame{
    let defaultAPI = ModelFrame(company: .Groq, url: "", model: "llama-3.2-90b-vision-preview", apiKey: "")
    if selectedModel == .Groq {
      guard let apiKey = Bundle.main.object(forInfoDictionaryKey: "ApiKey-Groq") as? String else { return defaultAPI}
      return ModelFrame(company: .Groq, url: "", model: "llama-3.2-90b-vision-preview", apiKey: apiKey)
    } else if selectedModel == .OpenAI {
      guard let apiKey = Bundle.main.object(forInfoDictionaryKey: "ApiKey-ChatGPT") as? String else { return defaultAPI}
      return ModelFrame(company: .OpenAI, url: "https://api.openai.com/v1/chat/completions", model: "gpt-4o-mini", apiKey: apiKey)
    }else{
      return defaultAPI
    }
  }
  func extractNutrients(from message: String) {
    let pattern = "(熱量|醣類|蛋白質|脂肪|纖維素)[：:：\\s]*([\\d.]+)\\s*(g|大卡|卡)"
    let regex = try? NSRegularExpression(pattern: pattern, options: [.dotMatchesLineSeparators])
    guard let regex = regex else {
      print("Failed to create regex pattern")
      return
    }
    let matches = regex.matches(in: message, options: [], range: NSRange(message.startIndex..., in: message))

    if matches.isEmpty {
      print("No matching nutrients found in the message.")
      return
    }

    for match in matches {
      if let nutrientRange = Range(match.range(at: 1), in: message),
         let valueRange = Range(match.range(at: 2), in: message),
         let value = Double(message[valueRange]) {
        let nutrient = message[nutrientRange]
        switch nutrient {
        case "熱量":
          calorieAmount = value
        case "醣類":
          sugarAmount = value
        case "蛋白質":
          proteinAmount = value
        case "脂肪":
          fatAmount = value
        case "纖維素":
          fiberAmount = value
        default:
          break
        }
      }
    }
  }
  func sendMutilMessage(image: UIImage, api: ModelFrame) {
    Task {
      do {
        let response = try await analyzeImage(image: image, chooseAPI: api)
        aiMessage = response
        extractNutrients(from: response)
        isLoading = false
      } catch {
        print("❌ \(error)")

        aiMessage = "無法解析"
        shouldShowErrorAlert = true
        isLoading = false
      }
    }
  }
  func convertImageToBase64(image: UIImage) -> String? {
    guard let imageData = image.jpegData(compressionQuality: 0.8) else { return nil }
    return imageData.base64EncodedString()
  }
  func analyzeImage(image: UIImage, chooseAPI: ModelFrame) async throws -> String{
    guard let base64Image = convertImageToBase64(image: image) else {
      print("Failed to convert image to Base64")
      return "Failed to convert image to Base64"
    }
    let apiUrl = URL(string: chooseAPI.url)!
    var request = URLRequest(url: apiUrl)
    request.httpMethod = "POST"

    let textContent = Content(type: "text", text: "你是一個飲食專家，你要幫我估算這一餐有多少熱量以及營養素，你只需回傳像這樣的格式：熱量：500 大卡 蛋白質：10 g 醣類：5 g 脂肪：15 g 纖維素： 20 g。請根據我給的圖片來粗略估算一個值就好，請不要有多餘的文字。", imageURL: nil)

    let imageURLString = "data:image/jpeg;base64,\(base64Image)"
    let imageContent = Content(type: "image_url", text: nil, imageURL: ImageURL(url: imageURLString))

    let contents: [Content] = [textContent, imageContent]
    let request_msg = GroqChatRequset(role: "user", content: contents)
    let data = try JSONEncoder().encode(ChatMutiElementRequest(model: chooseAPI.model, messages: [request_msg]))

    request.httpBody = data
    // check the apiKey is avalible  chooseAPI
    let session: URLSession = {
      let config = URLSessionConfiguration.default
      var header = config.httpAdditionalHeaders ?? [:]
      header["Content-Type"] = "application/json"
      header["Authorization"] = "Bearer \(chooseAPI.apiKey)"
      config.httpAdditionalHeaders = header

      return URLSession(configuration: config)
    }()

    let result = try await session.sendHTTPRequest(request)
    let groqChatResponse = try JSONDecoder().decode(GroqChatResponse.self, from: result.data)
    DispatchQueue.main.async {
      self.aiMessage = groqChatResponse.choices.first?.message.content ?? "無法解析"
    }
    return groqChatResponse.choices.first?.message.content ?? "無法解析"
  }
}

struct VisualEffectView: UIViewRepresentable {
  let effect: UIVisualEffect

  func makeUIView(context: UIViewRepresentableContext<Self>) -> UIVisualEffectView {
    UIVisualEffectView(effect: effect)
  }

  func updateUIView(_ uiView: UIVisualEffectView, context: UIViewRepresentableContext<Self>) {
    uiView.effect = effect
  }
}

struct ModelFrame {
  let company: AIModel
  let url: String
  let model: String
  let apiKey: String
}

struct FigRooViewPreviews: PreviewProvider {
  static var previews: some View {
    FigRooViewModel()
  }
}
