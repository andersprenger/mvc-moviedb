//
//  Storyboarded.swift
//  MovieDB MVC
//
//  Created by Anderson Sprenger on 04/03/22.
//

import Foundation
import UIKit

/// Represents a view controller that is loaded from a storyboard.
protocol Storyboarded {
    /// Instantiate a view controller from a storyboard whose file name and id are the same as their class name.
    /// - Returns: The UIViewController instance for the view.
    static func instantiate() -> Self
}

extension Storyboarded where Self: UIViewController {
    static func instantiate() -> Self {
        let id = String(describing: self)
        let storyboard = UIStoryboard(name: id, bundle: .main)
        
        return storyboard.instantiateViewController(withIdentifier: id) as! Self
    }
}
