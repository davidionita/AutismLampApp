//
//  HostingController.swift
//  WatchAutismLampApp Extension
//
//  Created by David Ionita on 3/12/20.
//  Copyright © 2020 David Ionita. All rights reserved.
//

import WatchKit
import Foundation
import SwiftUI

class HostingController: WKHostingController<ContentView> {
    override var body: ContentView {
        return ContentView(ble: BLEManager())
    }
}
