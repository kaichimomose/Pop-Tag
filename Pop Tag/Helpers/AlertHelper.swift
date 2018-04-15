//
//  AlertHelper.swift
//  Pop Tag
//
//  Created by Kaichi Momose on 2018/04/14.
//  Copyright © 2018 Kaichi Momose. All rights reserved.
//

import Foundation
import UIKit

protocol AlertPresentable: class {
    func selectChartType(line: @escaping () -> (), column: @escaping () -> (), spline: @escaping () -> ())
}

extension AlertPresentable where Self: UIViewController {
    func selectChartType(line: @escaping () -> (), column: @escaping () -> (), spline: @escaping () -> ()) {
        let actionSheet = UIAlertController(
            title: "Select chart type.",
            message: nil,
            preferredStyle: .actionSheet
        )
        
        actionSheet.addAction(
            UIAlertAction(
                title: "Line Chart",
                style: .default,
                handler: { _ in
                    line()
            })
        )
        
        actionSheet.addAction(
            UIAlertAction(
                title: "Spline Chart",
                style: .default,
                handler: { _ in
                    spline()
            })
        )
        
        actionSheet.addAction(
            UIAlertAction(
                title: "Column Chart",
                style: .default,
                handler: { _ in
                    column()
            })
        )
        
        actionSheet.addAction(
            UIAlertAction(
                title: "Cancel",
                style: .cancel,
                handler: nil)
        )
        
        self.present(actionSheet, animated: true, completion: nil)
    }
}
