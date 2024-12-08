//
//  Extension.swift
//  FigRooApp
//
//  This Page is From Jane.
//
import Foundation

extension URLSession {
    func sendHTTPRequest(_ request: URLRequest) async throws -> (data: Data, response: HTTPURLResponse) {
        let (data, response) = try await data(for: request) // self.data(for: request) <- 其實是 self.data(for: request)，但因為在                                                                                       extension 裡面，所以可以省略 self。
        // 把拿到的 Response 轉換成 HTTP Response，假如無法轉換表示網址錯了，應該直接在開發時就強制當掉。
        guard let httpResponse = response as? HTTPURLResponse else {
            fatalError("不是 HTTP 請求，請檢查你的網址")
        }
        // 確認回傳的 HTTP 狀態碼是否在 200 的區間，假如不是就表示有問題，就拋出一個狀態碼的 error。
        guard 200...299 ~= httpResponse.statusCode else {
            if let responseText = String(data: data, encoding: .utf8) {
                // 假如可以解析出一些文字訊息就印出來，方便 debug。
                print("⚠️ \(responseText)")
            }
            throw APIError.unexpectedStatusCode(httpResponse.statusCode)
        }
        
        return (data, httpResponse)
    }
}
