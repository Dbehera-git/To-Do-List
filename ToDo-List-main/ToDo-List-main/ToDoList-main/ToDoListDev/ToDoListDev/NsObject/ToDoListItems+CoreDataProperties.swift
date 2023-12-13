//
//  ToDoListItems+CoreDataProperties.swift
//  ToDoListDev
//
//  Created by iOS Developer on 04/12/23.
//
//

import Foundation
import CoreData


extension ToDoListItems {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ToDoListItems> {
        return NSFetchRequest<ToDoListItems>(entityName: "ToDoListItems")
    }

    @NSManaged public var name: String?
    @NSManaged public var createdAt: Date?

}

extension ToDoListItems : Identifiable {

}
