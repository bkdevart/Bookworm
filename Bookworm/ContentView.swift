//
//  ContentView.swift
//  Bookworm
//
//  Created by Brandon Knox on 4/20/21.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        Text("Hello World")
            .onTapGesture {
                self.presentationMode.wrappedValue.dismiss()
            }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
