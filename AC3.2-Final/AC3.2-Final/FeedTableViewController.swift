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

class FeedTableViewController: UITableViewController {
  
  var databaseReference: FIRDatabaseReference!
  //  var users = [User]()
  var posts = [Post]()
  override func viewDidLoad() {
    super.viewDidLoad()
    self.databaseReference = FIRDatabase.database().reference().child("posts")
    getPosts()
  }
  
  
  
  func getPosts() {
    databaseReference.observeSingleEvent(of: .value, with: { (snapshot) in
      for child in snapshot.children {
        dump(child)
        if let snap = child as? FIRDataSnapshot,
          let valueDict = snap.value as? [String:String] {
          let post = Post(key: snap.key, comment: valueDict["comment"] ?? "", userID: valueDict["userId"] ?? "")
//          let post = Post(key: snap.key,
//                          comment: valueDict["comment"] ?? "",
//                          userID: valueDict["userId"] ?? "")
          self.posts.append(post)
        }
      }
      self.tableView.reloadData()
    })
  }
  
  // MARK: - Table view data source
  
  override func numberOfSections(in tableView: UITableView) -> Int {
    // #warning Incomplete implementation, return the number of sections
    return 1
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    // #warning Incomplete implementation, return the number of rows
    return posts.count
  }
  
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "feedCell", for: indexPath) as! FeedTableViewCell
    
//    let post = posts[indexPath.row]
    // Configure the cell...
    cell.feedCommentLabel.text = posts[indexPath.row].comment
    
    
    return cell
  }
  
  
  /*
   // Override to support conditional editing of the table view.
   override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
   // Return false if you do not want the specified item to be editable.
   return true
   }
   */
  
  /*
   // Override to support editing the table view.
   override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
   if editingStyle == .delete {
   // Delete the row from the data source
   tableView.deleteRows(at: [indexPath], with: .fade)
   } else if editingStyle == .insert {
   // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
   }
   }
   */
  
  /*
   // Override to support rearranging the table view.
   override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
   
   }
   */
  
  /*
   // Override to support conditional rearranging of the table view.
   override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
   // Return false if you do not want the item to be re-orderable.
   return true
   }
   */
  
  /*
   // MARK: - Navigation
   
   // In a storyboard-based application, you will often want to do a little preparation before navigation
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
   // Get the new view controller using segue.destinationViewController.
   // Pass the selected object to the new view controller.
   }
   */
  
}
