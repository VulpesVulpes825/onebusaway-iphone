//
//  AlertPresenter.swift
//  org.onebusaway.iphone
//
//  Created by Aaron Brethorst on 8/28/16.
//  Copyright © 2016 OneBusAway. All rights reserved.
//

import OBAKit
import UIKit
import SwiftMessages

@objc open class AlertPresenter: NSObject {

    /// Displays an alert on screen at the status bar level indicating a successful operation.
    ///
    /// - parameter title: The title of the alert
    /// - parameter body:  The body of the alert
    open class func showSuccess(_ title: String, body: String) {
        self.showMessage(withTheme: .success, title: title, body: body)
    }

    /// Displays an alert on screen at the status bar level indicating an unsuccessful operation.
    ///
    /// - parameter title: The title of the alert
    /// - parameter body:  The body of the alert
    open class func showWarning(_ title: String, body: String) {
        self.showMessage(withTheme: .warning, title: title, body: body)
    }
    
    /// Displays an alert on screen at the status bar level indicating an error.
    ///
    /// - parameter title: The title of the alert
    /// - parameter body:  The body of the alert
    open class func showError(_ title: String, body: String) {
        self.showMessage(withTheme: .error, title: title, body: body)
    }

    /// Displays an error alert on screen generated from an error object.
    ///
    /// - Parameter error: The error object from which the alert is generated.
    open class func showError(_ error: NSError) {
        var errorBody: String?

        if (error.domain == NSCocoaErrorDomain && error.code == 3840) {
            errorBody = NSLocalizedString("alert_presenter.captive_wifi_portal_error_message", comment: "Error message displayed when the user is connecting to a Wi-Fi captive portal landing page.")
        }
        else {
            errorBody = error.localizedDescription;
        }

        self.showError(OBAStrings.error(), body: errorBody!)
    }


    open class func showMessage(withTheme theme: Theme, title: String, body: String) {
        var config = SwiftMessages.Config()
        config.presentationContext = .window(windowLevel: UIWindowLevelStatusBar)
        config.duration = theme == .error ? .forever : .seconds(seconds: 5)
        config.dimMode = .gray(interactive: true)
        config.interactiveHide = true
        config.preferredStatusBarStyle = .lightContent

        // Instantiate a message view from the provided card view layout. SwiftMessages searches for nib
        // files in the main bundle first, so you can easily copy them into your project and make changes.
        let view = MessageView.viewFromNib(layout: .CardView)
        view.button?.isHidden = true
        view.configureTheme(theme)
        view.configureDropShadow()
        view.configureContent(title: title, body: body)

        // Show the message.
        SwiftMessages.show(config: config, view: view)
    }
}
