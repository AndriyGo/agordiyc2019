//
//  ArticleManager.swift
//  day08
//
//  Created by Andriy GORDIYCHUK on 1/25/19.
//  Copyright © 2019 Andriy GORDIYCHUK. All rights reserved.
//

import Foundation
import CoreData

final class ArticleManager {
    static let shared = ArticleManager()
    var managedObjectContext:NSManagedObjectContext
    var privateContext:NSManagedObjectContext
    
    init() {
        let modelURL = Bundle(for: ArticleManager.self).url(forResource: "article", withExtension:"momd")!
        let mom = NSManagedObjectModel(contentsOf:modelURL)!
        managedObjectContext = NSManagedObjectContext(concurrencyType:.mainQueueConcurrencyType)
        privateContext = NSManagedObjectContext(concurrencyType:.privateQueueConcurrencyType)
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel:mom)
        privateContext.persistentStoreCoordinator = coordinator
        managedObjectContext.parent = privateContext
        let options = [NSMigratePersistentStoresAutomaticallyOption:true,NSInferMappingModelAutomaticallyOption:true]
        let fileManager = FileManager.default
        let documentsURL = fileManager.urls(for: .documentDirectory, in:.userDomainMask).last
        let storeURL = documentsURL!.appendingPathComponent("statisticsModel.sqlite")
        do {
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName:nil, at:storeURL, options:options)
        }
        catch let error {
            fatalError(error.localizedDescription)
        }
    }
    
    func save() {
        if !(managedObjectContext.hasChanges || privateContext.hasChanges) {
            return
        }
        managedObjectContext.performAndWait {
            if self.managedObjectContext.hasChanges {
                do {
                    try self.managedObjectContext.save()
                }
                catch let error {
                    fatalError(error.localizedDescription)
                }
                
                self.privateContext.perform {
                    do {
                        try self.privateContext.save()
                    }
                    catch let error {
                        fatalError(error.localizedDescription)
                    }
                }
            }
        }
    }
    
    func newArticle(title: String?, content: String?, language: String?, image: NSData?) {
        let art = NSEntityDescription.entity(forEntityName: "Article",
                                             in: managedObjectContext)!
        let a = NSManagedObject(entity: art, insertInto: managedObjectContext) as! Article
        let date = NSDate()
        a.content = content
        a.creationDate = date
        a.image = image
        a.language = language
        a.modificationDate = date
        a.title = title
        save()
    }
    
    func removeArticle(_ article: Article) {
        managedObjectContext.delete(article)
        save()
    }
    
    func getAllArticles()->[Article] {
        let req:NSFetchRequest<Article> = Article.fetchRequest()
        do {
            let articles = try managedObjectContext.fetch(req)
            return articles
        }
        catch let error {
            fatalError(error.localizedDescription)
        }
        return []
    }
    
    func getArticles(withLang lang: String)->[Article] {
        let req:NSFetchRequest<Article> = Article.fetchRequest()
        req.predicate = NSPredicate(format: "language == %@", lang)
        do {
            let articles = try managedObjectContext.fetch(req)
            return articles
        }
        catch let error {
            fatalError(error.localizedDescription)
        }
        return []
    }
    
    func getArticles(containString str: String)->[Article] {
        let req:NSFetchRequest<Article> = Article.fetchRequest()
        let lang = NSPredicate(format: "language contains[c] %@", str)
        let title = NSPredicate(format: "title contains[c] %@", str)
        let content = NSPredicate(format: "content contains[c] %@", str)
        req.predicate = NSCompoundPredicate(orPredicateWithSubpredicates: [lang, title, content])
        do {
            let articles = try managedObjectContext.fetch(req)
            return articles
        }
        catch let error {
            fatalError(error.localizedDescription)
        }
        return []
    }
    
}
