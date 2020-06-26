//
//  ViewController.swift
//  Chordliner
//
//  Created on 2020/06/19.
//  Copyright © 2020 SotaIshino All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var composeButton: UIBarButtonItem!
    @IBOutlet weak var chordLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var beatsSelect: UIButton!
    @IBOutlet weak var bpmTextField: UITextField!
    @IBOutlet weak var gOrPButton: UIButton!
    
    var pgMan: [UIImage] = [UIImage(named: "g1")!,
                            UIImage(named: "g2")!,
                            UIImage(named: "g3")!,
                            UIImage(named: "g4")!,
                            UIImage(named: "p1")!,
                            UIImage(named: "p2")!,
                            UIImage(named: "p3")!,
                            UIImage(named: "p4")!]
    
    //true:halfNote false:quartarNote
    var beats = true
    
    //true:guitar false:piano
    var guitarOrPiano = true
    
    let playInstance = Play()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // textFieldタップ時のキーボードを数字パッドに設定
        bpmTextField.keyboardType = UIKeyboardType.numberPad
        // keyboardにツールバー生成
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 40))
        // スタイルを設定
        toolBar.barStyle = UIBarStyle.default
        // 画面幅に合わせてサイズを変更
        toolBar.sizeToFit()
        // 閉じるボタンを右に配置するためのスペース?
        let spacer = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: self, action: nil)
        // 閉じるボタン
        let commitButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: self, action: #selector(commitButtonTapped))
        // スペース、閉じるボタンを右側に配置
        toolBar.items = [spacer, commitButton]
        // textViewのキーボードにツールバーを設定
        bpmTextField.inputAccessoryView = toolBar
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureObserver()  //Notification発行
    }
    
    //DoneをタップでKeyboard非表示
    @objc func commitButtonTapped() {
        self.view.endEditing(true)
    }
    
    //Keyboard以外をタップでKeyboard非表示
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    
    @IBAction func composeButtonTapped(_ sender: Any) {
        chordLabel.text = "…"
        
        if guitarOrPiano == true {
            imageView.image = pgMan[0]
        } else {
            imageView.image = pgMan[4]
        }
        
        self.performSegue(withIdentifier: "toSetChord", sender: nil)
    }
    
    
    
    @IBAction func beatsSelect(_ sender: Any) {
        if beats == true {
            beats = false
            let beatSelect = UIImage(named: "beatsSelect1")
            beatsSelect.setImage(beatSelect, for: .normal)
        } else {
            beats = true
            let beatSelect = UIImage(named: "beatsSelect2")
            beatsSelect.setImage(beatSelect, for: .normal)
        }
    }
    
    /// Notification発行
    func configureObserver() {
        let notification = NotificationCenter.default
        notification.addObserver(self, selector: #selector(keyboardWillShow(_:)),
                                 name: UIResponder.keyboardWillShowNotification, object: nil)
        notification.addObserver(self, selector: #selector(keyboardWillHide(_:)),
                                 name: UIResponder.keyboardWillHideNotification, object: nil)
        print("Notificationを発行")
    }
    
    /// キーボードが表示時に画面をずらす。
    @objc func keyboardWillShow(_ notification: Notification?) {
        guard let rect = (notification?.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue,
            let duration = notification?.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval else { return }
        UIView.animate(withDuration: duration) {
            let transform = CGAffineTransform(translationX: 0, y: -(rect.size.height))
            self.view.transform = transform
        }
        print("keyboardWillShowを実行")
    }
    
    /// キーボードが降りたら画面を戻す
    @objc func keyboardWillHide(_ notification: Notification?) {
        guard let duration = notification?.userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? TimeInterval else { return }
        UIView.animate(withDuration: duration) {
            self.view.transform = CGAffineTransform.identity
        }
        print("keyboardWillHideを実行")
    }
    
    
    
    @IBAction func playButtonTapped(_ sender: Any) {
        var i = 0
        let bpm = Int(self.bpmTextField.text!)!
        let playimage = UIImage(named: "play")
        let stopImage = UIImage(named: "play2")
        
        DispatchQueue.global().async {
            
            var looping = true
            while looping && currentChordArray[0] != "end" {
                
                DispatchQueue.main.async {
                    print(i)
                    
                    if looping {
                        self.playButton.setImage(stopImage, for: .normal)
                        //再生中はplayButton、composeButtonを無効
                        self.playButton.isEnabled = false
                        self.composeButton.isEnabled = false
                        self.gOrPButton.isEnabled = false
                        
                        //次再生がrest…4分休符以外の場合、再生中の音を停止
                        if currentChordArray[i] != "rest" {self.playInstance.stop()}
                        
                        //ラベルに再生中のコードを表示
                        self.chordLabel.text = currentChordArray[i]
                        print(self.chordLabel.text!)
                        
                        //再生!
                        if self.guitarOrPiano == true {
                            self.imageView.image = self.pgMan[1]
                            self.playInstance.playGuitar(i: currentChordArray[i])
                        } else {
                            self.imageView.image = self.pgMan[5]
                            self.playInstance.playPiano(i: currentChordArray[i])
                        }
                        
                        i += 1
                        //currentChordArrayが最後or"end"の時、ループを脱す
                        //ボタンも有効に
                        if i >= currentChordArray.count || currentChordArray[i] == "end" {
                            looping = false
                            self.playButton.isEnabled = true
                            self.composeButton.isEnabled = true
                            self.gOrPButton.isEnabled = true
                            self.playButton.setImage(playimage, for: .normal)
                            
                            if self.guitarOrPiano == true {
                                self.imageView.image = self.pgMan[2]
                            } else {
                                self.imageView.image = self.pgMan[6]
                            }
                        }
                    }
                }
                
                if looping {
                    //bpmTextFieldにおける2分音符or4分音符のマイクロ秒を計算&停止
                    if self.beats == true {
                        let sleep = Double(120000000 / bpm)
                        print(sleep)
                        usleep(useconds_t(sleep))
                    } else {
                        let sleep = Double(60000000 / bpm)
                        print(sleep)
                        usleep(useconds_t(sleep))
                    }
                }
            }
        }
        
        if currentChordArray[0] == "end" {
            if guitarOrPiano == true {
                imageView.image = pgMan[3]
            } else {
                imageView.image = pgMan[7]
            }
            
            let anime: [UIImage] = [UIImage(named: "play2")!, UIImage(named: "play")!]
            playButton.setImage(anime[0], for: .normal)
            playButton.imageView?.animationImages = anime
            playButton.imageView?.animationDuration = 0.2
            playButton.imageView?.animationRepeatCount = 1
            playButton.imageView?.startAnimating()
        }
        
        playButton.setImage(playimage, for: .normal)
    }
    
    @IBAction func gOrPButtonTapped(_ sender: Any) {
        gOrPButton.isEnabled = false
        
        if guitarOrPiano == true {
            guitarOrPiano = false
            imageView.image = pgMan[4]
            let image: [UIImage] = [UIImage(named: "guitar2")!, UIImage(named: "piano1")!]
            gOrPButton.setImage(image[0], for: .normal)
            gOrPButton.imageView?.animationImages = image
            gOrPButton.imageView?.animationDuration = 0.2
            gOrPButton.imageView?.animationRepeatCount = 1
            gOrPButton.imageView?.startAnimating()
            gOrPButton.setImage(image[1], for: .normal)
        } else {
            guitarOrPiano = true
            imageView.image = pgMan[0]
            let image: [UIImage] = [UIImage(named: "piano2")!, UIImage(named: "guitar1")!]
            gOrPButton.setImage(image[0], for: .normal)
            gOrPButton.imageView?.animationImages = image
            gOrPButton.imageView?.animationDuration = 0.2
            gOrPButton.imageView?.animationRepeatCount = 1
            gOrPButton.imageView?.startAnimating()
            gOrPButton.setImage(image[1], for: .normal)
        }
        
        gOrPButton.isEnabled = true
    }
    
}
