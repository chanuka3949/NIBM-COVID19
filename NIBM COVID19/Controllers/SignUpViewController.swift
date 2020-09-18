//
//  SignUpViewController.swift
//  NIBM COVID19
//
//  Created by Chanuka on 8/28/20.
//  Copyright © 2020 NIBM. All rights reserved.
//

import UIKit
import Firebase
import GeoFire

class SignUpViewController: UIViewController {
    
    
    
    // MARK: - Properties
    private var locationManager = LocationHandler.sharedInstance.locationManager
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Create An Account"
        label.font = UIFont.systemFont(ofSize: 17, weight: UIFont.Weight.bold)
        label.textColor = .black
        return label
    }()
    
    private let userRoleSegmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: ["Student", "Staff"])
        segmentedControl.selectedSegmentTintColor = UIColor(red: 166/255, green: 76/255, blue: 120/255, alpha: 1)
        segmentedControl.selectedSegmentIndex = 0
        return segmentedControl
    }()
    
    private lazy var termsOfAgreementLabel: UILabel = {
        var firstString = NSMutableAttributedString(string: "By signing up, you agree with the ",  attributes: [.foregroundColor: UIColor.black])
        var secondString = NSMutableAttributedString(string: "Terms of Service ", attributes: [
            .foregroundColor: UIColor.blue, .underlineStyle: NSUnderlineStyle.single.rawValue
        ])
        var thirdString = NSMutableAttributedString(string: "and ", attributes: [.foregroundColor: UIColor.black])
        var fourthString = NSMutableAttributedString(string: "Privacy Policy", attributes: [
            .foregroundColor: UIColor.blue, .underlineStyle: NSUnderlineStyle.single.rawValue
        ])
        firstString.append(secondString)
        firstString.append(thirdString)
        firstString.append(fourthString)
        
        let label = UILabel()
        label.numberOfLines = 0
        label.attributedText = firstString
        label.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.light)
        label.textAlignment = .center
        return label
    }()
    
    private lazy var emailTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.placeholder = "Email"
        return textField
    }()
    
    private lazy var firstNameTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.placeholder = "First Name"
        return textField
    }()
    
    private lazy var lastNameTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.placeholder = "Last Name"
        return textField
    }()
    
    private lazy var passwordTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.placeholder = "Password"
        textField.isSecureTextEntry = true
        return textField
    }()
    
    private lazy var signUpButton: UIButton = {
        let button = UIButton()
        button.setTitle("Sign Up", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.setTitleColor(.black, for: .highlighted)
        button.layer.cornerRadius = 5
        button.backgroundColor = UIColor(red: 166/255, green: 76/255, blue: 120/255, alpha: 1)
        button.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside)
        return button
    }()
    
    private lazy var alreadyHaveAnAccountButton: UIButton = {
        let button = UIButton()
        button.setTitle("Already have an account?", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.setTitleColor(UIColor(red: 166/255, green: 76/255, blue: 120/255, alpha: 1), for: .highlighted)
        button.layer.cornerRadius = 5
        button.layer.borderWidth = 0.5
        button.addTarget(self, action: #selector(handleAlreadyHaveAnAccount), for: .touchUpInside)
        return button
    }()
    
    private lazy var popViewControllerButton: UIButton = {
        let button = UIButton()
        button.setTitle("╳", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 25)
        button.setTitleColor(.black, for: .normal)
        button.setTitleColor(UIColor(red: 166/255, green: 76/255, blue: 120/255, alpha: 1), for: .highlighted)
        button.addTarget(self, action: #selector(popViewController), for: .touchUpInside)
        return button
    }()
    
    @objc func popViewController() {
        //navigationController?.popViewController(animated: true)
    }
    
    @objc func handleAlreadyHaveAnAccount() {
        if ((navigationController?.viewControllers.count)! > 3) {
            navigationController?.popViewController(animated: true)
        } else {
            let signInViewController = SignInViewController()
            navigationController?.pushViewController(signInViewController, animated: true)
        }
    }
    
    @objc func handleSignUp() {
        
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        guard let firstName = firstNameTextField.text else { return }
        guard let lastName = lastNameTextField.text else { return }
        let role = userRoleSegmentedControl.selectedSegmentIndex
        
        
        Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
            if let error = error {
                print("ERROR: Failed to register user \(error)")
                return
            }
            print("User registered successfully!")
            
            guard let uid = result?.user.uid else { return }
            
            let geofireRef = DatabaseService.databaseReference.child(Constants.userLocations)
            let geoFire = GeoFire(firebaseRef: geofireRef)
            
            guard let location = self.locationManager?.location else { return }
            
            geoFire.setLocation(location, forKey: uid) { (error) in
                if (error != nil) {
                    print("An error occured: \(error!)")
                    return
                }
                print("Saved location successfully!")
            }
            
            self.saveUserProfileData(firstName: firstName, lastName: lastName, userRole: role, userId: uid)
        }
    }
    
    func saveUserProfileData(firstName: String, lastName: String, userRole: Int, userId: String) {
        
        let values = [
            "firstName": firstName,
            "lastName": lastName,
            "role": userRole
            ] as [String : Any]
        
        Database.database().reference().child(Constants.users).child(userId).updateChildValues(values) { (error, ref) in
            if let error = error {
                print("ERROR: Could not save user data to database \(error)")
                return
            }
            print("Successfuly Registerd and Profile created")
            self.navigateToTabViewController()
        }
    }
    
    func navigateToTabViewController() {
        let keyWindow = UIApplication.shared.connectedScenes
            .filter({$0.activationState == .foregroundActive})
            .map({$0 as? UIWindowScene})
            .compactMap({$0})
            .first?.windows
            .filter({$0.isKeyWindow}).first
        
        guard let mainViewController = keyWindow?.rootViewController as? TabBarViewController else { return }
        mainViewController.setupUserInterface()
        self.dismiss(animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUserInterface()
    }
    
    
    func setupUserInterface() {
        //navigationController?.navigationBar.isHidden = true
        view.backgroundColor = .white
        
        view.addSubview(popViewControllerButton)
        popViewControllerButton.translatesAutoresizingMaskIntoConstraints = false
        
        popViewControllerButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        popViewControllerButton.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 20).isActive = true
        
        view.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        titleLabel.centerXAnchor.constraint(equalTo:
            view.centerXAnchor).isActive = true
        titleLabel.topAnchor.constraint(equalTo: popViewControllerButton.bottomAnchor,
                                        constant: 20).isActive = true
        
        let signUpStackView = UIStackView(arrangedSubviews: [firstNameTextField, lastNameTextField, emailTextField, userRoleSegmentedControl, passwordTextField])
        signUpStackView.axis = .vertical
        signUpStackView.distribution = .fillEqually
        signUpStackView.spacing = 15
        
        view.addSubview(signUpStackView)
        signUpStackView.translatesAutoresizingMaskIntoConstraints = false
        
        signUpStackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor,
                                             constant: 20).isActive = true
        signUpStackView.rightAnchor.constraint(equalTo: view.rightAnchor,
                                               constant: -20).isActive = true
        signUpStackView.leftAnchor.constraint(equalTo: view.leftAnchor,
                                              constant: 20).isActive = true
        
        view.addSubview(signUpButton)
        
        signUpButton.translatesAutoresizingMaskIntoConstraints = false
        
        signUpButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        signUpButton.topAnchor.constraint(equalTo: signUpStackView.bottomAnchor, constant: 30).isActive = true
        signUpButton.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor,
                                            constant: -20).isActive = true
        signUpButton.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor,
                                           constant: 20).isActive = true
        signUpButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        view.addSubview(termsOfAgreementLabel)
        termsOfAgreementLabel.translatesAutoresizingMaskIntoConstraints = false
        
        termsOfAgreementLabel.centerXAnchor.constraint(equalTo:
            view.centerXAnchor).isActive = true
        termsOfAgreementLabel.topAnchor.constraint(equalTo: signUpButton.bottomAnchor,
                                                   constant: 20).isActive = true
        termsOfAgreementLabel.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor,
                                                     constant: -20).isActive = true
        termsOfAgreementLabel.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor,
                                                    constant: 20).isActive = true
        
        view.addSubview(alreadyHaveAnAccountButton)
        
        alreadyHaveAnAccountButton.translatesAutoresizingMaskIntoConstraints = false
        
        alreadyHaveAnAccountButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        alreadyHaveAnAccountButton.topAnchor.constraint(equalTo: termsOfAgreementLabel.bottomAnchor, constant: 20).isActive = true
        alreadyHaveAnAccountButton.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor,
                                                          constant: -20).isActive = true
        alreadyHaveAnAccountButton.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor,
                                                         constant: 20).isActive = true
        alreadyHaveAnAccountButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        
        
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
