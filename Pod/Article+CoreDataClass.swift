//
//  Article+CoreDataClass.swift
//  day08
//
//  Created by Andriy GORDIYCHUK on 1/25/19.
//  Copyright © 2019 Andriy GORDIYCHUK. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Article)
final public class Article: NSManagedObject {
    
    override public var description:String {
        return "\(title ?? ""): \(content ?? "")"
    }
    
}
