//
//  UIApplication+extension.swift
//  WeatherApp
//
//  Created by Aniket Landge on 06/03/22.
//

import Foundation
import UIKit

extension UIApplication{
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }

}
