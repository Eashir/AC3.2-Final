//
//  FeedTableViewController.swift
//  AC3.2-Final
//
//  Created by Eashir Arafat on 2/15/17.
//  Copyright © 2017 C4Q. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseStorage
import FirebaseAuth

class FeedTableViewController: UITableViewController {
  
  var storage = FIRStorageReference()
  var databaseReference: FIRDatabaseReference!
  var posts = [Post]()
  var user: FIRUser?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.databaseReference = FIRDatabase.database().reference().child("posts")
    getPosts()
    storage = FIRStorage.storage().reference(forURL: "gs://ac-32-final.appspot.com")
    
    tableView.estimatedRowHeight = 500
    tableView.rowHeight = UITableViewAutomaticDimension
  }
  
  
  
  func getPosts() {
    databaseReference.observeSingleEvent(of: .value, with: { (snapshot) in
      for child in snapshot.children {
        dump(child)
        if let snap = child as? FIRDataSnapshot,
          let valueDict = snap.value as? [String:String] {
          let post = Post(key: snap.key, comment: valueDict["comment"] ?? "", userID: valueDict["userId"] ?? "")
          self.posts.append(post)
        }
      }
      self.tableView.reloadData()
    })
  }
  
  // MARK: - Table view data source
  
  override func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return posts.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "feedCell", for: indexPath) as! FeedTableViewCell
    
    let post = posts[indexPath.row]
    let storageRef = FIRStorage.storage().reference().child("images/\(post.key)")

    cell.feedCommentLabel.text = post.comment
    cell.feedImageView.image = #imageLiteral(resourceName: "placeholder-square")
    
    storageRef.data(withMaxSize: 1 * 512 * 512) { data, error in
      if let error = error {
        print("ERROR WITH STORAGE")
      } else {
        let image = UIImage(data: data!)
        cell.feedImageView.image = image
      }
    }
    
    return cell
  }
}
