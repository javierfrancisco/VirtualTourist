//
//  GCDBlackBox.swift
//  VirtualTourist
//
//  Created by zenkiu on 2/12/17.
//  Copyright © 2017 zenkiu. All rights reserved.
//

import Foundation

func performUIUpdatesOnMain(_ updates: @escaping () -> Void) {
    DispatchQueue.main.async {
        updates()
    }
}
