//
//  DetailViewController.swift
//  todo2020
//
//  Created by matsumoto keiji on 2020/06/24.
//  Copyright © 2020 keiziweb. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
	var masterVC:MasterViewController? = nil
	
	@IBOutlet var tfTitle: UITextField!
	@IBOutlet var tfDescription: UITextField!
	

	func configureView() {
        // Update the user interface for the detail item.
        if let detail = detailItem {
            if let title = tfTitle {
                title.text = detail.title
            }
            if let description = tfDescription {
                description.text = detail.description
            }
        }
		
	}

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        configureView()
    }

    
    override func viewDidDisappear(_ animated: Bool) {
        //DBに保存する DBManagerを使う場合はコメントアウトを取る
/*        if let detailItemU = detailItem , let masterVCU = masterVC {
            detailItemU.title = tfTitle.text
            detailItemU.description = tfDescription.text
            masterVCU.reloadTable()
            
            if(masterVCU.dbm.execUpdateSQL(sql: String(format: "update todo set title = '%@',description= '%@',priority = %d where id = %d;", DBManager.normalizeSQL(detailItemU.title),DBManager.normalizeSQL(detailItemU.description),detailItemU.priority,detailItemU.id))) {
                UIUtility.showAlertWithOK(vc: masterVCU, title: "確認", message: "保存しました",handler: nil)
            }
        }*/


        super.viewDidDisappear(animated)
    }
	
	var detailItem: todo_RS? {
		didSet {
		    // Update the view.
		    configureView()
		}
	}


}

