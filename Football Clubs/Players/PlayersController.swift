//
//  PlayersController.swift
//  Football Clubs
//
//  Created by Аслан on 17/09/2019.
//  Copyright © 2019 Doka.fun. All rights reserved.
//

import UIKit
import CoreData

class PlayersController: UITableViewController, CreatePlayerControllerDelegate {
    
    var club: Clubs?
    let cellId = "cellId"
    
    var allPlayers = [[Players]]()
    
    var playerPositions = [
        PlayerPosition.Defender.rawValue,
        PlayerPosition.Midfielder.rawValue,
        PlayerPosition.Forward.rawValue
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpPlusButtonInNavBar(selector: #selector(handleAdd))
        
        tableView.backgroundColor = .darkBlue
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        
        fetchPlayers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = club?.name
    }
    
    @objc private func handleAdd() {
        print("Trying to add an Player")
        
        let createPlayerController = CreatePlayerController()
        createPlayerController.delegate = self
        createPlayerController.club = self.club
        
        let navBarController = CustomNavigationController(rootViewController: createPlayerController)
        present(navBarController, animated: true, completion: nil)
    }
    
    // Protocol Func
    func didAddPlayer(player: Players) {
        // insert row with animation
        guard let section = playerPositions.firstIndex(of: player.position!) else { return }
        let row = allPlayers[section].count
        let insertIndexPath = IndexPath(row: row, section: section)
        
        allPlayers[section].append(player)
        tableView.insertRows(at: [insertIndexPath], with: .automatic)
    }
    
    private func fetchPlayers() {
        guard let clubPlayers = club?.players?.allObjects as? [Players] else { return }
        allPlayers = []
        
        // Filter Players by position
        playerPositions.forEach { (playerPosition) in
            allPlayers.append(
                clubPlayers.filter { $0.position == playerPosition }
            )
        }
    }
}
