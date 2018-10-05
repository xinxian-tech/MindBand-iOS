//
//  GeneratedMelody+CoreDataProperties.swift
//  
//
//  Created by 李灿晨 on 2018/10/5.
//
//

import Foundation
import CoreData


extension GeneratedMelody {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<GeneratedMelody> {
        return NSFetchRequest<GeneratedMelody>(entityName: "GeneratedMelody")
    }

    @NSManaged public var conditionalComponents: String?
    @NSManaged public var defaultSongName: String?
    @NSManaged public var defaultVideoName: String?
    @NSManaged public var melodyDescription: String?
    @NSManaged public var melodyTitle: String?
    @NSManaged public var titleImageName: String?

}
