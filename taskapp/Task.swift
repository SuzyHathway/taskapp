//
//  Task.swift
//  taskapp
//
//  Created by 椎葉寛子 on 2016/03/16.
//  Copyright © 2016年 shiiba. All rights reserved.
//

import UIKit
import RealmSwift

class Task: Object {
    
    //管理用ID。プライマリーキー
    dynamic var id = 0
    
    //タイトル
    dynamic var title = ""
    
    //カテゴリー
    dynamic var category : String = String() 
    
    //内容
    dynamic var contents = ""
    
    //日時
    dynamic var date = NSDate()
    
    /**
    idをプライマリーキーとして設定
    */
    override static func primaryKey() -> String? {
        return "id"
}
}
