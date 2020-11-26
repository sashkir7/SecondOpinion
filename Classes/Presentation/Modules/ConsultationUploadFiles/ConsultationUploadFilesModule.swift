//
//  Created by Alexander Kireev on 25/10/2020
//  Copyright © 2020 Ronas IT. All rights reserved.
//

import UIKit

protocol ConsultationUploadFilesModuleInput: class {
    var state: ConsultationUploadFilesState { get }
    func update(withSeletedImage image: UIImage)
    func update(animated: Bool)
}

protocol ConsultationUploadFilesModuleOutput: class {
    func consultationUploadFilesModuleDidComplete(_ moduleInput: ConsultationUploadFilesModuleInput)
    func consultationUploadFilesModule(_ moduleInput: ConsultationUploadFilesModuleInput, didFailWith error: Error)
    func consultationUploadFilesModuleDidCancel(_ moduleInput: ConsultationUploadFilesModuleInput)
    func consultationUploadFilesModuleShowActionSheet(_ moduleInput: ConsultationUploadFilesModuleInput)
}

final class ConsultationUploadFilesModule {

    var input: ConsultationUploadFilesModuleInput {
        return presenter
    }
    weak var output: ConsultationUploadFilesModuleOutput? {
        get {
            return presenter.output
        }
        set {
            presenter.output = newValue
        }
    }
    let viewController: ConsultationUploadFilesViewController
    private let presenter: ConsultationUploadFilesPresenter

    init(state: ConsultationUploadFilesState = .init()) {
        let viewModel = ConsultationUploadFilesViewModel(state: state)
        let presenter = ConsultationUploadFilesPresenter(state: state, dependencies: ServiceContainer())
        let viewController = ConsultationUploadFilesViewController(viewModel: viewModel, output: presenter)

        presenter.view = viewController
        self.viewController = viewController
        self.presenter = presenter
    }
}
