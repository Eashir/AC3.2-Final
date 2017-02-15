//
//  UploadViewController.swift
//  AC3.2-Final
//
//  Created by Eashir Arafat on 2/15/17.
//  Copyright © 2017 C4Q. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth

class UploadViewController: UIViewController, UIImagePickerControllerDelegate,UINavigationControllerDelegate {
  
  @IBOutlet weak var uploadImageView: UIImageView!
  @IBOutlet weak var uploadDescriptionTextView: UITextView!
  
  var capturedImages: [UIImage]! = []
  var imagePickerController: UIImagePickerController!
  var databaseReference: FIRDatabaseReference!
  var user: FIRUser?
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    if !UIImagePickerController.isSourceTypeAvailable(.camera) {
      if let toolbar = self.navigationController?.toolbar,
        var toolbarItems = toolbar.items {
        if toolbarItems.count > 2 {
          toolbarItems.remove(at: 2)
          self.setToolbarItems(toolbarItems, animated: false)
        }
      }
    }
  }
  
  @IBAction func showImagePickerForPhotoPicker(sender: UIBarButtonItem) {
    showImagePickerForSourceType(sourceType:.photoLibrary, fromButton: sender)
  }
  
  // MARK: - UIImagePickerControllerDelegate
  private func showImagePickerForSourceType(sourceType: UIImagePickerControllerSourceType, fromButton button:UIBarButtonItem) {
    if self.uploadImageView.isAnimating {
      self.uploadImageView.stopAnimating()
    }
    
    if self.capturedImages.count > 0 {
      self.capturedImages.removeAll()
    }
    
    let imagePickerController = UIImagePickerController()
    imagePickerController.modalPresentationStyle = .currentContext
    imagePickerController.sourceType = sourceType
    imagePickerController.delegate = self
    imagePickerController.modalPresentationStyle = (sourceType == .camera) ? .fullScreen : .popover
    
    if let presentationController = imagePickerController.popoverPresentationController {
      presentationController.barButtonItem = button
      presentationController.permittedArrowDirections = .any
    }
    
    self.imagePickerController = imagePickerController; // we need this for later
    self.present(imagePickerController, animated: true, completion: nil)
  }
  
  private func finishAndUpdate() {
    self.dismiss(animated: true, completion: nil)
    
    if self.capturedImages.count > 0 {
      self.uploadImageView.image = self.capturedImages[0]
    }
    self.capturedImages.removeAll()
    self.imagePickerController = nil
  }
  
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
    if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
      self.capturedImages.append(image)
    }
    self.finishAndUpdate()
  }
  
  func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
    self.dismiss(animated: true, completion: nil)
  }
  
  
  @IBAction func doneTapped(_ sender: UIBarButtonItem) {
    shareToFirebase()
  }
  
  func shareToFirebase() {
    let postRef = databaseReference.childByAutoId()
    let post = Post(key: postRef.key, comment: self.uploadDescriptionTextView.text, userID: (user?.uid)!)
    let dict = post.asDictionary
    
    postRef.setValue(dict) { (error, reference) in
      if let error = error {
        print(error)
      }
      else {
        print(reference)
        self.dismiss(animated: true, completion: nil)
      }
    }
  }
  
  
  
  
  
}
