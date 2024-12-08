//
//  GroqChatRequsetElement.swift
//  FigRooApp
//
//  Created by 白謹瑜 on 2024/11/30.
//


// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//

import Foundation
// MARK: - ChatMutiElementRequest
struct ChatMutiElementRequest: Codable {
    let model: String
    let messages: [GroqChatRequset]
}

// MARK: - GroqChatRequset
struct GroqChatRequset: Codable {
    let role: String
    let content: [Content]
}

// MARK: - Content
struct Content: Codable {
    let type: String
    let text: String?
    let imageURL: ImageURL?

    enum CodingKeys: String, CodingKey {
        case type, text
        case imageURL = "image_url"
    }
}

// MARK: - ImageURL
struct ImageURL: Codable {
    let url: String
}

// MARK: - GroqChatResponse
struct GroqChatResponse: Codable {

    let choices: [Choice]

    enum CodingKeys: String, CodingKey {
        case choices

    }
}

// MARK: - Choice
struct Choice: Codable {

    let message: GroqMessage


    enum CodingKeys: String, CodingKey {
        case message
    }
}

// MARK: - Message
struct GroqMessage: Codable {
  let role, content: String
}

// MARK: - Encode/decode helpers

class JSONNull: Codable, Hashable {

    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
            return true
    }

    public var hashValue: Int {
            return 0
    }

    public init() {}

    public required init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            if !container.decodeNil() {
                    throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
            }
    }

    public func encode(to encoder: Encoder) throws {
            var container = encoder.singleValueContainer()
            try container.encodeNil()
    }
}

enum AIModel: String, CaseIterable {
    case Groq = "GroqLLM"
    case OpenAI = "ChatGPT"
}
