//
//  PostTableViewCell.swift
//  Instagram
//
//  Created by 牧野達也 on 2023/01/28.
//

import UIKit
import FirebaseStorageUI

class PostTableViewCell: UITableViewCell {


    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var likeLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var captionLabel: UILabel!
    
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var CommentButton: UIButton!
        
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    // PostDataの内容をセルに表示
    func setPostData(_ postData: PostData) {
        // 画像の表示
        postImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
        let imageRef = Storage.storage().reference().child(Const.ImagePath).child(postData.id + ".jpeg")
        print("DEBUG: \(imageRef)")
        postImageView.sd_setImage(with: imageRef)
        
        // キャプションの表示
        self.captionLabel.text = "\(postData.name!) : \(postData.caption!)"
        
        // 日時の表示
        self.dateLabel.text = ""
        if let date = postData.date {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm"
            let dateString = formatter.string(from: date)
            self.dateLabel.text = dateString
        }
        
        // いいね数の表示
        let likeNumber = postData.likes.count
        likeLabel.text = "\(likeNumber)"
        
        // いいねボタンの表示
        if postData.isLiked {
            let buttonImage = UIImage(named: "Like_exist")
            self.likeButton.setImage(buttonImage, for: .normal)
        } else {
            let buttonImage = UIImage(named: "Like_none")
            self.likeButton.setImage(buttonImage, for: .normal)
        }
                
        // コメントの表示
        print("DEBUG_PRINT: コメント表示＝\(postData.comment)")
        
        var comments: String = ""
        var commentators: String = ""
        var commentExist: Bool = false
        
        if postData.comment.count > 0 {
            commentExist = true
        }
        for (index,comment) in postData.comment.enumerated() {
            print("DEBUG_PRINT: コメント内容＝\(comment)")
            comments += "\(comment)"
            print("DEBUG_PRINT: コメントテーターカウント＝\(postData.commentatorName.count)")

            if postData.commentatorName.count > index {
                print("DEBUG_PRINT: コメンテーター＝\(postData.commentatorName[index])")
                let commentator: String = postData.commentatorName[index]
                comments += " by \(commentator)\n"
            }
        }
        if commentExist {
            self.commentLabel.text = comments
        } else {
            self.commentLabel.text = ""
        }
            
        
    }
    
}
