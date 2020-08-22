//
//  RecordSet.swift
//  DBTest
//
//  Created by matsumoto keiji on 2017/07/25.
//  Copyright © 2017年 matsumoto keiji. All rights reserved.
//

import Foundation
import FMDB

protocol RecordSet {
	// インターフェースの定義
	func toRecordSet(result:FMResultSet)
}
