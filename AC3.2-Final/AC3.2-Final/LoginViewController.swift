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
  
//  let databaseReference = FIRDatabase.database().reference().child("posts")
//  var databaseObserver:FIRDatabaseHandle?
  var signInUser: FIRUser?
  let loginFailAlert = UIAlertController(title: "Login Failed", message: "Plz", preferredStyle: UIAlertControllerStyle.alert)
  let loginSuccessAlert = UIAlertController(title: "Login Successful!", message: "", preferredStyle: UIAlertControllerStyle.alert)
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
      (result : UIAlertAction) -> Void in
      print("OK")
    }
    loginSuccessAlert.addAction(okAction)
    loginFailAlert.addAction(okAction)
//    let feedVC = FeedTableViewController()
//    if FIRAuth.auth()?.currentUser != nil {
//      self.navigationController?.pushViewController(feedVC, animated: true)
//      
//    }
    
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
    if let email = emailTextField.text,
      let password = passwordTextField.text {
      FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user: FIRUser?, error: Error?) in
        
        if user != nil {
          let newViewController = FeedTableViewController()
          if let tabVC =  self.navigationController {
            tabVC.show(newViewController, sender: nil)
          }
        } else {
          self.present(self.loginFailAlert, animated: true, completion: nil)
        }
      })
    }

  }
  
  @IBAction func registeredPressed(_ sender: UIButton) {
  }
  

  
  
  
  /*
   // MARK: - Navigation
   
   // In a storyboard-based application, you will often want to do a little preparation before navigation
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
   // Get the new view controller using segue.destinationViewController.
   // Pass the selected object to the new view controller.
   }
   */
  
}
