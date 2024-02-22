//
//  Dependencies.swift
//  Config
//
//  Created by jiyeon on 12/26/23.
//

import ProjectDescription

let spm = SwiftPackageManagerDependencies([
    .remote(url: "https://github.com/SnapKit/SnapKit.git", requirement: .upToNextMinor(from: "5.0.1"))
],
                                          productTypes: ["SnapKit": .framework]
)

let dependencies = Dependencies(
    swiftPackageManager: spm,
    platforms: [.iOS]
)
