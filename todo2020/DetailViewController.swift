//
//  DetailViewController.swift
//  todo2020
//
//  Created by matsumoto keiji on 2020/06/24.
//  Copyright © 2020 keiziweb. All rights reserved.
//

import UIKit
import RealmSwift

class DetailViewController: UIViewController {
	var masterVC:MasterViewController? = nil
	
	@IBOutlet var tfTitle: UITextField!
	@IBOutlet var tfDescription: UITextField!
	
	//Masterから受け取ったデータを画面に表示する
	func configureView() {
        // Update the user interface for the detail item.
        if let detail = detailItem {
            if let title = tfTitle {
                title.text = detail.title
            }
            if let description = tfDescription {
				description.text = detail.contents
            }
        }
		
	}

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        configureView()
    }

    //閉じるときの処理
    override func viewDidDisappear(_ animated: Bool) {
        //DBに保存する
        if let detailItemU = detailItem , let masterVCU = masterVC {
			let realm = try! Realm()
			try! realm.write {
				detailItemU.title = tfTitle.text ?? ""
				detailItemU.contents = tfDescription.text ?? ""
				masterVCU.reloadTable()
			}
        }
        super.viewDidDisappear(animated)
    }
	
	var detailItem: TodoModel? {
		didSet {
		    // Update the view.
		    configureView()
		}
	}


}

