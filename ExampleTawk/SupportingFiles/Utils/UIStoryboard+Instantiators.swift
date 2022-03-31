//
//  UIStoryboard+Instantiators.swift
//  ExampleTawk
//
//  Created by Himanshu on 29/03/22.
//

import Foundation
import UIKit

enum Storyboard : String {
    case Main  
}

protocol StoryboardIdentifiable {
    static var storyboardIdentifier: String { get }
}

extension StoryboardIdentifiable where Self: UIViewController {
    static var storyboardIdentifier: String {
        return String(describing: self)
    }
}

extension UIStoryboard  {
    
    /// The uniform place where we state all the storyboard we have in our application
    
    /// Convenience Initializers
    convenience init(storyboard: Storyboard, bundle: Bundle? = nil) {
        self.init(name: storyboard.rawValue, bundle: bundle)
    }
    
    class func storyboard(storyboard: Storyboard, bundle: Bundle? = nil) -> UIStoryboard {
        return UIStoryboard(name: storyboard.rawValue, bundle: bundle)
    }
    
    /// View Controller Instantiation from Generics
    func instantiateViewController<T>() -> T where T: StoryboardIdentifiable {
        guard let viewController = self.instantiateViewController(withIdentifier: T.storyboardIdentifier) as? T else {
            fatalError("Couldn't instantiate view controller with identifier \(T.storyboardIdentifier) ")
        }
        
        return viewController
    }
}


// Conform Protocol to all the view controllers
extension UIViewController : StoryboardIdentifiable {
    
}
