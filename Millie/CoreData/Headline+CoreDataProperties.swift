//
//  Headline+CoreDataProperties.swift
//  Millie
//
//  Created by dlwlrma on 8/19/24.
//
//

import Foundation
import CoreData


extension Headline {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Headline> {
        return NSFetchRequest<Headline>(entityName: "Headline")
    }

    @NSManaged public var author: String
    @NSManaged public var title: String
    @NSManaged public var desc: String?
    @NSManaged public var url: String
    @NSManaged public var urlToImage: String?
    @NSManaged public var publishedAt: String
    @NSManaged public var content: String?

}

extension Headline : Identifiable {

}
