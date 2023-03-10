//
//  PostData.swift
//  Instagram
//
//  Created by 牧野達也 on 2023/01/28.
//

import UIKit
import Firebase

class PostData: NSObject {
    var id: String
    var name: String?
    var caption: String?
    var date: Date?
    var likes: [String] = []
    var isLiked: Bool = false
// 課題対応
    var comment:[String] = []
    var commentatorName:[String] = []
    
    init(document: QueryDocumentSnapshot) {
        self.id = document.documentID

        let postDic = document.data()

        self.name = postDic["name"] as? String
        self.caption = postDic["caption"] as? String

        let timestamp = postDic["date"] as? Timestamp
        self.date = timestamp?.dateValue()
        
        if let likes = postDic["likes"] as? [String]{
            self.likes = likes
        }
        
        if let myid = Auth.auth().currentUser?.uid {
            // likesの配列の中にmyidが含まれていないかチェックすることで自分がいいねを押しているかを判断
            if self.likes.firstIndex(of: myid) != nil {
                // myidがあれば自分がいいねを押していると判断する
                self.isLiked = true
            }
        }
        if let comment = postDic["comment"] as? [String]{
            self.comment = comment
        }
        if let commentatorName = postDic["commentatorName"] as? [String]{
            self.commentatorName = commentatorName
        }

            
    }

}
