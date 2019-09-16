//
//  PlayersController.swift
//  Football Clubs
//
//  Created by Аслан on 17/09/2019.
//  Copyright © 2019 Doka.fun. All rights reserved.
//

import UIKit
import CoreData

class IndentedLabel: UILabel {
    
    override func drawText(in rect: CGRect) {
        let customRect = rect.inset(by: UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0))
        super.drawText(in: customRect)
    }
}

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
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = IndentedLabel()
        label.text = playerPositions[section]
        label.textColor = .darkBlue
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.backgroundColor = .lightBlue
        return label
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
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
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allPlayers[section].count
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return allPlayers.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        
        let player = allPlayers[indexPath.section][indexPath.row]
        cell.textLabel?.text = player.name
        
        if let birthDay = player.playerInformation?.birthday {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMM dd, yyyy"
            cell.textLabel?.text = "\(player.name ?? "") - \(dateFormatter.string(from: birthDay))"
        }
        
        cell.backgroundColor = .tealColor
        cell.textLabel?.textColor = .white
        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        
        return cell
    }
}
