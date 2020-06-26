//
//  BpmTextField.swift
//  Chordliner
//
//  Created on 2020/06/23.
//  Copyright © 2020 SotaIshino All rights reserved.
//

import UIKit

class BmpTextField: UITextField {

    // 範囲選択カーソル非表示
    override func selectionRects(for range: UITextRange) -> [UITextSelectionRect] {
        return []
    }

    // コピー・ペースト・選択等のメニュー非表示
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        return false
    }
    
    func pass(st: String, tag: Int, textField: UITextField) {
        if st.count >= 3 {
            textField.text = "999"
        } else if st.count <= 1 {
            textField.text = "10"
        }
    }

}
