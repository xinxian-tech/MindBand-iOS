//
//  TokenGenerator.swift
//  Mind_Band
//
//  Created by 李灿晨 on 7/13/19.
//  Copyright © 2019 李灿晨. All rights reserved.
//

import Foundation
import Alamofire


struct MediaElementToken {
    var token: String
}

class TokenGenerator: NSObject {
    static var shared = TokenGenerator()
    
    func getHummingToken(url: URL, completion: ((MediaElementToken) -> ())?) {
//        AF.upload(multipartFormData: { multipartFormdata in
//            
//        }, to: <#T##URLConvertible#>)
    }
    
    func getEmojiToken(emoji: String, completion: ((MediaElementToken) -> ())?) {
        
    }
    
    func getImageToken(url: URL, completion: ((MediaElementToken) -> ())?) {
        
    }
}
