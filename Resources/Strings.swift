// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
internal enum L10n {
  /// Add File
  internal static let addFile = L10n.tr("Localizable", "add_file")
  /// Cancel
  internal static let cancel = L10n.tr("Localizable", "cancel")
  /// Confirm
  internal static let confirm = L10n.tr("Localizable", "confirm")
  /// Home
  internal static let home = L10n.tr("Localizable", "home")
  /// Log In
  internal static let logIn = L10n.tr("Localizable", "log_in")
  /// Next
  internal static let next = L10n.tr("Localizable", "next")
  /// Ok
  internal static let ok = L10n.tr("Localizable", "ok")
  /// Settings
  internal static let settings = L10n.tr("Localizable", "settings")
  /// Sign Up
  internal static let signUp = L10n.tr("Localizable", "sign_up")
  /// Skip
  internal static let skip = L10n.tr("Localizable", "skip")

  internal enum Alert {
    internal enum RecoveryLinkSent {
      /// We sent a recovery link to: %@
      internal static func message(_ p1: Any) -> String {
        return L10n.tr("Localizable", "alert.recovery_link_sent.message", String(describing: p1))
      }
      /// Recovery link has been sent
      internal static let title = L10n.tr("Localizable", "alert.recovery_link_sent.title")
      internal enum Action {
        /// Check Inbox
        internal static let checkInbox = L10n.tr("Localizable", "alert.recovery_link_sent.action.check_inbox")
        /// Log In
        internal static let logIn = L10n.tr("Localizable", "alert.recovery_link_sent.action.log_In")
      }
    }
    internal enum RestorePasswordSuccess {
      /// A new password was created successfully
      internal static let message = L10n.tr("Localizable", "alert.restore_password_success.message")
      /// Success
      internal static let title = L10n.tr("Localizable", "alert.restore_password_success.title")
      internal enum Action {
        /// Continue
        internal static let `continue` = L10n.tr("Localizable", "alert.restore_password_success.action.continue")
      }
    }
  }

  internal enum EmailEditing {
    internal enum EmailInput {
      /// Enter email address
      internal static let placeholder = L10n.tr("Localizable", "email_editing.email_input.placeholder")
      /// Email
      internal static let title = L10n.tr("Localizable", "email_editing.email_input.title")
    }
  }

  internal enum Error {
    /// Authorization failed
    internal static let authorizationFailed = L10n.tr("Localizable", "error.authorizationFailed")
    /// Invalid image
    internal static let invalidImage = L10n.tr("Localizable", "error.invalid_image")
    /// Server error occurred. Please try again later
    internal static let serverError = L10n.tr("Localizable", "error.server_error")
    /// Something went wrong
    internal static let unknown = L10n.tr("Localizable", "error.unknown")
  }

  internal enum ImagePicker {
    /// Please allow camera usage
    internal static let noCameraAccess = L10n.tr("Localizable", "image_picker.no_camera_access")
    /// Please allow photo library usage
    internal static let noPhotoLibraryAccess = L10n.tr("Localizable", "image_picker.no_photo_library_access")
    /// Open Settings
    internal static let openSettings = L10n.tr("Localizable", "image_picker.open_settings")
    internal enum ActionSheet {
      /// Take a photo
      internal static let camera = L10n.tr("Localizable", "image_picker.action_sheet.camera")
      /// Take a new photo
      internal static let cameraChange = L10n.tr("Localizable", "image_picker.action_sheet.camera_change")
      /// Select a photo
      internal static let photoLibrary = L10n.tr("Localizable", "image_picker.action_sheet.photo_library")
      /// Select a new photo
      internal static let photoLibraryChange = L10n.tr("Localizable", "image_picker.action_sheet.photo_library_change")
      /// Remove photo
      internal static let removePhoto = L10n.tr("Localizable", "image_picker.action_sheet.remove_photo")
    }
  }

  internal enum LoginModule {
    /// Login to\nYour Account
    internal static let loginTitle = L10n.tr("Localizable", "login_module.login_title")
  }

  internal enum NewConsultation {
    /// Add Consultation
    internal static let addConsultation = L10n.tr("Localizable", "new_consultation.add_consultation")
    internal enum ChooseTags {
      /// Choose Tags
      internal static let title = L10n.tr("Localizable", "new_consultation.choose_tags.title")
    }
    internal enum ConsultationName {
      /// What's bothering you
      internal static let placeholder = L10n.tr("Localizable", "new_consultation.consultation_name.placeholder")
      /// Consultation Name
      internal static let title = L10n.tr("Localizable", "new_consultation.consultation_name.title")
    }
    internal enum Description {
      /// Describe in detail what is bothering you
      internal static let placeholder = L10n.tr("Localizable", "new_consultation.description.placeholder")
      /// Description
      internal static let title = L10n.tr("Localizable", "new_consultation.description.title")
    }
    internal enum UploadFiles {
      /// You can upload your \ndocuments later
      internal static let subtitle = L10n.tr("Localizable", "new_consultation.upload_files.subtitle")
      /// Upload Files
      internal static let title = L10n.tr("Localizable", "new_consultation.upload_files.title")
    }
  }

  internal enum PasswordCreation {
    /// Create Password
    internal static let mainTitle = L10n.tr("Localizable", "password_creation.main_title")
    internal enum Action {
      /// Create New Password
      internal static let createNewPassword = L10n.tr("Localizable", "password_creation.action.create_new_password")
    }
    internal enum ConfirmNewPasswordEnter {
      /// Confirm new password
      internal static let placeholder = L10n.tr("Localizable", "password_creation.confirm_new_password_enter.placeholder")
    }
    internal enum ConfirmNewPasswordInput {
      /// Confirm New Password
      internal static let title = L10n.tr("Localizable", "password_creation.confirm_new_password_input.title")
    }
    internal enum CreateNewPasswordEnter {
      /// Create new password
      internal static let placeholder = L10n.tr("Localizable", "password_creation.create_new_password_enter.placeholder")
    }
    internal enum CreateNewPasswordInput {
      /// New Password
      internal static let title = L10n.tr("Localizable", "password_creation.create_new_password_input.title")
    }
  }

  internal enum PasswordEditing {
    internal enum PasswordCreate {
      /// Create password
      internal static let placholder = L10n.tr("Localizable", "password_editing.password_create.placholder")
    }
    internal enum PasswordEnter {
      /// Enter password
      internal static let placholder = L10n.tr("Localizable", "password_editing.password_enter.placholder")
    }
    internal enum PasswordForgot {
      /// Forgot your password?
      internal static let title = L10n.tr("Localizable", "password_editing.password_forgot.title")
    }
    internal enum PasswordInput {
      /// Password
      internal static let title = L10n.tr("Localizable", "password_editing.password_input.title")
    }
    internal enum PasswordReset {
      /// We will send information about password recovery to the specified email address
      internal static let detail = L10n.tr("Localizable", "password_editing.password_reset.detail")
      /// Reset Password
      internal static let title = L10n.tr("Localizable", "password_editing.password_reset.title")
    }
  }

  internal enum PersonalInformationEditing {
    internal enum FirstNameInput {
      /// Enter your first name
      internal static let placeholder = L10n.tr("Localizable", "personal_information_editing.first_name_input.placeholder")
      /// First name
      internal static let title = L10n.tr("Localizable", "personal_information_editing.first_name_input.title")
    }
    internal enum LastNameInput {
      /// Enter your last name
      internal static let placeholder = L10n.tr("Localizable", "personal_information_editing.last_name_input.placeholder")
      /// Last name
      internal static let title = L10n.tr("Localizable", "personal_information_editing.last_name_input.title")
    }
  }

  internal enum SignUp {
    /// By continuing, you agree to Secon Opinion’s
    internal static let agreementTitle = L10n.tr("Localizable", "sign_up.agreement_title")
    /// Let’s Get Started
    internal static let mainTitle = L10n.tr("Localizable", "sign_up.main_title")
    internal enum Action {
      /// Create Account
      internal static let createAccount = L10n.tr("Localizable", "sign_up.action.create_account")
      /// Terms & Conditions
      internal static let termsAndCondition = L10n.tr("Localizable", "sign_up.action.terms_and_condition")
    }
  }

  internal enum WelcomeModule {
    /// Welcome to\nSecond Opinion
    internal static let mainTitle = L10n.tr("Localizable", "welcome_module.main_title")
    /// Trust doctors, not the Internet
    internal static let subtitle = L10n.tr("Localizable", "welcome_module.subtitle")
  }
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name vertical_whitespace_opening_braces

// MARK: - Implementation Details

extension L10n {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg...) -> String {
    let format = BundleToken.bundle.localizedString(forKey: key, value: nil, table: table)
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

// swiftlint:disable convenience_type
private final class BundleToken {
  static let bundle = Bundle(for: BundleToken.self)
}
// swiftlint:enable convenience_type
