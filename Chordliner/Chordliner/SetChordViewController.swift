//
//  SetChordViewController.swift
//  Chordliner
//
//  Created on 2020/06/19.
//  Copyright © 2020 SotaIshino All rights reserved.
//

import UIKit

class SetChordViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate {
    
    //tableView
    @IBOutlet weak var tableView: UITableView!
    
    //pickerView
    var pickerView: UIPickerView!
    let pickerViewHeight: CGFloat = 200
    
    //pickerView上部のtoolbar
    var pickerToolbar: UIToolbar!
    let toolbarHeight: CGFloat = 40.0
    
    //pickerViewの選択肢
    let chordArray = ["end",
                      "rest",
                      "C",
                      "Cm",
                      "Cdim",
                      "Csus4",
                      "Ddim",
                      "Dsus4",
                      "E♭",
                      "E♭m",
                      "E♭sus2",
                      "F",
                      "Fm",
                      "G♭",
                      "G7",
                      "Gm",
                      "A♭",
                      "A♭m",
                      "Am",
                      "B♭",
                      "B♭dim",
                      "B♭sus4",
                      "B",
                      "Bm",
                      "Bdim"]

    //pickerViewに渡すIndexPath
    var pickerIndexPath: IndexPath!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let width = self.view.frame.width
        let height = self.view.frame.height
        
        //tableView
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(TableViewCell.self, forCellReuseIdentifier: "Cell")
        //cell入れ替え機能つけたかったよ。①
//        tableView.isEditing = true
//        tableView.allowsSelectionDuringEditing = true
        
        //pickerView
        pickerView = UIPickerView(frame:CGRect(x: 0, y: height + toolbarHeight, width: width, height: pickerViewHeight))
        pickerView.backgroundColor = UIColor.systemGroupedBackground
        pickerView.dataSource = self
        pickerView.delegate = self
        self.view.addSubview(pickerView)
        
        //pickerToolbar
        pickerToolbar = UIToolbar(frame:CGRect(x:0,y:height,width:width,height:toolbarHeight))
        let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let doneBtn = UIBarButtonItem(title: "完了", style: .plain, target: self, action: #selector(self.doneTapped))
         pickerToolbar.items = [flexible,doneBtn]
        self.view.addSubview(pickerToolbar)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //pickerViewのtoolbar「完了」タップ時
    @objc func doneTapped(){
        UIView.animate(withDuration: 0.2){
            self.pickerToolbar.frame = CGRect(x: 0, y: self.view.frame.height, width: self.view.frame.width, height: self.toolbarHeight)
            self.pickerView.frame = CGRect(x:0, y: self.view.frame.height + self.toolbarHeight, width: self.view.frame.width, height: self.pickerViewHeight)
            self.tableView.contentOffset.y = 0
        }
        self.tableView.deselectRow(at: pickerIndexPath, animated: true)
    }
    
    @IBAction func addTapped(_ sender: Any) {
        textArray.append("\(textArray.count + 1):")
        currentChordArray.append("end")
        
        tableView.reloadData()
    }
    
    @IBAction func deleteTapped(_ sender: Any) {
        let alert: UIAlertController = UIAlertController(title: "", message: "All delete?", preferredStyle:  UIAlertController.Style.actionSheet)
        
        //Delete選択時、textArrayを["1:"]のみに、currentChordArrayを["end"]のみに
        let DeleteAction: UIAlertAction = UIAlertAction(title: "Delete", style: UIAlertAction.Style.destructive, handler:{(action: UIAlertAction!) -> Void in
            textArray.removeAll()
            textArray.append("1:")
            
            currentChordArray.removeAll()
            currentChordArray.append("end")
            
            self.tableView.reloadData()
        })
        
        //Cancel選択時は何もしない
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler:{(action: UIAlertAction!) -> Void in
        })
        
        alert.addAction(DeleteAction)
        alert.addAction(cancelAction)

        present(alert, animated: true, completion: nil)
    }
    
    
    /* TableView */
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return textArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! TableViewCell
        cell.textLabel?.text = textArray[indexPath.row]
        
        //初期値
        cell.chordLabel.text = currentChordArray[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //pickerViewとcellがかぶる時はスクロール
        let cell = tableView.cellForRow(at: indexPath) as! TableViewCell
        let cellLimit: CGFloat = cell.frame.origin.y + cell.frame.height
        let pickerViewLimit: CGFloat = pickerViewHeight + toolbarHeight
        if cellLimit >= pickerViewLimit {
            UIView.animate(withDuration: 0.2) {
                tableView.contentOffset.y = cellLimit - pickerViewLimit
            }
        }
        
        pickerView.selectRow(0, inComponent: 0, animated: false)
        
        pickerIndexPath = indexPath
        
        //pickerViewを表示
        UIView.animate(withDuration: 0.2) {
            self.pickerToolbar.frame = CGRect(x: 0, y: self.view.frame.height - self.pickerViewHeight - self.toolbarHeight, width: self.view.frame.width, height: self.toolbarHeight)
            self.pickerView.frame = CGRect(x: 0, y: self.view.frame.height - self.pickerViewHeight, width: self.view.frame.width, height: self.pickerViewHeight)
        }
    }
    
    
    //cell入れ替え機能つけたかったよ。②
//    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
//           return true
//       }
//
//    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
//        var i = 0
//        while i < textArray.count {
//            textArray[i] = "\(i + 1):"
//            i += 1
//        }
//
//        let targetTitle = currentChordArray[sourceIndexPath.row]
//        if let index = currentChordArray.index(of: targetTitle) {
//            //元の位置のデータを配列から削除
//            currentChordArray.remove(at: sourceIndexPath.row)
//            //移動先の位置にデータを配列に挿入
//            currentChordArray.insert(targetTitle, at: destinationIndexPath.row)
//        }
//
//        tableView.reloadData()
//    }
//
//    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
//        return .none
//    }
//
//    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
//        return false
//    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete {
            //cellが1つしかないときは選択コードをendに変える
            //それ以外は 選択cellを削除、該当cellの選択コードも削除、textArrayも再命名
            if textArray.count == 1 {
                currentChordArray[0] = "end"
            } else {
                textArray.remove(at: indexPath.row)
                currentChordArray.remove(at: indexPath.row)
                
                var i = 0
                while i < textArray.count {
                    textArray[i] = "\(i + 1):"
                    i += 1
                }
            }
            
            tableView.reloadData()
        }
    }
    
    
    /* PickerView */
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return chordArray.count
    }

    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 18)
        label.text = chordArray[row]
        
        return label
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let cell = tableView.cellForRow(at: pickerIndexPath) as! TableViewCell
        cell.chordLabel.text = chordArray[row]
        currentChordArray[pickerIndexPath.row] = chordArray[row]
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
}
