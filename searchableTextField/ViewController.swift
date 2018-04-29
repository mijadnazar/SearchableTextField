//
//  ViewController.swift
//  searchableTextField
//
//  Created by mobile mac mini on 4/17/18.
//  Copyright © 2018 Mehdi Company. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var tableViewEqualWidthConstraint: NSLayoutConstraint!

    let originalDatasource = ["Iran", "Turkey", "Australia", "United States", "Canada", "France", "United Kingdom", "Germany"]
    var datasource: [String]?

    var tableViewOriginalSize : CGSize?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

//        self.hideKeyboardWhenTappedAround()
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.textField.delegate = self

        self.datasource = originalDatasource

        self.tableView.layer.borderColor = UIColor.blue.cgColor
        self.tableView.layer.borderWidth = 1
        self.addTapGestureToTableView()

        self.tableView.reloadData()
    }

    override func viewWillAppear(_ animated: Bool) {
        self.tableViewOriginalSize = CGSize(width: self.tableView.frame.size.width, height: self.tableView.frame.size.height)
    }

    override func viewDidAppear(_ animated: Bool) {
        self.hideTableView()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.datasource!.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! Cell

        cell.nameLabel.text = self.datasource?[indexPath.row]

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        self.showTableView()

        return true
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {

    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text?.lowercased()
        var newText = ""
        if string.isEmpty {
            // User pressed the backspace button
            newText = (currentText?.substring(to: (currentText?.index(before: (currentText?.endIndex)!))!))!
        }else {
            newText = currentText! + string.lowercased()
        }

        self.searchFor(newText)

        return true
    }

    func searchFor(_ text:String) {
        var resultItems = [String]()

        if text.isEmpty{
            resultItems = self.originalDatasource
        }else {
            for item in self.originalDatasource {
                if item.lowercased().contains(text) {
                    resultItems.append(item)
                }
            }
        }

        self.datasource = resultItems
        self.tableView.reloadData()
    }

    func addTapGestureToTableView() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(hideTableView))
        self.view.addGestureRecognizer(tap)
    }

    @objc func hideTableView() {
        self.view.endEditing(true)
        if self.tableView.frame.origin.y > self.textField.frame.origin.y {
            UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseOut, animations: {
                self.tableView.frame.origin.y = self.textField.frame.origin.y + self.textField.frame.size.height - self.tableView.frame.size.height
            }, completion: { (true) in
                self.tableView.isHidden = true
            })
        }
    }

    func showTableView() {
        if self.tableView.frame.origin.y < self.textField.frame.origin.y {
            UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseInOut, animations: {
                self.tableView.frame.origin.y = self.textField.frame.origin.y + self.textField.frame.size.height
                self.tableView.isHidden = false
            }, completion: nil)
        }
    }
}

