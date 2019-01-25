//
//  Article+CoreDataProperties.swift
//  day08
//
//  Created by Andriy GORDIYCHUK on 1/25/19.
//  Copyright © 2019 Andriy GORDIYCHUK. All rights reserved.
//
//

import Foundation
import CoreData


extension Article {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Article> {
        return NSFetchRequest<Article>(entityName: "Article")
    }

    @NSManaged public var title: String?
    @NSManaged public var content: String?
    @NSManaged public var language: String?
    @NSManaged public var image: NSData?
    @NSManaged public var creationDate: NSDate?
    @NSManaged public var modificationDate: NSDate?

}
