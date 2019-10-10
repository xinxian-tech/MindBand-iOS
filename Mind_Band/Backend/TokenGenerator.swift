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
    var token: URL
}

class TokenGenerator: NSObject {
    static var shared = TokenGenerator()
    
    private let dataManager = MBDataManager.defaultManager
    
    private let emoji2mp3URLString: String = "http://120.26.202.103:8008/emoji2mp3"
    private let image2mp3URLString: String = "http://120.26.202.103:8008/img2mp3"
    
    func getHummingToken(url: URL, completion: ((MediaElementToken) -> ())?) {
        
    }
    
    func getEmojiToken(emoji: String, completion: ((MediaElementToken) -> ())?) {
        Alamofire.request(
            emoji2mp3URLString,
            method: HTTPMethod.get,
            parameters: ["emoji" : emoji],
            encoding: URLEncoding.default, headers: nil
        ).responseData() { dataResponse in
            print(dataResponse.response)
            self.dataManager.saveTemporaryData(data: dataResponse.value!, postfix: "mp3") { url in
                completion?(MediaElementToken(token: url))
            }
        }
    }
    
    func getImageToken(url: URL, completion: ((MediaElementToken) -> ())?) {
        let imageData = try! Data(contentsOf: url)
        Alamofire.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(imageData, withName: "file", fileName: "file.jpg", mimeType: "image/jpg")
        }, to: image2mp3URLString) { encodingResult in
            switch encodingResult {
            case .success(let upload, _, _):
                upload.uploadProgress() { progress in
                }
                upload.responseData() { dataResponse in
                    self.dataManager.saveTemporaryData(data: dataResponse.value!, postfix: "mp3") { url in
                        completion?(MediaElementToken(token: url))
                    }
                }
            case .failure(_):
                break
            }
        }
    }
}
