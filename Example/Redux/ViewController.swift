//
//  ViewController.swift
//  Redux
//
//  Created by Steven-Chan on 01/04/2016.
//  Copyright (c) 2016 Steven-Chan. All rights reserved.
//

import UIKit
import Redux

class ViewController: UIViewController, StoreDelegate {

    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var tableView: UITableView!

    let dateFormatter = NSDateFormatter()

    var todoListData: [TodoListItem] = [TodoListItem]() {
        didSet {
            self.tableView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        dateFormatter.dateStyle = NSDateFormatterStyle.LongStyle
        dateFormatter.timeStyle = .MediumStyle
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.connect(
            Store.appStore,
            keys: [ kAppStateKeyTodoList ],
            delegate: self
        )

        TodoListActionCreators.load(
            Store.appStore.dispatch,
            userDefaults: NSUserDefaults.standardUserDefaults()
        )
    }

    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        self.disconnect(Store.appStore)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func enterDidPress(sender: UIButton) {
        TodoListActionCreators.add(
            textField.text!,
            dispatch: Store.appStore.dispatch,
            userDefaults: NSUserDefaults.standardUserDefaults()
        )
        textField.text = ""
    }

    func storeDidUpdateState(lastState: ReduxAppState) {
        let lastTodoListState =
            lastState.get(kAppStateKeyTodoList) as! TodoListState

        if Store.appStore.getTodoListState()!.list != lastTodoListState.list {
            self.todoListData = Store.appStore.getTodoListState()!.list
        }
    }

}

extension ViewController: UITableViewDataSource {

    internal func tableView(
        tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        return self.todoListData.count
    }

    internal func tableView(
        tableView: UITableView,
        cellForRowAtIndexPath indexPath: NSIndexPath
    ) -> UITableViewCell {
        let cell = UITableViewCell(
            style: UITableViewCellStyle.Subtitle,
            reuseIdentifier: "TodoListItem.cell"
        )

        let item: TodoListItem? = self.todoListData[indexPath.row]

        cell.textLabel?.text = item!.content
        cell.detailTextLabel?.text =
            dateFormatter.stringFromDate(item!.createdAt!)

        return cell
    }

}
