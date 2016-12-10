//
//  ViewController.swift
//  On The Map
//
//  Created by Nikhil on 07/12/16.
//  Copyright © 2016 Nikhil. All rights reserved.
//
import Foundation
import UIKit

class LoginViewController: UIViewController {

    let textFieldDelegate = TextFieldDelegate()
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    @IBAction func loginButtonPressed(_ sender: AnyObject) {
        setUIEnabled(enabled: false)
        if usernameTextField.text!.isEmpty || passwordTextField.text!.isEmpty {
            setUIEnabled(enabled: true)
            Error.sharedInstance.showError(controller: self, title: "Empty Field", message: "Please enter both the fields")
        }
            else {
                Login.sharedInstance.loginWithUdacity(username: usernameTextField.text!, password:passwordTextField.text!) { (sucess, error) in
                    if sucess {
                               Login.sharedInstance.setName() { (sucess, error) in
                                if sucess {
                                           StudentLocation.sharedInstance.gettingStudentLocations() { (sucess, error) in
                                    if sucess {
                                            performUIUpdatesOnMain {
                                                self.setUIEnabled(enabled: true)
                                                self.passwordTextField.text = nil
                                                self.performSegue(withIdentifier: "Login", sender: self)
                                            }
                                    }
                                                else {
                                                      performUIUpdatesOnMain {
                                                            Error.sharedInstance.showError(controller: self, title: "Not Found", message: error!)
                                                            self.setUIEnabled(enabled: true)
                                                       }
                                                }
                                    
                                            }
                                }
                                    else {
                                            performUIUpdatesOnMain {
                                                    Error.sharedInstance.showError(controller: self, title: "JSON Error", message: error!)
                                                    self.setUIEnabled(enabled: true)
                                                }
                                    }
                                }
                        }
                        
                    else {
                           performUIUpdatesOnMain {
                                 Error.sharedInstance.showError(controller: self, title: "Not Found", message: error!)
                                 self.setUIEnabled(enabled: true)
                            }
                        }
                    }
                }
            }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        usernameTextField.delegate = textFieldDelegate
        passwordTextField.delegate = textFieldDelegate
    }

    func setUIEnabled(enabled:Bool) {
        usernameTextField.isEnabled = enabled
        passwordTextField.isEnabled = enabled
        loginButton.isEnabled = enabled
        if enabled {
            performUIUpdatesOnMain {
                self.activityIndicator.stopAnimating()
                self.loginButton.alpha = 1.0
                self.usernameTextField.alpha = 1.0
                self.passwordTextField.alpha = 1.0
            }
        }
            
            else {
                performUIUpdatesOnMain {
                    self.activityIndicator.startAnimating()
                    self.loginButton.alpha = 0.5
                    self.usernameTextField.alpha = 0.5
                    self.passwordTextField.alpha = 0.5
                }
            }
        }
    }
