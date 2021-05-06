//
//  NetworkConstants.swift
//  The Hitchhiker Prophecy
//
//  Created by Mohamed Matloub on 6/10/20.
//  Copyright © 2020 SWVL. All rights reserved.
//

import Foundation
import CryptoKit
import CommonCrypto

enum NetworkConstants {
    static let baseUrl = "https://gateway.marvel.com"
    
    // I obtained keys by following the link mentioned in the document.
    // I did complete the registration process at Marvel
    static let publicKey = "4da3a810f9b7c8715aaf3756db3586f4"
    static let privateKey = "afff8531b8b3925281471041b1a4ad64a47e6504"
}

extension NetworkConstants {
    static func getHashValue(ts: String) -> String {
        let stringValue = ts + NetworkConstants.privateKey + NetworkConstants.publicKey
        
        if #available(iOS 13.0, *) {
            let digest = Insecure.MD5.hash(data: stringValue.data(using: .utf8) ?? Data())
            return digest.map { String(format: "%02hhx", $0) }.joined()
        } else {
            if let strData = stringValue.data(using: String.Encoding.utf8) {
                var digest = [UInt8](repeating: 0, count:Int(CC_MD5_DIGEST_LENGTH))
                _ = strData.withUnsafeBytes { CC_MD5($0.baseAddress, UInt32(strData.count), &digest) }
                var md5String = ""
                for byte in digest {
                    md5String += String(format:"%02x", UInt8(byte))
                }
                
                if md5String.uppercased() == "8D84E6C45CE9044CAE90C064997ACFF1" {
                    print("Matching MD5 hash: 8D84E6C45CE9044CAE90C064997ACFF1")
                } else {
                    print("MD5 hash does not match: \(md5String)")
                }
                return md5String
            }
            
            return ""
        }
        
    }
}
