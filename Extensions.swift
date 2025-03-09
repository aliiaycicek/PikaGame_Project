import UIKit

extension UILabel {
    private struct AssociatedKeys {
        static var padding = UIEdgeInsets()
    }
    
    var padding: UIEdgeInsets {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.padding) as? UIEdgeInsets ?? .zero
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.padding, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    open override func draw(_ rect: CGRect) {
        drawText(in: rect.inset(by: padding))
    }
    
    open override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(width: size.width + padding.left + padding.right,
                     height: size.height + padding.top + padding.bottom)
    }
}

extension UIFont {
    static func customFont(name: String, size: CGFloat) -> UIFont {
        if let font = UIFont(name: name, size: size) {
            return font
        }
        print("Warning: Font '\(name)' not found. Using system font instead.")
        return UIFont.systemFont(ofSize: size)
    }
}
