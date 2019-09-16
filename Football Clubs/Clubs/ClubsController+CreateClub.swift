//
//  ClubsController+CreateClub.swift
//  Football Clubs
//
//  Created by Аслан on 16/09/2019.
//  Copyright © 2019 Doka.fun. All rights reserved.
//

import UIKit

extension ClubsController: CreateClubControllerDelegate {
    
    func didAddClub(club: Clubs) {
        clubs.append(club)
        
        // Get indexPath of the bottom
        let newIndexPath = IndexPath(row: clubs.count - 1, section: 0)
        tableView.insertRows(at: [newIndexPath], with: .automatic)
    }
    
    func didEditClub(club: Clubs) {
        let row = clubs.firstIndex(of: club)
        let reloadIndexPath = IndexPath(row: row!, section: 0)
        tableView.reloadRows(at: [reloadIndexPath], with: .middle)
    }
    
}
