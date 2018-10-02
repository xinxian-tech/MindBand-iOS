//
//  GeneratedMelody+CoreDataProperties.swift
//  Mind_Band
//
//  Created by 李灿晨 on 2018/10/2.
//  Copyright © 2018 李灿晨. All rights reserved.
//
//

import Foundation
import CoreData


extension GeneratedMelody {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<GeneratedMelody> {
        return NSFetchRequest<GeneratedMelody>(entityName: "GeneratedMelody")
    }

    @NSManaged public var melodyTitle: String?
    @NSManaged public var defaultSongName: String?
    @NSManaged public var conditionalComponents: String?
    @NSManaged public var defaultVideoName: String?

}
