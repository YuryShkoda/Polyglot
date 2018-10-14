//
//  ViewController.swift
//  Polyglot
//
//  Created by Yury on 10/14/18.
//  Copyright © 2018 Yury Shkoda. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    
    var words = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let titleAttributes = [NSAttributedString.Key.font: UIFont(name: "AmericanTypewriter", size: 22)!]
        navigationController?.navigationBar.titleTextAttributes = titleAttributes
        title = "POLYGLOT"
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewWords))
        
        let defaults = UserDefaults.standard
        
        if let savedWords = defaults.object(forKey: "Words") as? [String] {
            words = savedWords
        } else {
            saveInitialValues(to: defaults)
        }
    }
    
    func saveInitialValues(to defaults: UserDefaults) {
        words.append("bear::медведь")
        words.append("camel::верблюд")
        words.append("cow::корова")
        words.append("fox::лиса")
        words.append("goat::козел")
        words.append("monkey::обезьяна")
        words.append("pig::свинья")
        words.append("rabbit::кролик")
        words.append("sheep::овца")
        
        defaults.set(words, forKey: "Words")
    }
    
    func saveWords() {
        let defaults = UserDefaults.standard
        defaults.set(words, forKey: "Words")
    }
    
    @objc func addNewWords() {
        let ac = UIAlertController(title: "Add new word", message: nil, preferredStyle: .alert)
        ac.addTextField { textField in
            textField.placeholder = "English"
        }
        ac.addTextField { textField in
            textField.placeholder = "Russian"
        }
        
        let submitAction = UIAlertAction(title: "Add Word", style: .default) { [unowned self, ac] (action: UIAlertAction!) in
            let firstWord  = ac.textFields?[0].text ?? ""
            let secondWord = ac.textFields?[1].text ?? ""
            
            self.insertFlashcard(first: firstWord, second: secondWord)
        }
        
        ac.addAction(submitAction)
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        present(ac, animated: true)
    }
    
    func insertFlashcard(first: String, second: String) {
        guard first.count > 0 && second.count > 0 else { return }
        
        let newIndexPath = IndexPath(row: words.count, section: 0)
        
        words.append("\(first)::\(second)")
        tableView.insertRows(at: [newIndexPath], with: .automatic)
        
        saveWords()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return words.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell  = tableView.dequeueReusableCell(withIdentifier: "Word", for: indexPath)
        let word  = words[indexPath.row]
        let split = word.components(separatedBy: "::")
        
        cell.textLabel?.text = split[0]
        cell.detailTextLabel?.text = ""
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if let cell = tableView.cellForRow(at: indexPath) {
            if cell.detailTextLabel?.text == "" {
                let word  = words[indexPath.row]
                let split = word.components(separatedBy: "::")
                
                cell.detailTextLabel?.text = split[1]
            } else {
                cell.detailTextLabel?.text = ""
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        words.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
        saveWords()
    }
}
