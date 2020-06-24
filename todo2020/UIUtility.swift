//
//  UIUtility.swift
//  Quiz
//
//  Created by matsumoto keiji on 2017/05/29.
//  Copyright © 2017年 matsumoto keiji. All rights reserved.
//

import Foundation
import UIKit

struct UIUtility {
    //OKボタンのアラートを出す
    static func showAlertWithOK(vc:UIViewController,title:String,message:String,handler: ((UIAlertAction) -> Swift.Void)? = nil,completion: (() -> Swift.Void)? = nil) {
        let alert:UIAlertController = UIAlertController(title:title, message:message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler:handler))
        vc.present(alert, animated: true, completion:completion)
    }
    
    //OKボタンとキャンセルのアラートを出す
    static func showAlertWithOKAndCansel(vc:UIViewController,title:String,message:String,handlerOK: ((UIAlertAction) -> Swift.Void)? = nil,handlerCancel: ((UIAlertAction) -> Swift.Void)? = nil,completion: (() -> Swift.Void)? = nil) {
        let alert:UIAlertController = UIAlertController(title:title, message:message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler:handlerOK))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler:handlerCancel))
        
        vc.present(alert, animated: true, completion:completion)
    }
    
    //YESボタンとNOのアラートを出す
    static func showAlertWithYESAndNO(vc:UIViewController,title:String,message:String,handlerYES: ((UIAlertAction) -> Swift.Void)? = nil,handlerNO: ((UIAlertAction) -> Swift.Void)? = nil,completion: (() -> Swift.Void)? = nil) {
        let alert:UIAlertController = UIAlertController(title:title, message:message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "YES", style: UIAlertAction.Style.default, handler:handlerYES))
        alert.addAction(UIAlertAction(title: "NO", style: UIAlertAction.Style.default, handler:handlerNO))
        
        vc.present(alert, animated: true, completion:completion)
        
    }
    
    
}

