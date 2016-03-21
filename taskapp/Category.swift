//
//  Category.swift
//  taskapp
//
//  Created by 椎葉寛子 on 2016/03/19.
//  Copyright © 2016年 shiiba. All rights reserved.
//

import UIKit
import RealmSwift

class Category: Object {
    
    //管理用ID。プライマリーキー
    dynamic var id2 = 0
    
    //タイトル
    dynamic var name = ""
    
    /**
     idをプライマリーキーとして設定
     */
    override static func primaryKey() -> String? {
        return "id2"

}
}
