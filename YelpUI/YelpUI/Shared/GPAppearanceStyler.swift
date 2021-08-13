//
//  GPAppearanceStyler.swift
//  YelpUI
//
//  Created by Trick Gorospe on 6/12/21.
//

import CoreGraphics

/// Defines constants for view appearance styling.
public protocol GPAppearanceStyler {

    var shadowOpacity1: Float { get }
    var shadowRadius1: CGFloat { get }
    var shadowOffset1: CGSize { get }
    var opacity1: CGFloat { get }
    var lineWidth1: CGFloat { get }

    var cornerRadius1: CGFloat { get }
    var cornerRadius2: CGFloat { get }

    var borderWidth1: CGFloat { get }
    var borderWidth2: CGFloat { get }
}

/// Default appearance values.
public extension GPAppearanceStyler {

    var shadowOpacity1: Float { 0.15 }
    var shadowRadius1: CGFloat { 1 }
    var shadowOffset1: CGSize { CGSize(width: 0, height: 5) }
    var opacity1: CGFloat { 0.45 }
    var lineWidth1: CGFloat { 4 }

    var cornerRadius1: CGFloat { 15 }
    var cornerRadius2: CGFloat { 12 }

    var borderWidth1: CGFloat { 3 }
    var borderWidth2: CGFloat { 2 }
}

/// Concrete object for appearance constants.
public struct GPAppearanceStyle: GPAppearanceStyler {
    public init() {}
}
