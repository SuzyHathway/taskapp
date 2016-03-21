//
//  CategoryInputViewController.swift
//  taskapp
//
//  Created by 椎葉寛子 on 2016/03/19.
//  Copyright © 2016年 shiiba. All rights reserved.
//

import UIKit
import RealmSwift

//タスク編集・作成画面
class CategoryInputViewController: UIViewController {
    
    @IBOutlet weak var textField: UITextField!
    
    //realmを使う時に必須記述
    let realm = try! Realm()
    
    //Taskクラスのインスタンス。新規追加されるたび増える
    var category:Category!
    var task:Task!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 背景をタップしたらdismissKeyboardメソッドを呼ぶように設定する
        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target:self, action:"dismissKeyboard")
        self.view.addGestureRecognizer(tapGesture)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //タスク一覧画面に戻るときに、UIに入力した値をデータベースに保存する

    @IBAction func save(sender: UIButton) {
    
        // ここで同名のCategoryが既に存在してるかどうかをチェック
        let check = realm.objects(Category).filter("name = '\(textField.text!)'")
        if check.count != 0 {
            
            // 既に同じ名前のカテゴリーがある
            // エラー表示？　そのまま終了で良い？
            textField.text = ""
            textField.placeholder = "すでに登録済みのカテゴリーです！"
            return
        }
        
        try! realm.write {
            
            //カテゴリーの保存
            self.category.name = self.textField.text!
            self.realm.add(self.category, update: true)
            
            //タスクの保存
            //self.task.category = self.textField.text!
            //self.realm.add(self.task, update: true)
        }
        
            //テキストフィールドを空にする
            textField.text = ""
        
            self.navigationController?.popViewControllerAnimated(true)
    }

    
    func dismissKeyboard() {
        // キーボードを閉じる
        view.endEditing(true)
    }
}
