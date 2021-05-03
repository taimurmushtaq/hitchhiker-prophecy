//
//  NetworkConstants.swift
//  The Hitchhiker Prophecy
//
//  Created by Mohamed Matloub on 6/10/20.
//  Copyright © 2020 SWVL. All rights reserved.
//

import Foundation
import CryptoKit

enum NetworkConstants {
    static let baseUrl = "https://gateway.marvel.com"
    
    // I obtained keys by following the link mentioned in the document.
    // I did complete the registration process at Marvel
    static let publicKey = "4da3a810f9b7c8715aaf3756db3586f4"
    static let privateKey = "afff8531b8b3925281471041b1a4ad64a47e6504"
}

extension NetworkConstants {
    static func getHashValue(ts: String) -> String {
        let stringValue = ts + NetworkConstants.publicKey + NetworkConstants.privateKey
        
        let digest = Insecure.MD5.hash(data: stringValue.data(using: .utf8) ?? Data())
        return digest.map { String(format: "%02hhx", $0) }.joined()
    }
}
