//
//  CoreDataManager.swift
//  Football Clubs
//
//  Created by Аслан on 16/09/2019.
//  Copyright © 2019 Doka.fun. All rights reserved.
//

import CoreData

struct CoreDataManager {
    
    static let shared = CoreDataManager()
    
    let persistentContainer: NSPersistentContainer = {
        
        // Initialization of Core Data Stack
        let container = NSPersistentContainer(name: "FootballClubs")
        container.loadPersistentStores { (storeDescription, err) in
            if let err = err {
                fatalError("Loading of store failed \(err.localizedDescription)")
            }
        }
        return container
    }()
    
    func fetchClubs() -> [Clubs] {
        let context = persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<Clubs>(entityName: "Clubs")
        do {
            let clubs = try context.fetch(fetchRequest)
            return clubs
            
        } catch let fetchErr {
            print("Failed to fetch: ", fetchErr.localizedDescription)
            return []
        }
    }
    
    
    func createPlayer(playerName: String, birthDay: Date, playerPosition: String, club: Clubs) -> (Players?, Error?) {
        
        let context = persistentContainer.viewContext
        let player = NSEntityDescription.insertNewObject(forEntityName: "Players", into: context) as! Players
        
        player.clubs = club
        player.position = playerPosition
        player.name = playerName
        
        let playerInformation = NSEntityDescription.insertNewObject(forEntityName: "PlayerInformation", into: context) as! PlayerInformation
        
        playerInformation.birthday = birthDay
        player.playerInformation = playerInformation
        
        do {
            try context.save()
            return (player, nil)
        } catch let saveErr {
            print("Failed to create player ", saveErr)
            return (nil, saveErr)
        }
    }
    
}

