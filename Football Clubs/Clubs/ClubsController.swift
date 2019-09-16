//
//  ViewController.swift
//  Football Clubs
//
//  Created by Аслан on 16/09/2019.
//  Copyright © 2019 Doka.fun. All rights reserved.
//

import UIKit

class ClubsController: UITableViewController {

    var clubs = [Clubs]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Football Clubs"
        
        setUpLeftBarButtonItem(title: "Reset", selector: #selector(handleReset))
        setUpPlusButtonInNavBar(selector: #selector(handleAddClub))
        
        tableView.backgroundColor = .darkBlue
        tableView.separatorColor = .white
        tableView.tableFooterView = UIView()
        
        tableView.register(ClubCell.self, forCellReuseIdentifier: "cellId")
    }



}

