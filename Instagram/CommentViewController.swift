//
//  CommentViewController.swift
//  Instagram
//
//  Created by 牧野達也 on 2023/02/09.
//

import UIKit
import Firebase
import SVProgressHUD
import FirebaseStorageUI

class CommentViewController: UIViewController {


    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var caption: UILabel!
    @IBOutlet weak var displayName: UILabel!
    @IBOutlet weak var commentTextField: UITextField!
    var postData: PostData!
    
    
    @IBAction func handleCancelButton(_ sender: Any) {
        print("DEBUG_PRINT: コメント画面でキャンセル押下")
        // ホーム画面に戻る
        self.dismiss(animated: true, completion: nil)
    }
    

    @IBAction func handleCommentOnButton(_ sender: Any) {
        print("DEBUG_PRINT: コメント画面でコメントする押下")

/*
        print("postData.id= \(postData.id)")
        print("postData.name= \(postData.name)")
        print("postData.caption= \(postData.caption)")
*/
        var commentatorName:String = ""
        var comment: String
        var commentValue: FieldValue
        var commentatorNameValue: FieldValue
        
        // バリデーション
        if ((commentTextField.text?.isEmpty) == nil) {
            SVProgressHUD.showError(withStatus: "コメントを入力してください")
            return
        }
        
        comment = commentTextField.text!

        if postData.comment.contains(comment) {
            comment += "-" + String(postData.comment.count)
        }

        commentValue = FieldValue.arrayUnion([comment])
        
        // コメンテーターの表示名を取得
        let user = Auth.auth().currentUser
        if let user = user {
            commentatorName = user.displayName!
            if postData.commentatorName.contains(commentatorName) {
                commentatorName += "-" +  String(postData.commentatorName.count)
            }
        }
        commentatorNameValue = FieldValue.arrayUnion([commentatorName])

        // likesに更新データを書き込む
        let postRef = Firestore.firestore().collection(Const.PostPath).document(postData.id)
        postRef.updateData(["comment": commentValue])
        postRef.updateData(["commentatorName": commentatorNameValue])

        // 投稿処理が完了したので先頭画面に戻る
        self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 画像の表示
        postImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
        let imageRef = Storage.storage().reference().child(Const.ImagePath).child(postData.id + ".jpeg")
        print("DEBUG: \(imageRef)")
        postImageView.sd_setImage(with: imageRef)

        displayName.text = postData.name
        caption.text = postData.caption
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
