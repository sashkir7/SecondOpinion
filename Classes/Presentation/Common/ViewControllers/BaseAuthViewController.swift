//
//  Created by Alx Krw on 13.10.2020
//  Copyright © 2020 Ronas IT. All rights reserved.
//

import UIKit
import Framezilla

class BaseAuthViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate {

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }

    private(set) lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .clear
        scrollView.alwaysBounceVertical = false
        scrollView.delaysContentTouches = false
        scrollView.contentInsetAdjustmentBehavior = .never
        return scrollView
    }()

    private(set) lazy var tapGestureRecognizer: UITapGestureRecognizer = {
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
        recognizer.cancelsTouchesInView = false
        recognizer.isEnabled = false
        return recognizer
    }()

    weak var editingInputView: UIView?

    private(set) var textFields: [UITextField] = []

    private(set) var isKeyboardShown: Bool = false {
        didSet {
            view.layout()
        }
    }

    deinit {
        endObservingKeyboardWillShowNotifications()
        endObservingKeyboardWillHideNotifications()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(scrollView)
        view.addGestureRecognizer(tapGestureRecognizer)

        zip(textFields, textFields.indices).forEach { textField, index in
            textField.returnKeyType = index == textFields.indices.last ? .done : .next
            textField.keyboardAppearance = .dark
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        scrollView.configureFrame { maker in
            maker.edges(insets: .zero)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        startObservingKeyboardWillShowNotifications()
        startObservingKeyboardWillHideNotifications()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        endObservingKeyboardWillShowNotifications()
        endObservingKeyboardWillHideNotifications()
    }

    // MARK: -  UITextFieldDelegate

    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        editingInputView = textField
        return true
    }

    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        editingInputView = nil
        return true
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let index = textFields.firstIndex(of: textField) else {
            return true
        }
        if index == textFields.indices.last {
            textField.resignFirstResponder()
        } else {
            textFields[index + 1].becomeFirstResponder()
        }
        return true
    }

    // MARK: -  UITextViewDelegate

    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        editingInputView = textView
        return true
    }

    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        editingInputView = nil
        return true
    }

    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == L10n.NewConsultation.Description.placeholder {
            textView.text = nil
            textView.textColor = UIColor.cyprus
        }
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = L10n.NewConsultation.Description.placeholder
            textView.textColor = UIColor.manatee
        }
    }

    // MARK: -  Actions

    @objc private func viewTapped() {
        view.endEditing(true)
    }
}

// MARK: -  KeyboardNotificationObserver

extension BaseAuthViewController: KeyboardNotificationObserver {

    func keyboardWillShow(with notification: KeyboardNotification) {
        tapGestureRecognizer.isEnabled = true
        scrollView.delaysContentTouches = true
        isKeyboardShown = true

        let keyboardRect = notification.endFrame
        guard let targetView = editingInputView else {
            return
        }

        let targetRect = targetView.convert(targetView.bounds, to: UIScreen.main.coordinateSpace)
        let additionalInset: CGFloat = 20
        let bottomInset = keyboardRect.height - view.safeAreaInsets.bottom

        scrollView.contentInset.bottom = keyboardRect.height + additionalInset
        scrollView.verticalScrollIndicatorInsets.bottom = bottomInset

        guard targetRect.maxY - keyboardRect.minY > 0 else {
            return
        }

        var visibleRect = targetView.frame
        visibleRect.size.height += additionalInset
        scrollView.scrollRectToVisible(visibleRect, animated: false)
    }

    func keyboardWillHide(with notification: KeyboardNotification) {
        tapGestureRecognizer.isEnabled = false
        scrollView.delaysContentTouches = false
        isKeyboardShown = false

        if scrollView.contentInset.bottom > 0 {
            scrollView.contentInset.bottom = 0
            scrollView.verticalScrollIndicatorInsets.bottom = 0
        }
    }
}

extension BaseAuthViewController: NavigationBarAppearanceContainer {

    var navigationBarAppearance: NavigationBarAppearance {
        return .initial()
    }
}
