public enum BackgroundType: String, CaseIterable, Identifiable {
    case none = "None"
    case rectangle = "Rectangle"
    case rounded = "Rounded"
    
    public var id: String { self.rawValue }
}
