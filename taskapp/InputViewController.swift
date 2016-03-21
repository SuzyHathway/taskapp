//
//  InputViewController.swift
//  taskapp
//
//  Created by 椎葉寛子 on 2016/03/16.
//  Copyright © 2016年 shiiba. All rights reserved.
//

import UIKit
import RealmSwift

//タスク編集・作成画面
class InputViewController:UIViewController, UIPickerViewDelegate,UIPickerViewDataSource {

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var categoryPickerView: UIPickerView!
    @IBOutlet weak var categoryTextField: UITextField!
    @IBOutlet weak var contentsTextView: UITextView!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    //realmを使う時に必須記述
    let realm = try! Realm()
    
    //Taskクラスのインスタンス。新規追加されるたび増える
    var task:Task!
    
    //DB内のカテゴリーが格納されるリスト
    let categoryArray = try! Realm().objects(Category)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //カテゴリーピッカーの初期値
        categoryPickerView.selectRow(0, inComponent: 0, animated: false)
        
        // 背景をタップしたらdismissKeyboardメソッドを呼ぶように設定する
        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target:self, action:"dismissKeyboard")
        self.view.addGestureRecognizer(tapGesture)
 
        
        //タスク一覧画面から遷移してきたときに受け取ったタスク情報をUIに反映させる
        titleTextField.text = task.title
        categoryTextField.text = task.category
        contentsTextView.text = task.contents
        datePicker.date = task.date
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //カテゴリー入力画面から戻ってきた時にTableViewを更新させる
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        categoryPickerView.reloadAllComponents()
        
    }
    
    //タスク一覧画面に戻るときに、UIに入力した値をデータベースに保存する
    @IBAction func save(sender: UIButton) {
        try! realm.write {
            self.task.title = self.titleTextField.text!
            self.task.category = categoryTextField.text!
            self.task.contents = self.contentsTextView.text
            self.task.date = self.datePicker.date
            self.realm.add(self.task, update: true)
        }
        
        //データベースにタスクを保存するタイミングでローカル通知の設定を合わせて行う
        setNotification(task)
        self.navigationController?.popViewControllerAnimated(true)
        
    }
    
    //override func viewDidDisappear(animated: Bool) {
        //super.viewWillDisappear(animated)
    //}

    func dismissKeyboard() {
        // キーボードを閉じる
        view.endEditing(true)
    }
    
    //タスクのローカル通知を設定する
    func setNotification(task: Task){
    
    //すでに同じタスクが登録されていたらキャンセルする
    for notification in UIApplication.sharedApplication().scheduledLocalNotifications! {
    if notification.userInfo!["id"] as! Int == task.id {
    UIApplication.sharedApplication().cancelLocalNotification(notification)
    break //breakに来るとforループから抜け出す
    
    }
    
    }
        let notification = UILocalNotification()
        
        notification.fireDate = task.date
        notification.timeZone = NSTimeZone.defaultTimeZone()
        notification.alertBody = "\(task.title)"
        notification.soundName = UILocalNotificationDefaultSoundName
        notification.userInfo = ["id": task.id]
        UIApplication.sharedApplication().scheduleLocalNotification(notification)
}
    
    
    //カテゴリー用のデータピッカーを設定する
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return categoryArray.count
    }
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return categoryArray[row].name
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        categoryTextField.text = categoryArray[row].name
    }
    
    // segue で画面遷移するに呼ばれる
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?){
        let cateViewController:CategoryInputViewController = segue.destinationViewController as! CategoryInputViewController
        
            let category = Category()
        
            if categoryArray.count != 0 {
               category.id2 = categoryArray.max("id2")! + 1
        }
            cateViewController.category = category
            cateViewController.task = task
        }
}