//
//  TableViewCellViewModel.swift
//  Knil
//
//  Created by Ethanhuang on 2018/6/25.
//  Copyright © 2018年 Elaborapp Co., Ltd. All rights reserved.
//

import UIKit

typealias UIViewControllerClosure = () -> UIViewController?
typealias Closure = () -> Void

public struct TableViewCellViewModel {
    let title: String
    let subtitle: String?
    let image: UIImage?
    let reuseIdentifier: String
    let cellStyle: UITableViewCellStyle
    let selectionStyle: UITableViewCellSelectionStyle
    let accessoryType: UITableViewCellAccessoryType
    let editActions: [UITableViewRowAction]
    var selectAction: Closure

    init(title: String,
         subtitle: String? = nil,
         image: UIImage? = nil,
         cellStyle: UITableViewCellStyle = .default,
         selectionStyle: UITableViewCellSelectionStyle = .default,
         accessoryType: UITableViewCellAccessoryType = .disclosureIndicator,
         editActions: [UITableViewRowAction] = [],
         selectAction: @escaping Closure = {}
        ) {
        self.title = title
        self.subtitle = subtitle
        self.image = image
        self.cellStyle = cellStyle
        self.reuseIdentifier = String(cellStyle.rawValue)
        self.selectionStyle = selectionStyle
        self.accessoryType = accessoryType
        self.editActions = editActions
        self.selectAction = selectAction
    }

    func configure(_ cell: UITableViewCell) {
        cell.textLabel?.text = title
        cell.textLabel?.numberOfLines = 0
        cell.detailTextLabel?.text = subtitle
        cell.detailTextLabel?.numberOfLines = 0

        if let image = self.image {
            let size = CGSize(width: 60, height: 60)

            UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)

            cell.imageView?.image = image

            let rect = CGRect(origin: .zero, size: size)

            let topLPoint = CGPoint(x: rect.minX, y: rect.minY)
            let topRPoint = CGPoint(x: rect.maxX, y: rect.minY)
            let botLPoint = CGPoint(x: rect.minX, y: rect.maxY)
            let botRPoint = CGPoint(x: rect.maxX, y: rect.maxY)

            let midRPoint = CGPoint(x: rect.maxX, y: rect.midY)
            let midBPoint = CGPoint(x: rect.midX, y: rect.maxY)
            let midTPoint = CGPoint(x: rect.midX, y: rect.minY)
            let midLPoint = CGPoint(x: rect.minX, y: rect.midY)

            let bezierCurvePath = UIBezierPath()
            bezierCurvePath.move(to: midLPoint)
            bezierCurvePath.addCurve(to: midTPoint, controlPoint1: topLPoint, controlPoint2: topLPoint)
            bezierCurvePath.addCurve(to: midRPoint, controlPoint1: topRPoint, controlPoint2: topRPoint)
            bezierCurvePath.addCurve(to: midBPoint, controlPoint1: botRPoint, controlPoint2: botRPoint)
            bezierCurvePath.addCurve(to: midLPoint, controlPoint1: botLPoint, controlPoint2: botLPoint)

            let mask = CAShapeLayer()
            mask.path = bezierCurvePath.cgPath
            cell.imageView?.layer.mask = mask

            cell.imageView?.image?.draw(in: rect)
            cell.imageView?.image = UIGraphicsGetImageFromCurrentImageContext()

            UIGraphicsEndImageContext()
        }

        cell.selectionStyle = selectionStyle
        cell.accessoryType = accessoryType
    }
}
