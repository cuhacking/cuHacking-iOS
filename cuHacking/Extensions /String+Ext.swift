//
//  NSExpression+Ext.swift
//  cuHacking
//
//  Created by Santos on 2019-07-31.
//  Copyright © 2019 cuHacking. All rights reserved.
//

import Foundation
import UIKit

extension String {
    static func formatMGLMatchExpression(attribute: String, keys: [String], stringFormat: String, includeDefault: Bool) -> String {
        var format = "MGL_MATCH(\(attribute),"
        for key in keys {
            format += "'\(key)',\(stringFormat),"
        }
        if includeDefault {
            format += "\(stringFormat)"
        } else {
            format = String(format.dropLast())
        }
        format += ")"
        print("format:\(format)")
        return format
    }

    var qrCode: UIImage? {
        let data = self.data(using: String.Encoding.ascii)

        if let filter = CIFilter(name: "CIQRCodeGenerator") {
            filter.setValue(data, forKey: "inputMessage")
            let transform = CGAffineTransform(scaleX: 5, y: 5)

            if let output = filter.outputImage?.transformed(by: transform) {
                return UIImage(ciImage: output)
            }
        }

        return nil
    }
}
