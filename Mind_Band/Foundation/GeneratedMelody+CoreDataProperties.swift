//
//  GeneratedMelody+CoreDataProperties.swift
//  
//
//  Created by 李灿晨 on 2018/10/6.
//
//

import Foundation
import CoreData


extension GeneratedMelody {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<GeneratedMelody> {
        return NSFetchRequest<GeneratedMelody>(entityName: "GeneratedMelody")
    }

    @NSManaged public var defaultSongName: String?
    @NSManaged public var defaultVideoName: String?
    @NSManaged public var melodyTitle: String?
    @NSManaged public var titleImageName: String?
    @NSManaged public var date: NSDate?
    @NSManaged public var id: UUID?

}
