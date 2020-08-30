//
//  UserProfileViewController.swift
//  NIBM COVID19
//
//  Created by Chanuka on 8/29/20.
//  Copyright © 2020 NIBM. All rights reserved.
//

import UIKit
import Photos
import Firebase

class UserProfileViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    // MARK: - Properties
    
    private lazy var userImageView: UIImageView = {
        let imageView = UIImageView()
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(tapGestureRecognizer)
        return imageView
    }()
    
    private lazy var firstNameLabel: UILabel = {
        let label = UILabel()
        label.text = "First Name"
        return label
    }()
    private lazy var firstNameTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.placeholder = "First Name"
        return textField
    }()
    
    private lazy var lastNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Last Name"
        return label
    }()
    private lazy var lastNameTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.placeholder = "Last Name"
        return textField
    }()
    
    private lazy var addressLabel: UILabel = {
        let label = UILabel()
        label.text = "Address"
        return label
    }()
    private lazy var addressTextView: UITextView = {
        let textView = UITextView()
        textView.layer.borderWidth = 1
        textView.layer.borderColor = UIColor(red: 204.0/255.0, green: 204.0/255.0, blue: 204.0/255.0, alpha: 1).cgColor
        textView.clipsToBounds = true;
        textView.layer.cornerRadius = 5;
        return textView
    }()
    
    private lazy var userIdLabel: UILabel = {
        let label = UILabel()
        label.text = "User Id"
        return label
    }()
    private lazy var userIDTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.placeholder = "Student Id/Employee Id"
        return textField
    }()
    
    private lazy var updateButton: UIButton = {
        let button = UIButton()
        button.setTitle("UPDATE", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.setTitleColor(.black, for: .highlighted)
        button.layer.cornerRadius = 5
        button.backgroundColor = UIColor(red: 166/255, green: 76/255, blue: 120/255, alpha: 1)
        button.addTarget(self, action: #selector(handleUpdate), for: .touchUpInside)
        return button
    }()
    
    @objc func handleUpdate() {
        let values = [
            "firstName": firstNameTextField.text,
            "lastName": lastNameTextField.text,
            "userId": userIDTextField.text,
            "address": addressTextView.text
        ]
        
        guard let currentUser = Auth.auth().currentUser else {return}
        let uid = currentUser.uid
        
        Database.database().reference().child("users").child(uid).updateChildValues(values as [AnyHashable : Any]) { (error, ref) in
            print("Successfuly Registerd and profile updated")
        }
        
    }
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        //        let tappedImage = tapGestureRecognizer.view as! UIImageView
        
        let picker = UIImagePickerController()
        picker.sourceType = UIImagePickerController.isSourceTypeAvailable(.camera) ? .camera : .photoLibrary
        picker.delegate = self
        present(picker, animated: true)
        //        PHPhotoLibrary.requestAuthorization { (status) in
        //            switch status {
        //            case.authorized:
        //            case.
        //            default: break
        //            }
        //        }
    }
    
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        self.dismiss(animated: true) { [weak self] in
            guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
            self?.userImageView.image = image
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUserInterface()
    }
    
    func configureUserInterface() {
        
        view.backgroundColor = .white
        
        let userProfileStackView = UIStackView(arrangedSubviews: [firstNameTextField, lastNameTextField, userIDTextField, addressTextView])
        userProfileStackView.axis = .vertical
        userProfileStackView.distribution = .fillEqually
        userProfileStackView.spacing = 15
        
        view.addSubview(userProfileStackView)
        userProfileStackView.translatesAutoresizingMaskIntoConstraints = false
        
        userProfileStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,
                                                  constant: 20).isActive = true
        userProfileStackView.rightAnchor.constraint(equalTo: view.rightAnchor,
                                                    constant: -20).isActive = true
        userProfileStackView.leftAnchor.constraint(equalTo: view.leftAnchor,
                                                   constant: 20).isActive = true
        
        view.addSubview(updateButton)
        updateButton.translatesAutoresizingMaskIntoConstraints = false
        
        updateButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor,
                                             constant: -10).isActive = true
        updateButton.rightAnchor.constraint(equalTo: view.rightAnchor,
                                            constant: -20).isActive = true
        updateButton.leftAnchor.constraint(equalTo: view.leftAnchor,
                                           constant: 20).isActive = true
        
        //        updateButton.translatesAutoresizingMaskIntoConstraints = false
        //        userImageView.translatesAutoresizingMaskIntoConstraints = false
        //        view.addSubview(updateButton)
        //        view.addSubview(userImageView)
        
        //        userImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        //        userImageView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -20).isActive = true
        //        userImageView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 20).isActive = true
        //        userImageView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        //        userImageView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        //
        //        updateButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor, constant: 0).isActive = true
        //        updateButton.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor, constant: 0).isActive = true
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
