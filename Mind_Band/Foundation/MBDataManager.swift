//
//  MBDataManager.swift
//  Mind_Band
//
//  Created by 李灿晨 on 2018/10/7.
//  Copyright © 2018 李灿晨. All rights reserved.
//

import UIKit
import CoreData

class MBDataManager {
    
    static let defaultManager = MBDataManager()
    
    func saveTemporaryData(data: Data, postfix: String, completion: ((URL) -> ())?) {
        let url = getTemporaryURL(postfix: postfix)
        try! data.write(to: url)
        DispatchQueue.main.async {
            completion?(url)
        }
    }
    
    func getTemporaryURL(postfix: String) -> URL {
        return FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString).appendingPathExtension(postfix)
    }
    
}
