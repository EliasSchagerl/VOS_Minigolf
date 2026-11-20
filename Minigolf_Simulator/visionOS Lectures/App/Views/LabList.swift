//
//  LabList.swift
//  visionOS Lectures
//
//  Created by Tempuno e.U. on 20.10.25.
//

import SwiftUI

struct LabList: View {
    @Environment(ModelData.self) var modelData

    var body: some View {
        List {
            Section(header: Text("Minigolf")) {
                ForEach(modelData.labData) { lab in
                    NavigationLink {
                        LabDetail(lab: lab)
                    } label: {
                        LabListRow(lab: lab)
                    }
                }
            }
        }
    }
}

#Preview {
    let modelData = ModelData()
    return LabList()
        .environment(modelData)
}
