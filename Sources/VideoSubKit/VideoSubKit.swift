// The Swift Programming Language
// https://docs.swift.org/swift-book

import UIKit

let textSize: CGFloat = 36
let activeTextColor: UIColor = UIColor.orange
let inactiveTextColor: UIColor = UIColor.gray

@MainActor let activeBackgroundType: BackgroundType = .rounded
@MainActor let inactiveBackgroundType: BackgroundType = .none

let activeBackgroundColors: [UIColor] = [UIColor.orange.withAlphaComponent(0.5)]
let inactiveBackgroundColors: [UIColor] = [UIColor.orange]

@MainActor public let testSubtitles: [SubtitleSegment] = [
    SubtitleSegment(id: UUID(), text: "Это", textSize: 36, startTime: 0.0, endTime: 1.0, textEffect: TextEffect(fontName: nil, textColor: UIColor.black, textGradientColors: nil, textPattern: nil, strokeStyles: [], globalStroke: nil, textShadows: [], animations: [], backgroundType: .rectangle, backgroundColors: [UIColor.green], backgroundPattern: nil)),
    
    SubtitleSegment(id: UUID(), text: "простой", textSize: 36, startTime: 1.0, endTime: 2.0, textEffect: TextEffect(fontName: nil, textColor: UIColor.black, textGradientColors: nil, textPattern: nil, strokeStyles: [], globalStroke: nil, textShadows: [], animations: [], backgroundType: .rectangle, backgroundColors: [UIColor.green], backgroundPattern: nil)),
    
    SubtitleSegment(id: UUID(), text: "пример", textSize: 36, startTime: 2.0, endTime: 3.0, textEffect: TextEffect(fontName: nil, textColor: UIColor.black, textGradientColors: nil, textPattern: nil, strokeStyles: [], globalStroke: nil, textShadows: [], animations: [], backgroundType: .rectangle, backgroundColors: [UIColor.green], backgroundPattern: nil)),
    
    SubtitleSegment(id: UUID(), text: "текста", textSize: 36, startTime: 3.0, endTime: 4.0, textEffect: TextEffect(fontName: nil, textColor: UIColor.black, textGradientColors: nil, textPattern: nil, strokeStyles: [], globalStroke: nil, textShadows: [], animations: [], backgroundType: .rectangle, backgroundColors: [UIColor.green], backgroundPattern: nil)),
    
    SubtitleSegment(id: UUID(), text: "с", textSize: 36, startTime: 4.0, endTime: 4.5, textEffect: TextEffect(fontName: nil, textColor: UIColor.black, textGradientColors: nil, textPattern: nil, strokeStyles: [], globalStroke: nil, textShadows: [], animations: [], backgroundType: Optional.none, backgroundColors: [UIColor.green], backgroundPattern: nil)),
    
    SubtitleSegment(id: UUID(), text: "анимацией", textSize: 36, startTime: 4.5, endTime: 5.5, textEffect: TextEffect(fontName: nil, textColor: UIColor.black, textGradientColors: nil, textPattern: nil, strokeStyles: [], globalStroke: nil, textShadows: [], animations: [], backgroundType: .rectangle, backgroundColors: [UIColor.green], backgroundPattern: nil)),
]

@MainActor func applyEffect(subtitles: [SubtitleSegment]) -> [SubtitleSegment]{
    var appliedSubtitles: [SubtitleSegment] = []
    
    let activeTextEffect = TextEffect(textColor: activeTextColor, strokeStyles: [], textShadows: [], animations: [], backgroundType: activeBackgroundType, backgroundColors: activeBackgroundColors)
    let inactiveTextEffect = TextEffect(textColor: inactiveTextColor, strokeStyles: [], textShadows: [], animations: [], backgroundType: inactiveBackgroundType, backgroundColors: inactiveBackgroundColors)
    
    for subtitle in subtitles {
        appliedSubtitles.append(SubtitleSegment(text: subtitle.text, textSize: subtitle.textSize, startTime: subtitle.startTime, endTime: subtitle.endTime, textEffect: activeTextEffect, inactiveTextEffect: inactiveTextEffect))
    }
    
    return appliedSubtitles
}

func calculateTextSize(text: String, font: UIFont, maxWidth: CGFloat) -> CGSize {
    let textStorage = NSTextStorage(string: text, attributes: [.font: font])
    let layoutManager = NSLayoutManager()
    let textContainer = NSTextContainer(size: CGSize(width: maxWidth, height: .greatestFiniteMagnitude))
    
    textContainer.lineBreakMode = .byWordWrapping
    textContainer.lineFragmentPadding = 0.0
    layoutManager.addTextContainer(textContainer)
    textStorage.addLayoutManager(layoutManager)
    
    layoutManager.glyphRange(for: textContainer) // Запускаем расчёт
    
    let rect = layoutManager.usedRect(for: textContainer)
    return CGSize(width: ceil(rect.width), height: ceil(rect.height))
}

func createMainTextLayer(subtitle: SubtitleSegment, isActive: Bool, textWidth: CGFloat, textHeight: CGFloat) -> CATextLayer {
    let textLayer = CATextLayer()
    textLayer.contentsScale = 1
    textLayer.alignmentMode = .center
    textLayer.frame = CGRect(x: 0, y: 0, width: textWidth, height: textHeight)
    
    // ⚡️ Используем кастомный шрифт, если он задан
    let font: UIFont
    if let fontName = subtitle.textEffect.fontName, let customFont = UIFont(name: fontName, size: subtitle.textSize) {
        font = customFont
    } else {
        font = UIFont.boldSystemFont(ofSize: subtitle.textSize) // Фоллбэк на системный шрифт
    }
    
    let attributedText = NSAttributedString(
        string: subtitle.text,
        attributes: [
            .foregroundColor: isActive ? subtitle.textEffect.textColor : subtitle.inactiveTextEffect?.textColor ?? subtitle.textEffect.textColor,
            .font: font
        ]
    )
    
    textLayer.string = attributedText
    
    let correctTextHeight = textHeight + font.ascender
    
        textLayer.frame = CGRect(
            x: 0,
            y: 0,
            width: textWidth,
            height: correctTextHeight
        )
    
    return textLayer
}

func setVisibleSubtitles(_ subtitles: inout [SubtitleSegment]){
    for index in subtitles.indices{
        var subtitle = subtitles[index]
        let duration = 0.5
        
        let fadeIn = CABasicAnimation(keyPath: "opacity")
        fadeIn.fromValue = 0.0
        fadeIn.toValue = 1.0
        fadeIn.beginTime = CACurrentMediaTime() + subtitle.startTime
        fadeIn.duration = duration
        fadeIn.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        fadeIn.fillMode = .forwards
        fadeIn.isRemovedOnCompletion = false

        let fadeOut = CABasicAnimation(keyPath: "opacity")
        fadeOut.fromValue = 1.0
        fadeOut.toValue = 0.0
        fadeOut.beginTime = CACurrentMediaTime() + subtitle.endTime - duration
        fadeOut.duration = duration
        fadeOut.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        fadeOut.fillMode = .forwards
        fadeOut.isRemovedOnCompletion = false
        
        subtitles[index].textEffect.animations.append(contentsOf: [fadeIn, fadeOut])
    }
}

func setVisibleLayer(_ layer: CALayer, beginTime: TimeInterval, endTime: TimeInterval, duration: TimeInterval) -> CALayer{
    let fadeIn = CABasicAnimation(keyPath: "opacity")
    fadeIn.fromValue = 0.0
    fadeIn.toValue = 1.0
    fadeIn.beginTime = CACurrentMediaTime() + beginTime
    fadeIn.duration = duration
    fadeIn.timingFunction = CAMediaTimingFunction(name: .linear)
    fadeIn.fillMode = .forwards
    fadeIn.isRemovedOnCompletion = false

    let fadeOut = CABasicAnimation(keyPath: "opacity")
    fadeOut.fromValue = 1.0
    fadeOut.toValue = 0.0
    fadeOut.beginTime = CACurrentMediaTime() + endTime - duration
    fadeOut.duration = duration
    fadeOut.timingFunction = CAMediaTimingFunction(name: .linear)
    fadeOut.fillMode = .forwards
    fadeOut.isRemovedOnCompletion = false
    
    layer.add(fadeIn, forKey: "fadeIn")
    layer.add(fadeOut, forKey: "fadeOut")
    
    return layer
}

func createBackgroundLayer(subtitle: SubtitleSegment, isActive: Bool, textWidth: CGFloat, textHeight: CGFloat, textPosition: CGPoint) -> CALayer {
    let backgroundLayer = CALayer()
    
    let adjustedHeight = textHeight + subtitle.textSize * 0.2
    
    backgroundLayer.frame = CGRect(
        x: textPosition.x,
        y: textPosition.y - subtitle.textSize * 0.1,
        width: textWidth,
        height: textHeight
    )
    
    if isActive{
        // 🎨 1️⃣ Если передан ПАТТЕРН (изображение)
    //    if let patternImage = subtitle.textEffect.backgroundPattern {
    //        let patternLayer = CALayer()
    //        patternLayer.contents = patternImage.cgImage
    //        patternLayer.frame = backgroundLayer.bounds
    //        backgroundLayer.addSublayer(patternLayer)
    //        return backgroundLayer
    //    }
    //
    //    // 🎨 2️⃣ Если передан ГРАДИЕНТ
    //    if let backgroundColors = subtitle.textEffect.backgroundColors, backgroundColors.count > 1 {
    //        let gradientLayer = CAGradientLayer()
    //        gradientLayer.colors = backgroundColors.map { $0.cgColor }
    //        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
    //        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
    //        gradientLayer.frame = backgroundLayer.bounds
    //
    //        // ✅ Делаем градиент применимым только к тексту
    //        let maskLayer = CATextLayer()
    //        maskLayer.string = subtitle.text
    //        maskLayer.fontSize = subtitle.textSize
    //        maskLayer.alignmentMode = .center
    //        maskLayer.contentsScale = 1
    //        maskLayer.frame = backgroundLayer.bounds
    //
    //        gradientLayer.mask = maskLayer
    //        backgroundLayer.addSublayer(gradientLayer)
    //
    //        return backgroundLayer
    //    }

        // 🎨 3️⃣ Если один цвет
        if let backgroundColor = subtitle.textEffect.backgroundColors?.first {
            backgroundLayer.backgroundColor = backgroundColor.cgColor
        }
        
        if subtitle.textEffect.backgroundType == .rounded{
            backgroundLayer.cornerRadius = subtitle.textEffect.backgroundRoundedCorners ?? 0
            backgroundLayer.masksToBounds = true
        }

        return backgroundLayer
    }else{
        // 🎨 3️⃣ Если один цвет
        if let backgroundColor = subtitle.inactiveTextEffect?.backgroundColors?.first {
            backgroundLayer.backgroundColor = backgroundColor.cgColor
        }
        
        if subtitle.inactiveTextEffect?.backgroundType == .rounded{
            backgroundLayer.cornerRadius = subtitle.inactiveTextEffect?.backgroundRoundedCorners ?? 0
            backgroundLayer.masksToBounds = true
        }
        
        return backgroundLayer
    }
}

func createTextLayer(subtitle: SubtitleSegment, isActive: Bool, rectSize: CGSize) -> CALayer {
    let parentLayer = CALayer()
    
    let textWidth: CGFloat = rectSize.width
    let textHeight: CGFloat = subtitle.textSize
    let textPosition = CGPoint(x: 0, y: 0)
    
    // 🎨 Создаём ФОН
    let backgroundLayer = createBackgroundLayer(subtitle: subtitle, isActive: isActive, textWidth: textWidth, textHeight: textHeight, textPosition: textPosition)
    
    // 🌟 Создаём ТЕНИ
    //    let shadows = subtitle.textEffect?.textShadows ?? []
    //    let shadowLayers: [CALayer] = shadows.map { shadow in
    //        createShadowLayer(subtitle: subtitle, videoSize: videoSize, textShadow: shadow)
    //    }
    
    // 🎯 Основной ТЕКСТ с проверкой на паттерн
    //    let textLayer: CALayer
    //    if let patternImage = subtitle.textEffect?.textPattern {
    ////        textLayer = createPatternTextLayer(subtitle: subtitle, textWidth: textWidth, textHeight: textHeight, patternImage: patternImage)
    //    } else if let gradientColors = subtitle.textEffect?.textGradientColors {
    ////        textLayer = createGradientTextLayer(subtitle: subtitle, textWidth: textWidth, textHeight: textHeight, gradientColors: gradientColors)
    //    } else {
    //        textLayer = createMainTextLayer(subtitle: subtitle, textWidth: textWidth, textHeight: textHeight)
    //    }
    
    let textLayer = createMainTextLayer(subtitle: subtitle, isActive: isActive, textWidth: textWidth, textHeight: textHeight)
    // 🎨 Создаём ОБЫЧНЫЕ ОБВОДКИ
    //    let strokeLayers: [CATextLayer] = (subtitle.textEffect?.strokeStyles ?? []).reversed().map { stroke in
    //        createStrokeLayer(strokeColor: stroke.color, strokeWidth: stroke.width, subtitle: subtitle, videoSize: videoSize)
    //    }
    
    // 🔹 Добавляем всё в `parentLayer`
    //    shadowLayers.forEach { parentLayer.addSublayer($0) } // Тени
    //    strokeLayers.forEach { backgroundLayer.addSublayer($0) } // Обычные обводки
    backgroundLayer.addSublayer(textLayer) // Основной текст
    parentLayer.addSublayer(backgroundLayer) // Фон
    
    // 🏗 Устанавливаем начальную прозрачность
//    parentLayer.opacity = 0.0
    
    // ✨ Применяем анимации
    for animation in subtitle.textEffect.animations {
        parentLayer.add(animation, forKey: nil)
    }
    
    return parentLayer
}

func createMultiStyleTextLayer(phrase: [SubtitleSegment], indexCurrentWord: Int, beginTimeActiveWord: TimeInterval, endTimeActiveWord: TimeInterval, rect: CGSize) -> CALayer {
    let parentLayer = CALayer()
    
    var remainingWidth = rect.width
    let wordSpacing: CGFloat = 5.0
    let lineSpacing: CGFloat = 5.0

    var currentX: CGFloat = 0
    var currentY: CGFloat = 0
    var maxHeightInLine: CGFloat = 0

    var startVisibleLayerTimeInterval: TimeInterval = 0
    var endVisibleLayerTimeInterval: TimeInterval = 0
    
    for (index, word) in phrase.enumerated() {
        // ⚡️ Определяем шрифт текста
        let font: UIFont
        if let fontName = word.textEffect.fontName, let customFont = UIFont(name: fontName, size: word.textSize) {
            font = customFont
        } else {
            font = UIFont.boldSystemFont(ofSize: word.textSize)
        }

        // 📏 Вычисляем размер текста
        let textSize = calculateTextSize(text: word.text, font: font, maxWidth: rect.width)

        // 🛑 Если слово не помещается в текущую строку — переносим на новую
        if textSize.width > remainingWidth {
            currentX = 0 // Сбрасываем X (новая строка)
            currentY += maxHeightInLine + lineSpacing // Переходим на новую строку
            remainingWidth = rect.width // Обновляем доступную ширину
            maxHeightInLine = 0 // Сбрасываем максимальную высоту строки
        }

        // 🛑 Проверка: если текст выходит за границы контейнера — выходим
        if currentY + textSize.height > rect.height {
            print("Текст не помещается в контейнер, прекращаем размещение")
            break
        }

        
        let isActive = word.startTime >= beginTimeActiveWord && word.endTime <= endTimeActiveWord
        let layer = createTextLayer(subtitle: word, isActive: isActive, rectSize: textSize)

        layer.frame = CGRect(
            x: currentX,
            y: currentY,
            width: textSize.width,
            height: textSize.height
        )

        parentLayer.addSublayer(layer)

        // 🔹 Обновляем позицию для следующего слова
        currentX += textSize.width + wordSpacing
        remainingWidth -= (textSize.width + wordSpacing)

        // 🔹 Обновляем максимальную высоту в строке
        maxHeightInLine = max(maxHeightInLine, textSize.height)
        
        if isActive && indexCurrentWord == index{
            startVisibleLayerTimeInterval = word.startTime
            endVisibleLayerTimeInterval = word.endTime
        }
    }

    let finishLayer = setVisibleLayer(parentLayer, beginTime: startVisibleLayerTimeInterval, endTime: endVisibleLayerTimeInterval, duration: 0.001)
    finishLayer.backgroundColor = UIColor.red.cgColor
    finishLayer.opacity = 0.0
    return finishLayer
}


func createPhraseLayer(subtitles: [SubtitleSegment], rect: CGSize) -> CALayer{
    let parentLayer = CALayer()
        
    for (index, subtitle) in subtitles.enumerated() {
        let phrase = createMultiStyleTextLayer(phrase: subtitles, indexCurrentWord: index, beginTimeActiveWord: subtitle.startTime, endTimeActiveWord: subtitle.endTime, rect: rect)
        
        parentLayer.addSublayer(phrase)
    }

    return parentLayer
}
