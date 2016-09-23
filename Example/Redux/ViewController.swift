//
//  ViewController.swift
//  Redux
//
//  Created by Steven-Chan on 01/04/2016.
//  Copyright (c) 2016 Oursky Limited. All rights reserved.
//

import UIKit
import Redux

class ViewController: UIViewController, StoreDelegate {

    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var tableView: UITableView!

    let dateFormatter = DateFormatter()

    var todoListData: [TodoListItem] = [TodoListItem]() {
        didSet {
            self.tableView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        dateFormatter.dateStyle = DateFormatter.Style.long
        dateFormatter.timeStyle = .medium
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.connect(
            Store.appStore,
            keys: [ kAppStateKeyTodoList ],
            delegate: self
        )

        TodoListActionCreators.load(
            Store.appStore.dispatch,
            userDefaults: UserDefaults.standard
        )
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.disconnect(Store.appStore)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func enterDidPress(_ sender: UIButton) {
        TodoListActionCreators.add(
            textField.text!,
            dispatch: Store.appStore.dispatch,
            userDefaults: UserDefaults.standard
        )
        textField.text = ""
    }

    func storeDidUpdateState(_ lastState: ReduxAppState) {
        let lastTodoListState =
            lastState.get(kAppStateKeyTodoList) as! TodoListState

        if Store.appStore.getTodoListState()!.list != lastTodoListState.list {
            self.todoListData = Store.appStore.getTodoListState()!.list
        }
    }

}

extension ViewController: UITableViewDataSource {

    internal func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        return self.todoListData.count
    }

    internal func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        let cell = UITableViewCell(
            style: UITableViewCellStyle.subtitle,
            reuseIdentifier: "TodoListItem.cell"
        )

        let item: TodoListItem? = self.todoListData[(indexPath as NSIndexPath).row]

        cell.textLabel?.text = item!.content
        cell.detailTextLabel?.text =
            dateFormatter.string(from: item!.createdAt! as Date)

        return cell
    }

}
