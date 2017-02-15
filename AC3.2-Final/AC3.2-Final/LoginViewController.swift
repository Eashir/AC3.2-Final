//
//  LoginViewController.swift
//  AC3.2-Final
//
//  Created by Eashir Arafat on 2/15/17.
//  Copyright © 2017 C4Q. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth


class LoginViewController: UIViewController, UITextFieldDelegate {
  @IBOutlet weak var emailTextField: UITextField!
  @IBOutlet weak var passwordTextField: UITextField!
  
//  let databaseReference = FIRDatabase.database().reference().child("users")
  var signInUser: FIRUser?
  
  let loginFailAlert = UIAlertController(title: "Login Failed", message: "Plz", preferredStyle: UIAlertControllerStyle.alert)
  let loginSuccessAlert = UIAlertController(title: "Login Successful!", message: "", preferredStyle: UIAlertControllerStyle.alert)
  let loginAnonSuccessAlert = UIAlertController(title: "Login Successful!", message: "Logged in anonymously", preferredStyle: UIAlertControllerStyle.alert)
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    passwordTextField.isSecureTextEntry = true
    addActionsToAlert()
    
  }
  
  func addActionsToAlert () {
    let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
      (result : UIAlertAction) -> Void in
    }
    
    let okSuccessAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
      (result : UIAlertAction) -> Void in
      let storyboard = UIStoryboard(name: "Main", bundle: nil)
      let tvc = storyboard.instantiateViewController(withIdentifier: "tabController")
      self.present(tvc, animated: true, completion: nil)
    }
    
    loginSuccessAlert.addAction(okSuccessAction)
    loginFailAlert.addAction(okAction)
    loginAnonSuccessAlert.addAction(okAction)
  }
  
  // MARK: UITextFieldDelegate
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    switch textField {
    case emailTextField:
      emailTextField.resignFirstResponder()
    case passwordTextField:
      passwordTextField.resignFirstResponder()
    default:
      break
    }
    return true
  }
  
  // MARK: Actions
  @IBAction func didTapLogin(_ sender: UIButton) {
//    loginAnonymously()
        if let email = emailTextField.text,
          let password = passwordTextField.text {
          FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user: FIRUser?, error: Error?) in
    
            if user != nil {
              self.present(self.loginSuccessAlert, animated: true, completion: nil)
            } else {
              self.present(self.loginFailAlert, animated: true, completion: nil)
            }
          })
        }
  }
  
  @IBAction func registeredPressed(_ sender: UIButton) {
    if let email = emailTextField.text,
      let password = passwordTextField.text {
      FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user: FIRUser?, error: Error?) in
        if error != nil {
          print (error!)
          
          return
        }
        
        guard let uid = user?.uid else { return }
//        self.registerUserIntoDatabaseWithUID(uid: uid)

      })
    }
    
  }
//  
//  private func registerUserIntoDatabaseWithUID(uid: String) {
//    let userReference = self.databaseReference.child(uid)
//    
//    let storyboard = UIStoryboard(name: "Main", bundle: nil)
//    let tvc = storyboard.instantiateViewController(withIdentifier: "tabController")
//    self.present(tvc, animated: true, completion: nil)
//
//  }

  private func loginAnonymously() {
    FIRAuth.auth()?.signInAnonymously(completion: { (user: FIRUser? , error: Error? ) in
      
      print("signed in anonymously")
      if error != nil {
        print("Error: \(error!)")
        self.present(self.loginFailAlert, animated: true, completion: nil)      }
      
      if user != nil {
        self.present(self.loginAnonSuccessAlert, animated: true, completion: nil)
      }
    })
    
    
  }
  
}
