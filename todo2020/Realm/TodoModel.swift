//
//  TodoModel.swift
//  todo2020
//
//  Created by matsumoto keiji on 2020/08/22.
//  Copyright © 2020 keiziweb. All rights reserved.
//

import Foundation
import RealmSwift

class TodoModel:Object {
	@objc dynamic var title = ""
	@objc dynamic var description = ""
	var priority:Int = 0
	var create_date:Date! = nil
	
	
}



