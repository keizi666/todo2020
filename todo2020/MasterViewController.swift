//
//  MasterViewController.swift
//  todo2020
//
//  Created by matsumoto keiji on 2020/06/24.
//  Copyright © 2020 keiziweb. All rights reserved.
//

import UIKit

class MasterViewController: UITableViewController {

	var detailViewController: DetailViewController? = nil
	var objects = [Any]()

	let dbm:DBManager = DBManager(dbFileName:"todo.db")

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view.
		navigationItem.leftBarButtonItem = editButtonItem

		let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(insertNewObject(_:)))
		navigationItem.rightBarButtonItem = addButton
		if let split = splitViewController {
		    let controllers = split.viewControllers
		    detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
		}
		
		if(dbm.isOK) {
			let results = dbm.execQuery(sql:"select * from todo order by id desc;")
			while results.next() {
				let rs = todo_RS()
				rs.toRecordSet(result:results)
				objects.append(rs)
			}
		}
	}

	override func viewWillAppear(_ animated: Bool) {
		clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
		super.viewWillAppear(animated)
	}

	@objc
	func insertNewObject(_ sender: Any) {
        let newTodo = todo_RS("New TODO","new description",0)
        objects.insert(newTodo, at: 0)
        let indexPath = IndexPath(row: 0, section: 0)
        tableView.insertRows(at: [indexPath], with: .automatic)
        
        //DBに追加する
        if(dbm.execUpdateSQL(sql:String(format:"insert into todo(title,description,priority) values('%@','%@',%d);",DBManager.normalizeSQL(newTodo.title),DBManager.normalizeSQL(newTodo.description),newTodo.priority))) {
            UIUtility.showAlertWithOK(vc: self, title: "確認", message: "TODOを追加しました",handler:nil)
            
            //今追加したレコードを読み込む（idを取得したいためにDBから読み直す）
            let results = dbm.execQuery(sql: "select * from todo order by id desc limit 1;")
            results.next()
            let rs = todo_RS()
            rs.toRecordSet(result: results)
            objects[0] = rs
            
        }
		
	}

    func reloadTable() {
        self.tableView.reloadData()
    }
	
	// MARK: - Segues

	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let object = objects[indexPath.row] as! todo_RS
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
		return objects.count
	}

	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let object = objects[indexPath.row] as! todo_RS
        cell.textLabel!.text = object.title
        return cell
	}

	override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
		// Return false if you do not want the specified item to be editable.
		return true
	}

	override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
		if editingStyle == .delete {
            let todoRS:todo_RS = objects[indexPath.row] as! todo_RS
            
            objects.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            
            //DBから削除する処理
            if(dbm.execUpdateSQL(sql: String(format: "delete from todo where id = %d;", todoRS.id))) {
                UIUtility.showAlertWithOK(vc: self, title: "確認", message: "削除しました", handler:nil)
            }
            
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
		
	}


}

