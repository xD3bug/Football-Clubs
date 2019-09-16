//
//  CreatePlayerController.swift
//  Football Clubs
//
//  Created by Аслан on 17/09/2019.
//  Copyright © 2019 Doka.fun. All rights reserved.
//

import UIKit

protocol CreatePlayerControllerDelegate {
    func didAddPlayer(player: Players)
}

class CreatePlayerController: UIViewController {
    
    var club: Clubs?
    var delegate: CreatePlayerControllerDelegate?
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Name"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let nameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter name"
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let birthdayLabel: UILabel = {
        let label = UILabel()
        label.text = "Birthday"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let birthdayTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "MM/DD/YYYY"
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let playerPositionSegmentedControl: UISegmentedControl = {
        let types = [
            PlayerPosition.Defender.rawValue,
            PlayerPosition.Midfielder.rawValue,
            PlayerPosition.Forward.rawValue]
        
        let sc = UISegmentedControl(items: types)
        sc.selectedSegmentIndex = 0
        sc.tintColor = .darkBlue
        sc.translatesAutoresizingMaskIntoConstraints = false
        return sc
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .darkBlue
        setupUI()
        setUpCancelButton()
        
        navigationItem.title = "Create Player"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(handleSave))
    }
    
    @objc private func handleSave() {
        print("Saving player...")
        guard let playerName = nameTextField.text else { return }
        guard let club = self.club else { return }
        
        guard let birthdayText = birthdayTextField.text else { return }
        
        if playerName.isEmpty {
            showError(title: "Empty Name", message: "You have not entered name.")
            return
        }
        
        if birthdayText.isEmpty {
            showError(title: "Empty Birthday", message: "You have not entered birthday.")
            return
        }
        
        // Convert birthdayTextField.text to date object
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        
        guard let birthdayDate = dateFormatter.date(from: birthdayText) else {
            showError(title: "Bad Birthday Date", message: "Birthday date entered not valid.")
            return
        }
        
        guard let playerPosition = playerPositionSegmentedControl.titleForSegment(at: playerPositionSegmentedControl.selectedSegmentIndex) else { return }
        
        let tuple = CoreDataManager.shared.createPlayer(playerName: playerName, birthDay: birthdayDate, playerPosition: playerPosition, club: club)
        
        if let error = tuple.1 {
            showError(title: "Failed to save player.", message: "Please, try again.")
            return
        } else {
            dismiss(animated: true) {
                self.delegate?.didAddPlayer(player: tuple.0!)
            }
        }
    }
    
    private func showError(title: String, message: String) {
        
        let allertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        allertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        present(allertController, animated: true, completion: nil)
    }
    
    private func setupUI() {
        _ = setupLightBlueBackgroundView(height: 150)
        
        view.addSubview(nameLabel)
        nameLabel.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        nameLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
        nameLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        nameLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        view.addSubview(nameTextField)
        nameTextField.leftAnchor.constraint(equalTo: nameLabel.rightAnchor).isActive = true
        nameTextField.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        nameTextField.topAnchor.constraint(equalTo: nameLabel.topAnchor).isActive = true
        nameTextField.bottomAnchor.constraint(equalTo: nameLabel.bottomAnchor).isActive = true
        
        view.addSubview(birthdayLabel)
        birthdayLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor).isActive = true
        birthdayLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
        birthdayLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        birthdayLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        view.addSubview(birthdayTextField)
        birthdayTextField.leftAnchor.constraint(equalTo: birthdayLabel.rightAnchor).isActive = true
        birthdayTextField.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        birthdayTextField.topAnchor.constraint(equalTo: birthdayLabel.topAnchor).isActive = true
        birthdayTextField.bottomAnchor.constraint(equalTo: birthdayLabel.bottomAnchor).isActive = true
        
        view.addSubview(playerPositionSegmentedControl)
        playerPositionSegmentedControl.topAnchor.constraint(equalTo: birthdayLabel.bottomAnchor, constant: 0).isActive = true
        playerPositionSegmentedControl.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
        playerPositionSegmentedControl.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16).isActive = true
        playerPositionSegmentedControl.heightAnchor.constraint(equalToConstant: 34).isActive = true
    }
    
}
