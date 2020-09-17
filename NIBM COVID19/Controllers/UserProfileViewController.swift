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
    private lazy var uid = Auth.auth().currentUser?.uid
    
    private lazy var userImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.layer.borderWidth = 0.5
        imageView.layer.borderColor = UIColor.black.cgColor
        imageView.layer.cornerRadius = 75
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(tapGestureRecognizer)
        return imageView
    }()
    
    private lazy var firstNameLabel: UILabel = {
        let label = UILabel()
        label.text = "First Name"
        label.textColor = .gray
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
        label.textColor = .gray
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
        label.textColor = .gray
        return label
    }()
    private lazy var addressTextView: UITextView = {
        let textView = UITextView()
        textView.layer.borderWidth = 1
        textView.layer.borderColor = UIColor(red: 204.0/255.0, green: 204.0/255.0, blue: 204.0/255.0, alpha: 1).cgColor
        textView.font = UIFont.preferredFont(forTextStyle: .body)
        textView.layer.cornerRadius = 5;
        return textView
    }()
    
    private lazy var userIdLabel: UILabel = {
        let label = UILabel()
        label.text = "User Id"
        label.textColor = .gray
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
    
    func getUserData()  {
        Database.database().reference().child(Constants.users).child(uid!).observeSingleEvent(of: .value, with: {(snapshot) in
            let value = snapshot.value as? NSDictionary
            print(value!)
            self.firstNameTextField.text = value?["firstName"] as? String
            self.lastNameTextField.text = value?["lastName"] as? String
            self.userIDTextField.text = value?["userId"] as? String
            self.addressTextView.text = value?["address"] as? String
        })
    }
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        let tappedImage = tapGestureRecognizer.view as! UIImageView
        
        let picker = UIImagePickerController()
        picker.sourceType = UIImagePickerController.isSourceTypeAvailable(.camera) ? .camera : .photoLibrary
        picker.mediaTypes = ["public.image"]
        picker.allowsEditing = true
        picker.delegate = self
        if picker.sourceType == .camera {
            PHPhotoLibrary.requestAuthorization { (status) in
                switch status {
                case.authorized:
                    self.present(picker, animated: true)
                default: break
                }
            }
        } else {
            present(picker, animated: true)
        }
        
    }
    
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        self.dismiss(animated: true) { [weak self] in
            guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
            self?.userImageView.image = image
            let data = image.pngData()
            
        }
        
    }
    
    func uploadImage()  {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUserInterface()
        getUserData()
    }
    
    func configureUserInterface() {
        
        view.backgroundColor = .white
        
        view.addSubview(userImageView)
        userImageView.setViewConstraints(top: view.safeAreaLayoutGuide.topAnchor, marginTop: 20, marginBottom: 20, marginLeft: 20, marginRight: 20, width: 150, height: 150)
        userImageView.centerX(view: view)
        
        view.addSubview(firstNameLabel)
        firstNameLabel.setViewConstraints(top: userImageView.bottomAnchor, left: view.safeAreaLayoutGuide.leftAnchor, right: view.safeAreaLayoutGuide.rightAnchor, marginTop: 10, marginBottom: 10, marginLeft: 20, marginRight: 20)
        view.addSubview(firstNameTextField)
        firstNameTextField.setViewConstraints(top: firstNameLabel.bottomAnchor, left: view.safeAreaLayoutGuide.leftAnchor, right: view.safeAreaLayoutGuide.rightAnchor, marginTop: 5, marginBottom: 10, marginLeft: 20, marginRight: 20)
        
        view.addSubview(lastNameLabel)
        lastNameLabel.setViewConstraints(top: firstNameTextField.bottomAnchor, left: view.safeAreaLayoutGuide.leftAnchor, right: view.safeAreaLayoutGuide.rightAnchor, marginTop: 10, marginBottom: 10, marginLeft: 20, marginRight: 20)
        view.addSubview(lastNameTextField)
        lastNameTextField.setViewConstraints(top: lastNameLabel.bottomAnchor, left: view.safeAreaLayoutGuide.leftAnchor, right: view.safeAreaLayoutGuide.rightAnchor, marginTop: 5, marginBottom: 10, marginLeft: 20, marginRight: 20)
        
        view.addSubview(userIdLabel)
        userIdLabel.setViewConstraints(top: lastNameTextField.bottomAnchor, left: view.safeAreaLayoutGuide.leftAnchor, right: view.safeAreaLayoutGuide.rightAnchor, marginTop: 10, marginBottom: 10, marginLeft: 20, marginRight: 20)
        view.addSubview(userIDTextField)
        userIDTextField.setViewConstraints(top: userIdLabel.bottomAnchor, left: view.safeAreaLayoutGuide.leftAnchor, right: view.safeAreaLayoutGuide.rightAnchor, marginTop: 5, marginBottom: 10, marginLeft: 20, marginRight: 20)
        
        view.addSubview(addressLabel)
        addressLabel.setViewConstraints(top: userIDTextField.bottomAnchor, left: view.safeAreaLayoutGuide.leftAnchor, right: view.safeAreaLayoutGuide.rightAnchor, marginTop: 10, marginBottom: 10, marginLeft: 20, marginRight: 20)
        view.addSubview(addressTextView)
        addressTextView.setViewConstraints(top: addressLabel.bottomAnchor, left: view.safeAreaLayoutGuide.leftAnchor, right: view.safeAreaLayoutGuide.rightAnchor, marginTop: 5, marginBottom: 10, marginLeft: 20, marginRight: 20, height: 100)
        
        view.addSubview(updateButton)
        updateButton.setViewConstraints(bottom: view.safeAreaLayoutGuide.bottomAnchor, left: view.safeAreaLayoutGuide.leftAnchor, right: view.safeAreaLayoutGuide.rightAnchor, marginTop: 10, marginBottom: 10, marginLeft: 20, marginRight: 20)
        
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
