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
    
    func getAndSaveRandomGeneratedMelody() -> GeneratedMelody {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "GeneratedMelody", in: context)
        let melody = GeneratedMelody(entity: entity!, insertInto: context)
        melody.date = Date() as NSDate
        melody.id = UUID()
        melody.melodyTitle = DemoEngine.defaultEngine.generateTitle()
        melody.defaultVideoName = DemoEngine.defaultEngine.generateVideoName()
        melody.defaultSongName = DemoEngine.defaultEngine.generateMelodyName()
        melody.titleImageName = DemoEngine.defaultEngine.generateMelodyKeyImageName()
        try! context.save()
        return melody
    }
    
    func removeMelody(id: UUID) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "GeneratedMelody")
        fetchRequest.predicate = NSPredicate(format: "id=\"\(id)\"")
        if let fetchedResults = try! context.fetch(fetchRequest) as? [GeneratedMelody] {
            context.delete(fetchedResults.first!)
            try! context.save()
        }
    }
    
}
