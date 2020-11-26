//
//  Created by Alexander Kireev on 21/10/2020
//  Copyright © 2020 Ronas IT. All rights reserved.
//

import UIKit

protocol MainCoordinatorOutput: CoordinatorOutput {}

final class MainCoordinator: Coordinator<TabBarController>, UITabBarControllerDelegate {

    typealias Dependencies = Any

    private let dependencies: Dependencies

    private weak var mainOutput: MainCoordinatorOutput?
    override weak var output: CoordinatorOutput? {
        get {
            return mainOutput
        }
        set {
            guard let mainOutput = newValue as? MainCoordinatorOutput else {
                fatalError("Incorrect output type")
            }
            self.mainOutput = mainOutput
        }
    }

    private weak var homeNavigationController: NavigationController?
    private weak var newConsultationNavigationController: NavigationController?
    private weak var settingsNavigationController: NavigationController?

    private weak var consultationUploadFilesModuleInput: ConsultationUploadFilesModuleInput?

    private var createdConsultationParameters = CreatedConsultationParameters()

    // MARK: -  Lifecycle

    init(rootViewController: TabBarController? = nil, dependencies: Dependencies = [Any]()) {
        let rootViewController = rootViewController ?? TabBarController()
        self.dependencies = dependencies
        super.init(rootViewController: rootViewController)
    }

    func start(from navigationController: UINavigationController, animated: Bool) {
        navigationController.setNavigationBarHidden(true, animated: false)
        rootViewController.delegate = self

        let actionTabViewController = ActionTabViewController()
        configureTabBarItem(
            for: actionTabViewController,
            image: Asset.icNewAction.image
        )

        configureHomeTab()
        configureSettingsTab()

        let viewControllers = [
            homeNavigationController,
            actionTabViewController,
            settingsNavigationController
        ]
        rootViewController.setViewControllers(viewControllers.compactMap { $0 }, animated: animated)
        rootViewController.selectedIndex = 0

        navigationController.setViewControllers([rootViewController], animated: animated)
    }

    override func startModally(from viewController: UIViewController? = nil, animated: Bool) {
        super.startModally(from: viewController, animated: animated)
        // Modal presentation logic...
    }

    override func close(animated: Bool) {
        super.close(animated: animated)
        output?.childCoordinatorDidClose(self)
    }

    // MARK: -  UITabBarControllerDelegate

    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {

        guard viewController.isKind(of: ActionTabViewController.self) else {
            return true
        }

        configureNewConsultationNavigationController()
        createdConsultationParameters = CreatedConsultationParameters()

        rootViewController.present(newConsultationNavigationController!, animated: true, completion: nil)
        return false
    }

    // MARK: -  Private

    private func configureHomeTab() {
        let homeModule = HomeModule()
        let homeNavigationController = NavigationController(rootViewController: homeModule.viewController)
        self.homeNavigationController = homeNavigationController
        configureTabBarItem(
            for: homeNavigationController,
            image: Asset.icHome.image,
            selectedImageColor: .cyprus,
            title: L10n.home
        )
    }

    private func configureSettingsTab() {
        let settingsModule = SettingsModule()
        let settingsNavigationController = NavigationController(rootViewController: settingsModule.viewController)
        self.settingsNavigationController = settingsNavigationController
        configureTabBarItem(
            for: settingsNavigationController,
            image: Asset.icSettings.image,
            selectedImageColor: .cyprus,
            title: L10n.settings
        )
    }

    private func configureNewConsultationNavigationController() {
        let newConsultationModule = NewConsultationModule()
        newConsultationModule.output = self
        let newConsultationNavigationController = NavigationController(rootViewController: newConsultationModule.viewController)
        self.newConsultationNavigationController = newConsultationNavigationController
    }

    private func configureTabBarItem(for navigationController: UIViewController,
                                     image: Image,
                                     selectedImageColor: UIColor? = nil,
                                     title: String? = nil) {
        guard let tabBarItem = navigationController.tabBarItem else {
            return
        }

        tabBarItem.image = image.withRenderingMode(.alwaysOriginal)

        if let selectedImageColor = selectedImageColor {
            let selectedImage = image.with(color: selectedImageColor)
            tabBarItem.selectedImage = selectedImage.withRenderingMode(.alwaysOriginal)
        }

        if let title = title {
            tabBarItem.title = title
        }
    }

    private func startPickerCoordinator(with source: PickerSource) {
        guard let newConsultationNavigationController = newConsultationNavigationController else {
            return
        }

        let coordinator = PickerCoordinator(rootViewController: newConsultationNavigationController, source: source)
        coordinator.output = self
        coordinator.start(animated: true)
        append(childCoordinator: coordinator)
    }

    private func finishImagePickerCoordinator(_ coordinator: PickerCoordinator) {
        guard let newConsultationNavigationController = newConsultationNavigationController else {
            return
        }

        childCoordinatorDidClose(coordinator)
        newConsultationNavigationController.dismiss(animated: true)
    }
}

// MARK: -  NewConsultationModuleOutput

extension MainCoordinator: NewConsultationModuleOutput {

    func newConsultationModuleDidComplete(_ moduleInput: NewConsultationModuleInput,
                                          withConsultationName name: String,
                                          andDescription description: String) {
        createdConsultationParameters.consultationName = name
        createdConsultationParameters.consultationDescription = description
        let module = ConsultationChooseTagsModule()
        module.output = self
        newConsultationNavigationController?.pushViewController(module.viewController, animated: true)
    }

    func newConsultationModuleDidCancel(_ moduleInput: NewConsultationModuleInput) {
        rootViewController.dismiss(animated: true)
    }
}

// MARK: -  ConsultationChooseTagsModuleOutput

extension MainCoordinator: ConsultationChooseTagsModuleOutput {

    func consultationChooseTagsModuleDidComplete(_ moduleInput: ConsultationChooseTagsModuleInput, withSelectedTags selectedTags: [UInt]) {
        createdConsultationParameters.selectedTagsID = selectedTags
        let module = ConsultationUploadFilesModule(state: ConsultationUploadFilesState(createdConsultationParameters: createdConsultationParameters))
        module.output = self
        consultationUploadFilesModuleInput = module.input
        newConsultationNavigationController?.pushViewController(module.viewController, animated: true)
    }

    func consultationChooseTagsModuleDidCancel(_ moduleInput: ConsultationChooseTagsModuleInput) {
        rootViewController.dismiss(animated: true)
    }
}

// MARK: -  ConsultationUploadFilesModuleOutput

extension MainCoordinator: ConsultationUploadFilesModuleOutput {

    func consultationUploadFilesModuleDidComplete(_ moduleInput: ConsultationUploadFilesModuleInput) {
        // TODO: create next action
        print("Consultation created!")
    }

    func consultationUploadFilesModule(_ moduleInput: ConsultationUploadFilesModuleInput, didFailWith error: Error) {
        presentErrorAlert(for: error)
    }

    func consultationUploadFilesModuleDidCancel(_ moduleInput: ConsultationUploadFilesModuleInput) {
        rootViewController.dismiss(animated: true)
    }

    func consultationUploadFilesModuleShowActionSheet(_ moduleInput: ConsultationUploadFilesModuleInput) {
        let openCameraAction = UIAlertAction(title: "Open CAMerA", style: .default) { [unowned self] _ in
            self.startPickerCoordinator(with: .camera(.rear))
        }
        let openGalleryAction = UIAlertAction(title: "Open GallerY!", style: .default) { [unowned self] _ in
            self.startPickerCoordinator(with: .photoLibrary)
        }
        let cancelAction = UIAlertAction(title: "CanCEL", style: .cancel)
        presentAlert(
            withTitle: "Title",
            message: "Message",
            style: .actionSheet,
            actions: [openCameraAction, openGalleryAction, cancelAction]
        )
    }
}

// MARK: -  PickerCoordinatorOutput

extension MainCoordinator: PickerCoordinatorOutput {
    func imagePickerCoordinatorDidCancel(_ coordinator: PickerCoordinator) {
        finishImagePickerCoordinator(coordinator)
    }

    func imagePickerCoordinator(_ coordinator: PickerCoordinator, didFinishWith image: UIImage) {
        consultationUploadFilesModuleInput?.update(withSeletedImage: image)
        finishImagePickerCoordinator(coordinator)
    }

}
