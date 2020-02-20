//
//  BMTableVC.swift
//  BookmarkApp
//
//  Created by 장창순 on 11/02/2020.
//  Copyright © 2020 AnAppPerTwoWeeks. All rights reserved.
//

import UIKit

class BookmarkTableViewController: UITableViewController {
    
    var bookmarkModel = BookmarkModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "북마크"
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bookmarkModel.count
    }

    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let removeCell = UIContextualAction(style: .destructive, title: "삭제") { (UIContextualAction, UIView, (Bool) -> Void) in
            self.bookmarkModel.removeBookmarkByIndex(indexPath.row)
            self.tableView.reloadData()
        }
        
        let editCell = UIContextualAction(style: .normal, title: "편집") { (UIContextualAction, UIView, (Bool) -> Void) in
            self.performSegue("editSegue", indexPath.row)
        }
        
        let swipeAction = UISwipeActionsConfiguration(actions: [removeCell, editCell])
        swipeAction.performsFirstActionWithFullSwipe = false
        
        return swipeAction
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var bookmarkCell = BookmarkCell()
        if let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? BookmarkCell {
            bookmarkCell = cell
        }
        bookmarkCell.update(bookmarkModel.getBookmarkAt(indexPath.row))
        
        return bookmarkCell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        UIPasteboard.general.string = bookmarkModel.getBookmarkAt(indexPath.row).getBookmarkURL()
        
        let alert = UIAlertController(title: nil, message: "URL이 복사 되었습니다.", preferredStyle: .alert)
        present(alert, animated:true)
      
        Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { (timer) in
            self.dismiss(animated: true, completion: nil)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var nameTextfield = UITextField()
        var urlTextfield = UITextField()
        
        let alert = UIAlertController(title: "북마크 추가", message: nil, preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "취소", style: .destructive) { (action) in
        }
        
        let addAction = UIAlertAction(title: "저장", style: .default) { (action) in
            if (nameTextfield.text != "") && (urlTextfield.text != "") {
                if let name = nameTextfield.text , let url = urlTextfield.text {
                    self.bookmarkModel.addBookmark(name, url: url)
                    self.tableView.reloadData()
                }
            } else {
                let notice = UIAlertController(title: nil, message: "모든 텍스트 필드를 입력해주세요.", preferredStyle: .alert)
                self.present(notice, animated:true)
                
                  Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { (timer) in
                    self.dismiss(animated: true, completion: nil)
                    self.present(alert, animated:true)
                }
            }
        }
  
        alert.addTextField { (alertNameTextfield) in
            alertNameTextfield.placeholder = "북마크 이름을 입력해 주세요."
            nameTextfield = alertNameTextfield
        }
        
        alert.addTextField { (alertURLTextfield) in
            alertURLTextfield.placeholder = "URL을 입력해 주세요."
            if let copiedText = UIPasteboard.general.string {
            alertURLTextfield.text = copiedText
            }
            urlTextfield = alertURLTextfield
        }
        
        alert.addAction(cancelAction)
        alert.addAction(addAction)
        
        present(alert, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editSegue" {
            if let editCell = segue.destination as? BookmarkEditViewController {
                if let index = sender as? Int {
                    let indexPath = index
                    editCell.setBookmarkModel(bookmarkModel)
                    editCell.setIndexpath(indexPath)
                }
            }
        }
    }
}
