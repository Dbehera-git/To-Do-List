//
//  ViewController.swift
//  ToDoListDev
//
//  Created by iOS Developer on 04/12/23.
//

import UIKit

class ViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {
   
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var tableView : UITableView = {
        let table = UITableView()
        table.register(UITableViewCell.self , forCellReuseIdentifier: "cell")
        return table
    }()
    
    private var models = [ToDoListItems]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "coreData ToDoList"
        view.addSubview(tableView)
        getallItems()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.frame = view.bounds
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, 
                                                            target: self,
                                                            action: #selector(didTapAdd))
    }
    
    @objc private func didTapAdd() {
        
        let alert = UIAlertController(title: "New Item",
                                      message: "Enter new item",
                                      preferredStyle: .alert)
        
        alert.addTextField(configurationHandler: nil)
        alert.addAction(UIAlertAction(title: "Submit", 
                                      style: .cancel,
                                      handler: { [weak self] _ in
            guard let field = alert.textFields?.first,
                  let text = field.text, !text.isEmpty
            else {
                return
            }
            self?.creatItem(name: text)
        }))
        
        present(alert, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = models[indexPath.row].name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, 
                              animated: true)
        let item = models[indexPath.row]
        
        let sheet = UIAlertController(title: "Perform any one",
                                      message: "",
                                      preferredStyle: .actionSheet)
        sheet.addAction(UIAlertAction(title: "Cancel",
                                      style: .cancel,
                                      handler:  nil))
        sheet.addAction(UIAlertAction(title: "Edit", 
                                      style: .default,
                                      handler:  { _ in
            let alert = UIAlertController(title: "Edit Item",
                                          message: "Edit Your item",
                                          preferredStyle: .alert)
            
            alert.addTextField(configurationHandler: nil)
            alert.textFields?.first?.text = item.name
            alert.addAction(UIAlertAction(title: "Save", 
                                          style: .cancel,
                                          handler: {
                [weak self] _ in
                guard let field = alert.textFields?.first,
                      let newName = field.text, !newName.isEmpty
                else {
                    return
                }
                self?.updateItem(item: item, newName: newName)
            }))
            
            self.present(alert, animated: true)
        }))
        sheet.addAction(UIAlertAction(title: "Delete", 
                                      style: .destructive,
                                      handler:  { [weak self] _ in
            self?.deleteItem(item: item)
        }))
        
        present(sheet, animated: true)
        
    }
    
    
    // CoreData
    func getallItems() {
        do {
            models = try context.fetch(ToDoListItems.fetchRequest())
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        catch{
            
        }
    }
    
    func creatItem(name: String) {
        
        let newItem = ToDoListItems(context: context)
        newItem.name = name
        newItem.createdAt = Date()
        
        do{
            try context.save()
            getallItems()
        }
        catch{
            
        }
    }
        
        func deleteItem(item: ToDoListItems) {
            
            context.delete(item)
            do {
                try context.save()
                getallItems()
            }
            catch{
                
            }
        }
        
        func updateItem(item: ToDoListItems, newName: String) {
            item.name = newName
            
            do {
                try context.save()
                getallItems()
            }
            catch{
                
            }
        }
    }

