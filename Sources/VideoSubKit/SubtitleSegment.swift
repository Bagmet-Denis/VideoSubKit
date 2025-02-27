import SwiftUI
import UIKit

public struct SubtitleSegment {
    public var id = UUID()
    public var text: String
    public var textSize: CGFloat
    public var startTime: TimeInterval
    public var endTime: TimeInterval
    public var textEffect: TextEffect
    public var inactiveTextEffect: TextEffect?
    
    public init(id: UUID = UUID(), text: String, textSize: CGFloat, startTime: TimeInterval, endTime: TimeInterval, textEffect: TextEffect, inactiveTextEffect: TextEffect? = nil) {
        self.id = id
        self.text = text
        self.textSize = textSize
        self.startTime = startTime
        self.endTime = endTime
        self.textEffect = textEffect
        self.inactiveTextEffect = inactiveTextEffect
    }
}
