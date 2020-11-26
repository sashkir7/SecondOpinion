//
//  Created by Alexander Kireev on 21/10/2020
//  Copyright © 2020 Ronas IT. All rights reserved.
//

final class NewConsultationPresenter {

    typealias Dependencies = Any

    weak var view: NewConsultationViewInput?
    weak var output: NewConsultationModuleOutput?

    var state: NewConsultationState

    private let dependencies: Dependencies

    init(state: NewConsultationState, dependencies: Dependencies) {
        self.state = state
        self.dependencies = dependencies
    }

    private func validate() {
        state.isValid = !state.consultationName.isEmpty && !state.description.isEmpty
        update(animated: false)
    }
}

// MARK: -  NewConsultationViewOutput

extension NewConsultationPresenter: NewConsultationViewOutput {

    func viewDidLoad() {
        update(animated: false)
    }

    func consultationNameChanged(_ input: String) {
        state.consultationName = input
        validate()
    }

    func consultationDescriptionChanged(_ input: String) {
        state.description = input
        validate()
    }

    func closeActionTriggered() {
        output?.newConsultationModuleDidCancel(self)
    }

    func nextActionTriggered() {
        output?.newConsultationModuleDidComplete(
            self,
            withConsultationName: state.consultationName,
            andDescription: state.description
        )
    }
}

// MARK: -  NewConsultationModuleInput

extension NewConsultationPresenter: NewConsultationModuleInput {

    func update(animated: Bool) {
        let viewModel = NewConsultationViewModel(state: state)
        view?.update(with: viewModel, animated: animated)
    }
}
