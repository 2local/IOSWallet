//
//  String+HTML.swift
//  2local
//
//  Created by Ibrahim Hosseini on 1/21/22.
//  Copyright © 2022 2local Inc. All rights reserved.
//

import Foundation

extension String {

  /// Convert the HTML string to string
  func HTMLToString() -> String {
    let data = Data(self.utf8)
    if let attributedString = try? NSAttributedString(data: data,
                                                      options: [.documentType: NSAttributedString.DocumentType.html],
                                                      documentAttributes: nil) {
      return attributedString.string
    }
    return ""
  }
}
