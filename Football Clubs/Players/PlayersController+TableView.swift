//
//  PlayersController+TableView.swift
//  Football Clubs
//
//  Created by Аслан on 17/09/2019.
//  Copyright © 2019 Doka.fun. All rights reserved.
//

import UIKit

extension PlayersController {
    
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
