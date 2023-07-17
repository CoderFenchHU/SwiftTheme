//
//  ThemeManager+Plist.swift
//  SwiftTheme
//
//  Created by Gesen on 16/9/18.
//  Copyright © 2016年 Gesen. All rights reserved.
//

import UIKit

@objc extension ThemeManager {
    
    public class func value(for keyPath: String) -> Any? {
        return currentTheme?.value(forKeyPath: keyPath)
    }
    
    public class func string(for keyPath: String) -> String? {
        guard let string = currentTheme?.value(forKeyPath: keyPath) as? String else {
            print("SwiftTheme WARNING: Not found string key path: \(keyPath)")
            return nil
        }
        return string
    }
    
    public class func number(for keyPath: String) -> NSNumber? {
        guard let number = currentTheme?.value(forKeyPath: keyPath) as? NSNumber else {
            print("SwiftTheme WARNING: Not found number key path: \(keyPath)")
            return nil
        }
        return number
    }
    
    public class func dictionary(for keyPath: String) -> NSDictionary? {
        guard let dict = currentTheme?.value(forKeyPath: keyPath) as? NSDictionary else {
            print("SwiftTheme WARNING: Not found dictionary key path: \(keyPath)")
            return nil
        }
        return dict
    }
    
    public class func color(for keyPath: String) -> UIColor? {
        guard let rgba = string(for: keyPath) else { return nil }
        guard let color = try? UIColor(rgba_throws: rgba) else {
            print("SwiftTheme WARNING: Not convert rgba \(rgba) at key path: \(keyPath)")
            return nil
        }
        return color
    }
    
    public class func image(for keyPath: String) -> UIImage? {
        guard let imageName = string(for: keyPath) else { return nil }
        if let filePath = currentThemePath?.URL?.appendingPathComponent(imageName).path,
           let image = UIImage(contentsOfFile: filePath)
        {
            return image
        } else if let url = currentThemePath?.URL,
                  let bundle = Bundle(url: url),
                  let image = UIImage(named: imageName, in: bundle, compatibleWith: nil)
        {
            return image
        }
        return UIImage(named: imageName) 
    }
    
    public class func font(for keyPath: String) -> UIFont? {
        guard let fontstr = string(for: keyPath) else { return nil }
        return font(from: fontstr)
    }
    
    internal class func font(from string: String) -> UIFont {
        let elements = string.components(separatedBy: ",")
        if elements.count == 2 {
            return UIFont(name: elements[0], size: CGFloat(Float(elements[1])!))!
        }
        
        if let fontSize = Float(string), fontSize > 0 {
            return UIFont.systemFont(ofSize: CGFloat(fontSize))
        }
        
        let value = "UICTFontTextStyle" + string.capitalized
        return UIFont.preferredFont(forTextStyle: UIFont.TextStyle(rawValue: value))
    }
    
}
