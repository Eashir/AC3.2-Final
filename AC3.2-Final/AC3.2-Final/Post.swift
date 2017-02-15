//
//  Post.swift
//  AC3.2-Final
//
//  Created by Eashir Arafat on 2/15/17.
//  Copyright © 2017 C4Q. All rights reserved.
//

import Foundation

class Post {
  let key: String
  let comment: String
  let userID: String
  
  init(key: String, comment: String, userID: String) {
    self.key = key
    self.comment = comment
    self.userID = userID
  }
  
  var asDictionary: [String: String] {
    return ["userId": userID, "comment": comment]
  }
  
}
