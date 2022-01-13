//
//  Result.swift
//  2Local
//
//  Created by Hasan Sedaghat on 9/1/19.
//  Copyright © 2019 Hasan Sedaghat. All rights reserved.
//

import UIKit

class Result: Codable {
    var code: String?
    var message: String?
    var error: String?
    var status: String?
    enum CodingKeys: String, CodingKey {
        case code
        case message
        case error
        case status
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let message = try? container.decode(String.self, forKey: .message)
        let stringCode = try? container.decode(String.self, forKey: .code)
        let status = try? container.decode(String.self, forKey: .status)
        let intCode = try? container.decode(Int.self, forKey: .code)
        self.code = stringCode ?? "\(intCode ?? -1)"
        self.message = message
        self.status = status
        self.error = try? container.decode(String.self, forKey: .error)
    }
}

class ResultData<T: Codable>: Codable {
    var code: String?
    var message: String?
    var status: String?
    var record: T?
    var result: T?
    
    enum CodingKeys: String, CodingKey {
        case code
        case message
        case record
        case result
        case status
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let message = try? container.decode(String.self, forKey: .message)
        let record = try? container.decode(T.self, forKey: .record)
        let result = try? container.decode(T.self, forKey: .result)
        let stringCode = try? container.decode(String.self, forKey: .code)
        let intCode = try? container.decode(Int.self, forKey: .code)
        let status = try? container.decode(String.self, forKey: .status)
        self.code = stringCode ?? "\(intCode ?? -1)"
        self.message = message
        self.record = record
        self.result = result
        self.status = status
    }
}

class ResultDataArray<T: Codable>: Codable {
    var code: String?
    var message: String?
    var record: [T]?
    
    enum CodingKeys: String, CodingKey {
        case code
        case message
        case record
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let message = try? container.decode(String.self, forKey: .message)
        let record = try? container.decode([T].self, forKey: .record)
        let stringCode = try? container.decode(String.self, forKey: .code)
        let intCode = try? container.decode(Int.self, forKey: .code)
        self.code = stringCode ?? "\(intCode ?? -1)"
        self.message = message
        self.record = record
    }
}

class BSCResult<T: Codable>: Codable {
    var id: Int?
    var jsonrpc: String?
    var result: T?
    
    enum CodingKeys: String, CodingKey {
        case id
        case jsonrpc
        case result
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let id = try? container.decode(Int.self, forKey: .id)
        let jsonrpc = try? container.decode(String.self, forKey: .jsonrpc)
        let result = try? container.decode(T.self, forKey: .result)
        self.id = id
        self.jsonrpc = jsonrpc
        self.result = result
    }
}

class BSCArrayResult<T: Codable>: Codable {
    var status: String?
    var message: String?
    var result: [T]?
    
    enum CodingKeys: String, CodingKey {
        case status
        case message
        case result
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let status = try? container.decode(String.self, forKey: .status)
        let message = try? container.decode(String.self, forKey: .message)
        let result = try? container.decode([T].self, forKey: .result)
        self.status = status
        self.message = message
        self.result = result
    }
}

class BITRUEResult<T: Codable>: Codable {
    var symbol: String?
    var price: String?
	var lastPrice: String?
    
    enum CodingKeys: String, CodingKey {
        case symbol
        case price
		case lastPrice
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let symbol = try? container.decode(String.self, forKey: .symbol)
        let price = try? container.decode(String.self, forKey: .price)
		let lastPrice = try? container.decode(String.self, forKey: .lastPrice)
		
        self.symbol = symbol
        self.price = price ?? lastPrice
    }
}
