//
//  ViewController.swift
//  taskapp
//
//  Created by 椎葉寛子 on 2016/03/16.
//  Copyright © 2016年 shiiba. All rights reserved.
//

import UIKit
import RealmSwift

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    //Realmインスタンスを取得する
    let realm = try! Realm()
    
    //DB内のタスクが格納されるリスト
    //日付の近い順でソート//以降内容をアップデートするとリスト内は自動更新
    let taskArray = try! Realm().objects(Task).sorted("date", ascending: false)
    
    //検索の設定
    var searchActive : Bool = false
    var filtered: Results<Task>? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //入力画面から戻ってきた時にTableViewを更新させる
    override func viewDidAppear(animated: Bool) {
        searchBar.text = ""
        tableView.reloadData()
        view.endEditing(true)
        super.viewDidAppear(animated)
    }

    
    
    //サーチバーの設定
    //サーチバーに入力をはじめたらsearchActiveをtrueにする
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        searchActive = false
    }
    
    //サーチボタンのキャンセルをクリックしたらsearchActiveをfalseにする
    func searchBarCancelButtonClicked(searchBar: UISearchBar){
        searchActive = false
        searchBar.text = ""
        view.endEditing(true)
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchActive = true
        view.endEditing(true)
}
    
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        searchActive = false
        view.endEditing(true)
    }

    
    //サーチバーの検索で絞り込まれたものを表示
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        
        filtered = realm.objects(Task).filter("category = '\(searchBar.text!)'")

        if(filtered!.count != 0) {
            searchActive = true
        } else {
            searchActive = false
        }
        
        tableView.reloadData()
    }
    
    
    //テーブルのデータ数を返す
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchActive == true {
            return filtered!.count
        }else{
            return taskArray.count
        }
    }
    
    
    // 各セルの内容を返す
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        // 再利用可能な cell を得る
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        
        
        var task :Task?
        
        if searchActive == true {
            
            task = filtered![indexPath.row]
            
        }else{

            task = taskArray[indexPath.row]
        }
        
            cell.textLabel?.text = task!.title
        
            let formatter = NSDateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm"
        
            let dateString:String = formatter.stringFromDate(task!.date)
            cell.detailTextLabel?.text = dateString
    
            return cell

    }
    
    //UITableViewDelegateのメソッド
    //各セルを選択したときに実行されるメソッド
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier("cellSegue", sender: nil)
    }
    
    //どのような編集が可能かを伝えるメソッド
    func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        
        //セルが削除可能なことを伝える
        return UITableViewCellEditingStyle.Delete
    }
    
    //Deleteボタンが押された時に呼ばれるメソッド
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete {
            
            //ローカル通知をキャンセルする
            let task = taskArray[indexPath.row]
            
            for notification in UIApplication.sharedApplication().scheduledLocalNotifications! {
                if notification.userInfo!["id"] as! Int == task.id {
                    UIApplication.sharedApplication().cancelLocalNotification(notification)
                    break
                }
            }
            
            //データベースから削除する
            //try!を使ってエラーを無視
            try! realm.write {
                self.realm.delete(self.taskArray[indexPath.row])
                tableView.deleteRowsAtIndexPaths([indexPath],withRowAnimation: UITableViewRowAnimation.Fade)
            }
        }
    }
    
    // segue で画面遷移するに呼ばれる
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?){
        let inputViewController:InputViewController = segue.destinationViewController as! InputViewController
        
        if segue.identifier == "cellSegue" {
            let indexPath = self.tableView.indexPathForSelectedRow
            if searchActive != true {
            inputViewController.task = taskArray[indexPath!.row]
            }else{
            inputViewController.task = filtered![indexPath!.row]
            }
        } else {
            let task = Task()
            task.date = NSDate()
            
            if taskArray.count != 0 {
                task.id = taskArray.max("id")! + 1
            }
            
            inputViewController.task = task
        }
    }
}
