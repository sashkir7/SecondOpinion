//
//  Created by Alexander Kireev on 23/10/2020
//  Copyright © 2020 Ronas IT. All rights reserved.
//

import UIKit

protocol ConsultationChooseTagsModuleInput: class {
    var state: ConsultationChooseTagsState { get }
    func update(animated: Bool)
}

protocol ConsultationChooseTagsModuleOutput: class {
    func consultationChooseTagsModuleDidComplete(_ moduleInput: ConsultationChooseTagsModuleInput, withSelectedTags: [UInt])
    func consultationChooseTagsModuleDidCancel(_ moduleInput: ConsultationChooseTagsModuleInput)
}

final class ConsultationChooseTagsModule {

    var input: ConsultationChooseTagsModuleInput {
        return presenter
    }
    weak var output: ConsultationChooseTagsModuleOutput? {
        get {
            return presenter.output
        }
        set {
            presenter.output = newValue
        }
    }
    let viewController: ConsultationChooseTagsViewController
    private let presenter: ConsultationChooseTagsPresenter

    init(state: ConsultationChooseTagsState = .init()) {
        let viewModel = ConsultationChooseTagsViewModel(state: state)
        let presenter = ConsultationChooseTagsPresenter(state: state, dependencies: ServiceContainer())
        let viewController = ConsultationChooseTagsViewController(viewModel: viewModel, output: presenter)

        presenter.view = viewController
        self.viewController = viewController
        self.presenter = presenter
    }
}
