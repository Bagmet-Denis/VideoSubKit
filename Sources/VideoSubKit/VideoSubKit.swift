// The Swift Programming Language
// https://docs.swift.org/swift-book

import UIKit

@MainActor let testSubtitles: [SubtitleSegment] = [
    SubtitleSegment(id: UUID(), text: "Это", textSize: 36, startTime: 0.0, endTime: 1.0, textEffect: TextEffect(fontName: nil, textColor: UIColor.black, textGradientColors: nil, textPattern: nil, strokeStyles: [], globalStroke: nil, textShadows: [], animations: [], backgroundType: .rectangle, backgroundColors: [UIColor.green], backgroundPattern: nil)),
    
    SubtitleSegment(id: UUID(), text: "простой", textSize: 36, startTime: 1.0, endTime: 2.0, textEffect: TextEffect(fontName: nil, textColor: UIColor.black, textGradientColors: nil, textPattern: nil, strokeStyles: [], globalStroke: nil, textShadows: [], animations: [], backgroundType: .rectangle, backgroundColors: [UIColor.green], backgroundPattern: nil)),
    
    SubtitleSegment(id: UUID(), text: "пример", textSize: 36, startTime: 2.0, endTime: 3.0, textEffect: TextEffect(fontName: nil, textColor: UIColor.black, textGradientColors: nil, textPattern: nil, strokeStyles: [], globalStroke: nil, textShadows: [], animations: [], backgroundType: .rectangle, backgroundColors: [UIColor.green], backgroundPattern: nil)),
    
    SubtitleSegment(id: UUID(), text: "текста", textSize: 36, startTime: 3.0, endTime: 4.0, textEffect: TextEffect(fontName: nil, textColor: UIColor.black, textGradientColors: nil, textPattern: nil, strokeStyles: [], globalStroke: nil, textShadows: [], animations: [], backgroundType: .rectangle, backgroundColors: [UIColor.green], backgroundPattern: nil)),
    
    SubtitleSegment(id: UUID(), text: "с", textSize: 36, startTime: 4.0, endTime: 4.5, textEffect: TextEffect(fontName: nil, textColor: UIColor.black, textGradientColors: nil, textPattern: nil, strokeStyles: [], globalStroke: nil, textShadows: [], animations: [], backgroundType: Optional.none, backgroundColors: [UIColor.green], backgroundPattern: nil)),
    
    SubtitleSegment(id: UUID(), text: "анимацией", textSize: 36, startTime: 4.5, endTime: 5.5, textEffect: TextEffect(fontName: nil, textColor: UIColor.black, textGradientColors: nil, textPattern: nil, strokeStyles: [], globalStroke: nil, textShadows: [], animations: [], backgroundType: .rectangle, backgroundColors: [UIColor.green], backgroundPattern: nil)),
]
