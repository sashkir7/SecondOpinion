//
//  Created by Alexander Kireev on 21/10/2020
//  Copyright © 2020 Ronas IT. All rights reserved.
//

import UIKit

protocol NewConsultationModuleInput: class {
    var state: NewConsultationState { get }
    func update(animated: Bool)
}

protocol NewConsultationModuleOutput: class {
    func newConsultationModuleDidComplete(_ moduleInput: NewConsultationModuleInput, withConsultationName: String, andDescription: String)
    func newConsultationModuleDidCancel(_ moduleInput: NewConsultationModuleInput)
}

final class NewConsultationModule {

    var input: NewConsultationModuleInput {
        return presenter
    }
    weak var output: NewConsultationModuleOutput? {
        get {
            return presenter.output
        }
        set {
            presenter.output = newValue
        }
    }
    let viewController: NewConsultationViewController
    private let presenter: NewConsultationPresenter

    init(state: NewConsultationState = .init()) {
        let viewModel = NewConsultationViewModel(state: state)
        let presenter = NewConsultationPresenter(state: state, dependencies: ServiceContainer())
        let viewController = NewConsultationViewController(viewModel: viewModel, output: presenter)

        presenter.view = viewController
        self.viewController = viewController
        self.presenter = presenter
    }
}
