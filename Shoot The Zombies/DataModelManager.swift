//
//  DataModelManager.swift
//  Shoot The Zombies
//
//  Created by Jalen Moya on 4/19/24.
//
// Josh Eres - jeeres
// Jalen Moya - jamoya
// Submitted: 4/25/24

import Foundation
import CoreData

class DataModelManager {
    
    static let shared = DataModelManager()
    
    private init() {}
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "DataModel")
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error {
                fatalError("Failed to load Core Data stack: \(error)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveScore(playerName: String, score: Int) {
        let managedContext = persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "HighScore", in: managedContext)!
        let highScore = NSManagedObject(entity: entity, insertInto: managedContext)
        highScore.setValue(playerName, forKey: "playerName")
        highScore.setValue(score, forKey: "score")
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save high score. \(error), \(error.userInfo)")
        }
    }
    
    func fetchHighScores() -> [HighScore] {
        let managedContext = persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "HighScore")
        let sortDescriptor = NSSortDescriptor(key: "score", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        do {
            let result = try managedContext.fetch(fetchRequest) as! [HighScore]
            print("Fetched high scores successfully:", result)
            return result
        } catch let error as NSError {
            print("Could not fetch high scores. \(error), \(error.userInfo)")
            return []
        }
    }

}
