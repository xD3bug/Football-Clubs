//
//  CreateClubController.swift
//  Football Clubs
//
//  Created by Аслан on 16/09/2019.
//  Copyright © 2019 Doka.fun. All rights reserved.
//

import UIKit
import CoreData

protocol CreateClubControllerDelegate {
    func didAddClub(club: Clubs)
    func didEditClub(club: Clubs)
}

class CreateClubController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var club: Clubs? {
        didSet {
            nameTextField.text = club?.name
            
            if let imageData = club?.imageData {
                clubImageView.image = UIImage(data: imageData)
                setupCircularImageStyle()
            }
            
            guard let founded = club?.founded else { return }
            datePicker.date = founded
        }
    }
    
    var delegate: CreateClubControllerDelegate?
    
    lazy var clubImageView: UIImageView = {
        let imageiew = UIImageView()
        imageiew.image = UIImage(named: "select_photo_empty")
        imageiew.contentMode = .scaleAspectFill
        imageiew.isUserInteractionEnabled = true
        imageiew.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSelectPhoto)))
        imageiew.translatesAutoresizingMaskIntoConstraints = false
        return imageiew
        
    }()
    
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
    
    let datePicker: UIDatePicker = {
        let dp = UIDatePicker()
        dp.datePickerMode = UIDatePicker.Mode.date
        dp.translatesAutoresizingMaskIntoConstraints = false
        return dp
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        view.backgroundColor = .darkBlue
        
        setUpCancelButton()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(handleSave))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationItem.title = club == nil ? "Create Club" : "Edit Cclub"
    }
    
    private func setupUI() {
        let lightBlueBackgroundView = setupLightBlueBackgroundView(height: 350)
        
        view.addSubview(clubImageView)
        clubImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 8).isActive = true
        clubImageView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        clubImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        clubImageView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        
        view.addSubview(nameLabel)
        nameLabel.topAnchor.constraint(equalTo: clubImageView.bottomAnchor).isActive = true
        nameLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
        nameLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        nameLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        view.addSubview(nameTextField)
        nameTextField.leftAnchor.constraint(equalTo: nameLabel.rightAnchor).isActive = true
        nameTextField.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        nameTextField.topAnchor.constraint(equalTo: nameLabel.topAnchor).isActive = true
        nameTextField.bottomAnchor.constraint(equalTo: nameLabel.bottomAnchor).isActive = true
        
        view.addSubview(datePicker)
        datePicker.topAnchor.constraint(equalTo: nameLabel.bottomAnchor).isActive = true
        datePicker.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        datePicker.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        datePicker.bottomAnchor.constraint(equalTo: lightBlueBackgroundView.bottomAnchor).isActive = true
        
    }
    
    @objc private func handleSave() {
        
        if club == nil {
            createClub()
        } else {
            saveClubChanges()
        }
    }
    
    // Create new Club inside Core Data
    private func createClub() {
        print("Trying to save club")
        
        let context = CoreDataManager.shared.persistentContainer.viewContext
        
        let club = NSEntityDescription.insertNewObject(forEntityName: "Clubs", into: context)
        
        club.setValue(nameTextField.text, forKey: "name")
        club.setValue(datePicker.date, forKey: "founded")
        
        if let clubImage = clubImageView.image {
            let imageData = clubImage.jpegData(compressionQuality: 0.8)
            club.setValue(imageData, forKey: "imageData")
        }
        
        // Perform the Save
        do {
            try context.save()
            
            dismiss(animated: true) {
                self.delegate?.didAddClub(club: club as! Clubs)
            }
        } catch let saveErr {
            print("Failed to save club \(saveErr.localizedDescription)")
        }
    }
    
    // Edit club
    private func saveClubChanges() {
        let context = CoreDataManager.shared.persistentContainer.viewContext
        
        club?.name = nameTextField.text
        club?.founded = datePicker.date
        
        if let clubImage = clubImageView.image {
            let imageData = clubImage.jpegData(compressionQuality: 0.8)
            club?.imageData = imageData
        }
        do {
            try context.save()
            
            // Save succeeded
            dismiss(animated: true) {
                self.delegate?.didEditClub(club: self.club!)
            }
        } catch let saveErr {
            print("Failed to save changes ", saveErr.localizedDescription)
        }
        
    }
    
    @objc private func handleSelectPhoto() {
        print("Trying to select photo")
        
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        
        present(imagePickerController, animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        print(info)
        
        if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            
            clubImageView.image = editedImage
            
        } else if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            
            clubImageView.image = originalImage
        }
        
        setupCircularImageStyle()
        
        dismiss(animated: true, completion: nil)
    }
    
    private func setupCircularImageStyle() {
        clubImageView.layer.cornerRadius = clubImageView.frame.width / 2
        clubImageView.clipsToBounds = true
        clubImageView.layer.borderColor = UIColor.darkBlue.cgColor
        clubImageView.layer.borderWidth = 2
    }
}

