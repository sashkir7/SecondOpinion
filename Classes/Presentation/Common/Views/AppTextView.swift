//
//  Created by Dmitry Frishbuter on 08.05.2020
//  Copyright © 2020 98 Training Pty Limited. All rights reserved.
//

import UIKit

final class AppTextView: UITextView {

    var attributedPlaceholder: NSAttributedString? {
        didSet {
            setNeedsDisplay()
        }
    }

    override var text: String! {
        didSet {
            setNeedsDisplay()
        }
    }

    var attributedTextChangeHandler: ((AppTextView, NSAttributedString) -> Void)?
    var heightChangeHandler: ((AppTextView, CGFloat) -> Void)?

    override init(frame: CGRect = .zero, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)

        tintColor = .eveningSea
        NotificationCenter.default.addObserver(self, selector: #selector(textDidChange), name: UITextView.textDidChangeNotification, object: self)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func draw(_ rect: CGRect) {
        super.draw(rect)

        guard text.isEmpty else {
            return
        }
        let origin = CGPoint(
            x: textContainerInset.left + textContainer.lineFragmentPadding,
            y: textContainerInset.top
        )
        let width = rect.size.width - origin.x - textContainerInset.right
        let height = rect.size.height - origin.y - textContainerInset.bottom
        let placeholderRect = CGRect(origin: origin, size: CGSize(width: width, height: height))
        if let attributedPlaceholder = attributedPlaceholder {
            attributedPlaceholder.draw(in: placeholderRect)
        }
    }

    private func boundingRectForCharacter(in range: NSRange) -> CGRect {
        let glyphRange = layoutManager.glyphRange(forCharacterRange: range, actualCharacterRange: nil)
        var rect = layoutManager.boundingRect(forGlyphRange: glyphRange, in: textContainer)
        rect.origin.x += textContainerInset.left
        rect.origin.y += textContainerInset.top
        rect.size.width = min(rect.width, 1)
        rect.size.height += textContainerInset.bottom
        return rect
    }

    @objc private func textDidChange() {
        setNeedsDisplay()

        attributedTextChangeHandler?(self, attributedText)

        let size = sizeThatFits(CGSize(width: bounds.size.width, height: .greatestFiniteMagnitude))
        if size.height != bounds.size.height {
            heightChangeHandler?(self, size.height)
        }
        if let index = selectedRangeStart {
            let rect = boundingRectForCharacter(in: NSRange(location: index, length: 1))
            scrollRectToVisible(rect, animated: false)
        }
    }
}
