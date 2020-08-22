//
//  todo_RS.swift
//  todo2020
//
//  Created by matsumoto keiji on 2020/06/24.
//  Copyright © 2020 keiziweb. All rights reserved.
//

import Foundation
import FMDB

class todo_RS : RecordSet {
	var id:Int = -1
	var title:String! = nil
	var description:String! = nil
	var priority:Int = 0
	var create_date:Date! = nil

	init(_ title:String,_ description:String,_ priority:Int) {
		self.title = title
		self.description = description
		self.priority = priority
	}
	init() {
	}

	func toRecordSet(result:FMResultSet) {
		self.id = result.long(forColumnIndex: 0)
		self.title = DBManager.normalizeString(result.string(forColumnIndex:1))
		self.description = DBManager.normalizeString(result.string(forColumnIndex:2))
		self.priority = result.long(forColumnIndex:3)
		self.create_date = DBManager.stringToDate(format: "yyyy-MM-dd HH:mm:ss", strDate: result.string(forColumnIndex:4)!)
		
	}
	

}



