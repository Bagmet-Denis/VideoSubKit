import SwiftUI
import UIKit

public struct TextShadow {
    public var color: UIColor
    public var opacity: CGFloat
    public var offsetX: CGFloat
    public var offsetY: CGFloat
    public var blurRadius: CGFloat
    
    init(color: UIColor, opacity: CGFloat, offsetX: CGFloat, offsetY: CGFloat, blurRadius: CGFloat) {
        self.color = color
        self.opacity = opacity
        self.offsetX = offsetX
        self.offsetY = offsetY
        self.blurRadius = blurRadius
    }
}
