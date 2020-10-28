//
//  Extension.swift
//  MyApp
//
//  Created by Laura Ghiorghisor on 23/08/2020.
//  Copyright © 2020 Laura Ghiorghisor. All rights reserved.


// To be used for padding setting.
// must reference
import UIKit

extension UITextField {

    enum PaddingSide {
        case left(CGFloat)
        case right(CGFloat)
        case both(CGFloat)
    }

    func addPadding(_ padding: PaddingSide) {

        self.leftViewMode = .always
        self.layer.masksToBounds = true


        switch padding {

        case .left(let spacing):
            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: spacing, height: self.frame.height))
            self.leftView = paddingView
            self.rightViewMode = .always

        case .right(let spacing):
            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: spacing, height: self.frame.height))
            self.rightView = paddingView
            self.rightViewMode = .always

        case .both(let spacing):
            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: spacing, height: self.frame.height))
            // left
            self.leftView = paddingView
            self.leftViewMode = .always
            // right
            self.rightView = paddingView
            self.rightViewMode = .always
        }
    }
}

/*
 // 1.  To add left padding
 yourTextFieldName.addPadding(.left(20))

 // 2.  To add right padding
 yourTextFieldName.addPadding(.right(20))

 // 3. To add left & right padding both
 yourTextFieldName.addPadding(.both(20))
 */

