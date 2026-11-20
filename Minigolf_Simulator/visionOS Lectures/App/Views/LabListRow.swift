//
//  LabListRow.swift
//  visionOS Lectures
//
//  Created by Tempuno e.U. on 20.10.25.
//

import SwiftUI

struct LabListRow: View {
    var lab: Lab

    var body: some View {
        HStack {
            Text("\(lab.title) - \(lab.subtitle)")
            Spacer()
            if(lab.success == false) {
                Image(systemName: "x.circle.fill")
                    .foregroundColor(.red)
                    .padding(4)
            }
            switch lab.type {
            case .WINDOW, .WINDOW_ALT:
                Image(systemName: "macwindow")
            case .VOLUME:
                Image(systemName: "cube.transparent")
            case .SPACE:
                Image(systemName: "visionpro.fill")
            case .SPACE_FULL:
                Image(systemName: "visionpro.fill")
            }

        }
    }
}

#Preview {
    let modelData = ModelData()
    let length = modelData.labData.count
    return LabListRow(lab: modelData.labData[length - 1])
}
