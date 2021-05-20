//
//  ContentView.swift
//  StormViewer SwiftUI
//
//  Created by Monique Shaqiri on 14.05.21.
//  Copyright © 2021 Monique Shaqiri. All rights reserved.

//


import Combine
import SwiftUI

class DataSource: ObservableObject {
    
    @Published var pictures = [String]()
    
    init() {
        let fm = FileManager.default
        if let path = Bundle.main.resourcePath, let items = try? fm.contentsOfDirectory(atPath: path)
        {
            for item in items {
                if item.hasPrefix("nssl") {
                    pictures.append(item)
                }
            }
            pictures.sort() // Sorts them alphabetically - not in original tutorial, my addition
        }
    }
}

struct ImageDetailView: View {
    
    // Here is the view that will be shown when we click on the name of the file in the List
  
    @State private var hidesNavigationBar  = false
    
    var selectedImage: String // This is the name of the file which was clicked on on the List
    
    var body: some View {

        // It would be nice if we could do the following:
        
        // Image(selectedImage)
        
        // which would allow us to avoid using the return keyword as it's a single line function.
        
        // but this won't work because Swift UI searches for the file name in the Assets Catalog and not in the bundle. THIS IS A BUG.
        
        // Instead we have to force unwrap and use an UIImage
        let img = UIImage(named: selectedImage)! // Force unwrap
        return Image(uiImage: img)
            .resizable()
            .aspectRatio(1024/768, contentMode: .fit)
            .navigationBarTitle(Text(selectedImage), displayMode: .inline)
            .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous)) // Not in Tutorial - my addition
            .padding() // Not in Tutorial - my addition
            .navigationBarHidden(hidesNavigationBar)
            .onTapGesture {
                
                // Since Swift UI is DECLARATIVE, we change the state of the hidesNavigationBar
                // and since we've declared it using @State, the system automatically updates the UI
                // when this variable changes.
                
                self.hidesNavigationBar.toggle()
        }
    }
}

struct ContentView: View {
    
    @ObservedObject var dataSource = DataSource()
    
    var body: some View {
        NavigationView
            {
                // the id tells the list how to identify each object coming from the datasource
                // so that it can individually identify items.
                
                // When you pass an array to the list, it will create many items in the table view (list)
                
                // What it needs to know is which is which - because they are being made dynamically!
                // It needs to know how to identify each picture cell individually in the main collection.
                
                // You could make your datasource conform to identifiable
                // or for each picture, identify it by itself - use the file name as the identifier!
                
                // So the NAME becomes the unique identifier
                
                
                List(dataSource.pictures, id: \.self) {picture in
                    NavigationLink(destination: ImageDetailView(selectedImage: picture)) {Text(picture) }
                }
                .navigationBarTitle(Text("Storm Viewer"))
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
