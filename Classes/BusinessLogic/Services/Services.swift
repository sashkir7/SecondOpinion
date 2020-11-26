//
//  Created by Dmitry Surkov on 05/10/2020
//  Copyright © 2020 Ronas IT. All rights reserved.
//

import Networking

typealias HasServices =
    HasProfileService &
    HasAuthService &
    HasSessionService &
    HasTagsService &
    HasConsultationService &
    HasMediaService

private typealias HasPersistentServices =
    HasProfileService &
    HasSessionService &
    HasConsultationService

// MARK: -  Singleton Services

private final class PersistentServiceContainer: HasPersistentServices {

    static var instance: PersistentServiceContainer = .init()

    private init() {}

    lazy var errorHandlingService: ErrorHandlingServiceProtocol = {
        let errorHandlers: [ErrorHandler] = [
            RequestErrorHandler(),
            UnauthorizedErrorHandler(accessTokenSupervisor: sessionService),
            GeneralErrorHandler()
        ]
        return ErrorHandlingService(errorHandlers: errorHandlers)
    }()

    lazy var sessionService: SessionServiceProtocol = SessionService(
        keychainService: ServiceContainer().keychainService
    )

    lazy var authService: AuthServiceProtocol = AuthService(
        sessionService: sessionService,
        requestAdaptingService: ServiceContainer().requestAdaptingService,
        errorHandlingService: errorHandlingService
    )

    lazy var profileService: ProfileServiceProtocol = {
        let container = ServiceContainer()
        let service = ProfileService(
            sessionService: sessionService,
            authService: container.authService,
            requestAdaptingService: container.requestAdaptingService,
            errorHandlingService: errorHandlingService
        )
        return service
    }()

    lazy var tagService: TagsServiceProtocol = TagsService(
        sessionService: sessionService,
        requestAdaptingService: ServiceContainer().requestAdaptingService,
        errorHandlingService: errorHandlingService
    )

    lazy var consultationService: ConsultationServiceProtocol = ConsultationService(
        sessionService: sessionService,
        requestAdaptingService: ServiceContainer().requestAdaptingService,
        errorHandlingService: errorHandlingService
    )

    lazy var mediaService: MediaServiceProtocol = MediaService(
        sessionService: sessionService,
        requestAdaptingService: ServiceContainer().requestAdaptingService,
        errorHandlingService: errorHandlingService
    )
}

// MARK: -  Regular Services

final class ServiceContainer: HasServices {

    var sessionService: SessionServiceProtocol {
        return PersistentServiceContainer.instance.sessionService
    }

    var authService: AuthServiceProtocol {
        return PersistentServiceContainer.instance.authService
    }

    var errorHandlingService: ErrorHandlingServiceProtocol {
        return PersistentServiceContainer.instance.errorHandlingService
    }

    var profileService: ProfileServiceProtocol {
        PersistentServiceContainer.instance.profileService
    }

    var tagsService: TagsServiceProtocol {
        return PersistentServiceContainer.instance.tagService
    }

    var consultationService: ConsultationServiceProtocol {
        return PersistentServiceContainer.instance.consultationService
    }

    var mediaService: MediaServiceProtocol {
        return PersistentServiceContainer.instance.mediaService
    }

    lazy var keychainService: KeychainServiceProtocol = KeychainService()

    lazy var requestAdaptingService: RequestAdaptingServiceProtocol = {
        let requestAdapters: [RequestAdapter] = [
            TokenRequestAdapter(accessTokenSupervisor: sessionService)
        ]
        return RequestAdaptingService(requestAdapters: requestAdapters)
    }()
}
