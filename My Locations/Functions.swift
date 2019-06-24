//
//  Functions.swift
//  My Locations
//
//  Created by demas on 24/06/2019.
//  Copyright © 2019 demas. All rights reserved.
//

import Foundation
import Dispatch

func afterDelay(_ seconds: Double, run: @escaping () -> Void) {
    DispatchQueue.main.asyncAfter(deadline: .now() + seconds, execute: run)
}
