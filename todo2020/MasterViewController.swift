//
//  MasterViewController.swift
//  todo2020
//
//  Created by matsumoto keiji on 2020/06/24.
//  Copyright © 2020 keiziweb. All rights reserved.
//

import UIKit
import RealmSwift

class MasterViewController: UITableViewController {

	var _detailViewController: DetailViewController? = nil

	//TodoModel
	private var _todoModels:Results<TodoModel>!
	private var _token:NotificationToken!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view.
		navigationItem.leftBarButtonItem = editButtonItem

		let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(insertNewObject(_:)))
		navigationItem.rightBarButtonItem = addButton
		if let split = splitViewController {
		    let controllers = split.viewControllers
		    _detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
		}
		
		let _realm = try! Realm()
		_todoModels = _realm.objects(TodoModel.self) //読み込みみたいなもん
		_token = _todoModels.observe {[weak self] _ in　//データ更新通知を設定
			self?.reloadTable()//めんどくさいのでテーブルビューをリロードしちゃう
		}
	}
	
	deinit {
		_token.invalidate()
	}

	override func viewWillAppear(_ animated: Bool) {
		clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
		super.viewWillAppear(animated)
	}

	//右上の＋ボタンで項目追加
	@objc
	func insertNewObject(_ sender: Any) {
		let newTodo = TodoModel()
		newTodo.title = "New TODO"
		newTodo.contents = "new description"
		newTodo.create_date = Date()
		
		let realm = try! Realm()
		try! realm.write {
			realm.add(newTodo)
		}
	}

	//リロード
    func reloadTable() {
        self.tableView.reloadData()
    }
	
	// MARK: - Segues
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
				
                let object = _todoModels[indexPath.row]
                let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
                controller.detailItem = object
                controller.masterVC = self
                controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
	}

	// MARK: - Table View

	override func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}

	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return _todoModels.count
	}

	//表示
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
		let todo = _todoModels[indexPath.row]
        cell.textLabel!.text = todo.title
		return cell
	}

	override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
		// Return false if you do not want the specified item to be editable.
		return true
	}

	//テーブル更新
	override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
		if editingStyle == .delete {
			//削除
			let realm = try! Realm()
			try! realm.write {
				realm.delete(_todoModels[indexPath.row])
			}
			
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
		
	}


}

