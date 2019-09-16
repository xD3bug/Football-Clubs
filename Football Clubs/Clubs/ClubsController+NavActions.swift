//
//  ClubsController+NavActions.swift
//  Football Clubs
//
//  Created by Аслан on 16/09/2019.
//  Copyright © 2019 Doka.fun. All rights reserved.
//

import UIKit
import CoreData

extension ClubsController {
    
    @objc func handleAddClub() {
        print("Adding Club...")
        
        let createClubController = CreateClubController()
        let navController = CustomNavigationController(rootViewController: createClubController)
        
        createClubController.delegate = self
        present(navController, animated: true, completion: nil)
    }
    
    @objc func handleReset() {
        print("Attemting to delete all core data objects")
        
        let context = CoreDataManager.shared.persistentContainer.viewContext
        
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: Clubs.fetchRequest())
        do {
            try context.execute(batchDeleteRequest)
            
            var indexPathToRemove = [IndexPath]()
            
            for(index, _) in clubs.enumerated() {
                let indexPath = IndexPath(row: index, section: 0)
                indexPathToRemove.append(indexPath)
            }
            
            clubs.removeAll()
            tableView.deleteRows(at: indexPathToRemove, with: .left)
            
        } catch let delErr {
            print("Failed to perform batchDeleteRequest ", delErr.localizedDescription)
        }
        
    }
}

