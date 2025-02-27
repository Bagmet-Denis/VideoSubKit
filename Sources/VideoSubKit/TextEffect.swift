import SwiftUI
import UIKit

public struct TextEffect {
    public var fontName: String?
    public var textColor: UIColor
    public var textGradientColors: [UIColor]?
    public var textPattern: UIImage?
    
    public var strokeStyles: [StrokeStyle]
    public var globalStroke: StrokeStyle?
    public var textShadows: [TextShadow]
    
    public var animations: [CAAnimation]
    
    public var backgroundType: BackgroundType?
    public var backgroundRoundedCorners: CGFloat?
    public var backgroundColors: [UIColor]?
    public var backgroundPattern: UIImage?
    
    public init(fontName: String? = nil, textColor: UIColor, textGradientColors: [UIColor]? = nil, textPattern: UIImage? = nil, strokeStyles: [StrokeStyle], globalStroke: StrokeStyle? = nil, textShadows: [TextShadow], animations: [CAAnimation], backgroundType: BackgroundType? = nil, backgroundRoundedCorners: CGFloat? = nil, backgroundColors: [UIColor]? = nil, backgroundPattern: UIImage? = nil) {
        self.fontName = fontName
        self.textColor = textColor
        self.textGradientColors = textGradientColors
        self.textPattern = textPattern
        self.strokeStyles = strokeStyles
        self.globalStroke = globalStroke
        self.textShadows = textShadows
        self.animations = animations
        self.backgroundType = backgroundType
        self.backgroundRoundedCorners = backgroundRoundedCorners
        self.backgroundColors = backgroundColors
        self.backgroundPattern = backgroundPattern
    }
}
