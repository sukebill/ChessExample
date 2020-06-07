//
//  RoutingProtocol.swift
//  ChessMovement
//
//  Created by Vassilis Alexandrof on 7/6/20.
//  Copyright © 2020 VA. All rights reserved.
//

import UIKit

public protocol RouteProtocol {
    var viewController: UIViewController { get }
}

extension RouteProtocol {
    public typealias CallBack = () -> Void

    public func presentFrom(_ viewController: UIViewController, animated: Bool = true, completion: CallBack? = nil) {
        let vcToPresent = self.viewController
        if viewController.navigationController == nil {
            viewController.present(vcToPresent, animated: animated, completion: completion)
        } else {
            viewController.navigationController?.present(vcToPresent,
                                                         animated: animated,
                                                         completion: completion)
        }
    }

    public func pushFrom(_ viewController: UIViewController, animated: Bool = true) {
        viewController.navigationController?.pushViewController(self.viewController, animated: animated)
    }
}
