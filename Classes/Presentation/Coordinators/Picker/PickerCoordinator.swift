//
//  Created by Dmitry Frishbuter on 01.05.2020
//  Copyright © 2020 98 Training Pty Limited. All rights reserved.
//

import UIKit
import Photos

enum PickerSource {
    case photoLibrary
    case camera(UIImagePickerController.CameraDevice)
}

protocol PickerCoordinatorOutput: CoordinatorOutput {
    func imagePickerCoordinatorDidCancel(_ coordinator: PickerCoordinator)
    func imagePickerCoordinator(_ coordinator: PickerCoordinator, didFinishWith image: UIImage)
}

final class PickerCoordinator: Coordinator<UIViewController> {

    private weak var pickerOutput: PickerCoordinatorOutput?
    override weak var output: CoordinatorOutput? {
        get {
            return pickerOutput
        }
        set {
            guard let pickerOutput = newValue as? PickerCoordinatorOutput else {
                fatalError("Incorrect output type")
            }
            self.pickerOutput = pickerOutput
        }
    }

    private var source: PickerSource
    let allowsEditing: Bool

    // MARK: -  Lifecycle

    init(rootViewController: UIViewController, source: PickerSource, allowsEditing: Bool = true) {
        self.allowsEditing = allowsEditing
        self.source = source
        super.init(rootViewController: rootViewController)
    }

    override func start(animated: Bool) {
        requestPermissions { [weak self] isGranted in
            guard let self = self, isGranted else {
                return
            }
            switch self.source {
            case .photoLibrary, .camera:
                self.presentImagePickerController(animated: animated)
            }
        }
    }

    // MARK: -  Private

    private func requestPermissions(completion: @escaping (Bool) -> Void) {
        switch source {
        case .photoLibrary:
            requestPhotoLibraryPermission(completion: completion)
        case .camera:
            requestCameraPermission(completion: completion)
        }
    }

    private func requestPhotoLibraryPermission(completion: @escaping (Bool) -> Void) {
        switch PHPhotoLibrary.authorizationStatus() {
        case .authorized:
            completion(true)
        case .denied, .restricted:
            showPermissionRestrictedAlert()
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization { status in
                DispatchQueue.main.async {
                    completion(status == .authorized)
                }
            }
        default: return
        }
    }

    private func requestCameraPermission(completion: @escaping (Bool) -> Void) {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            completion(true)
        case .denied, .restricted:
            showPermissionRestrictedAlert()
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { isGranted in
                DispatchQueue.main.async {
                    completion(isGranted)
                }
            }
        @unknown default:
            return
        }
    }

    private func presentImagePickerController(animated: Bool) {
        let controller = ImagePickerController()
        controller.allowsEditing = allowsEditing
        controller.cancellationHandler = { [weak self] in
            guard let self = self else {
                return
            }
            self.pickerOutput?.imagePickerCoordinatorDidCancel(self)
        }
        controller.completionHandler = { [weak self] info in
            self?.processMediaPickingInfo(info)
        }

        switch source {
        case .camera(let cameraDevice):
            controller.sourceType = .camera
            controller.cameraDevice = cameraDevice
        case .photoLibrary:
            controller.sourceType = .photoLibrary
        }
        rootViewController.present(controller, animated: true)
    }

    private func showPermissionRestrictedAlert() {
        let settingsAction = UIAlertAction(title: L10n.ImagePicker.openSettings, style: .default) { _ in
            guard let url = URL(string: UIApplication.openSettingsURLString) else {
                return
            }
            UIApplication.shared.open(url)
            self.pickerOutput?.imagePickerCoordinatorDidCancel(self)
        }
        let cancelAction = UIAlertAction(title: L10n.cancel, style: .cancel) { _ in
            self.pickerOutput?.imagePickerCoordinatorDidCancel(self)
        }

        var message = ""
        switch source {
        case .photoLibrary:
            message = L10n.ImagePicker.noPhotoLibraryAccess
        case .camera:
            message = L10n.ImagePicker.noCameraAccess
        }

        presentAlert(message: message, style: .alert, actions: [settingsAction, cancelAction], animated: true)
    }

    private func processMediaPickingInfo(_ info: [UIImagePickerController.InfoKey: Any]) {
        guard let image = info[allowsEditing ? .editedImage : .originalImage] as? UIImage else {
            return
        }
        pickerOutput?.imagePickerCoordinator(self, didFinishWith: image)
    }
}
