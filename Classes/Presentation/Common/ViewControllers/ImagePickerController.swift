//
//  Created by Dmitry Frishbuter on 01.05.2020
//  Copyright © 2020 98 Training Pty Limited. All rights reserved.
//

import UIKit

final class ImagePickerController: UIImagePickerController {

    var completionHandler: (([InfoKey: Any]) -> Void)?
    var cancellationHandler: (() -> Void)?

    override var delegate: (UIImagePickerControllerDelegate & UINavigationControllerDelegate)? {
        get {
            return super.delegate
        }
        set(newDelegate) {
            guard let newDelegate = newDelegate, newDelegate is ImagePickerController else {
                fatalError("Please use handlers instead of delegate")
            }
            super.delegate = newDelegate
        }
    }

    // MARK: - Lifecycle

    override init(navigationBarClass: AnyClass? = nil, toolbarClass: AnyClass? = nil) {
        super.init(navigationBarClass: navigationBarClass, toolbarClass: toolbarClass)
        initialize()
    }

    override init(nibName nibNameOrNil: String? = nil, bundle nibBundleOrNil: Bundle? = nil) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        initialize()
    }

    override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
        initialize()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }

    // MARK: - Private

    private func initialize() {
        delegate = self
    }
}

// MARK: - UIImagePickerControllerDelegate, UINavigationControllerDelegate

extension ImagePickerController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [InfoKey: Any]) {
        completionHandler?(info)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        cancellationHandler?()
    }
}
