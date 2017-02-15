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
  //  var users = [User]()
  var posts = [Post]()
  var user: FIRUser?
  var imageURLs: [String]?
  var task: URLSessionDownloadTask!
  var session: URLSession!
  var cache:NSCache<AnyObject, AnyObject>!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.databaseReference = FIRDatabase.database().reference().child("posts")
    getPosts()
    storage = FIRStorage.storage().reference(forURL: "gs://ac-32-final.appspot.com")
    getURLSForAllImages()
    
    tableView.estimatedRowHeight = 500
    tableView.rowHeight = UITableViewAutomaticDimension
    
    //Cache
    session = URLSession.shared
    task = URLSessionDownloadTask()
    self.cache = NSCache()
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
  
  func getURLSForAllImages() {
//    guard let validUser = user else { return }
//    storage.child("images").downloadURL(completion: { (URL?, error:Error?) in
//    
//    })
//      
//    
//    storage.child(validUser.uid).child("images").observe(.value, with: { (snapShot) in
//      for child in snapShot.children.allObjects {
//        if let child = child as? FIRDataSnapshot,
//          let urlString = child.value as? String ,
//          let valdImageURLs = self.imageURLs {
//          if valdImageURLs.contains(urlString) == false {
//            self.imageURLs?.append(urlString)
//          }
//        }
//      }
//      self.tableView.reloadData()
//    })
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
        // Uh-oh, an error occurred!
      } else {
        // Data for "images/island.jpg" is returned
        let image = UIImage(data: data!)
        cell.feedImageView.image = image
      }
    }
    
//    if (self.cache.object(forKey: (indexPath as NSIndexPath).row as AnyObject) != nil){
//      cell.feedImageView?.image = self.cache.object(forKey: (indexPath as NSIndexPath).row as AnyObject) as? UIImage
//    } else {
//      guard let validImageURL = imageURLs?[indexPath.row] else {
//        return cell
//      }
//      let url:URL! = URL(string: validImageURL)
//      task = session.downloadTask(with: url, completionHandler: { (locationURL, response, error) -> Void in
//        if let data = try? Data(contentsOf: url){
//          DispatchQueue.main.async(execute: { () -> Void in
//            if let updateCell = tableView.cellForRow(at: indexPath) as? FeedTableViewCell {
//              let img:UIImage! = UIImage(data: data)
//              updateCell.feedImageView?.image = img
//              self.cache.setObject(img, forKey: (indexPath as NSIndexPath).row as AnyObject)
//            }
//          })
//        }
//      })
//      task.resume()
//    }
    
    return cell
  }
}
