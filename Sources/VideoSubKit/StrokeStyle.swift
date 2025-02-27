import UIKit

public struct StrokeStyle {
    public var color: UIColor
    public var width: CGFloat
    public var opacity: Float
    public var radius: CGFloat
    
    init(color: UIColor, width: CGFloat, opacity: Float, radius: CGFloat) {
        self.color = color
        self.width = width
        self.opacity = opacity
        self.radius = radius
    }
}
