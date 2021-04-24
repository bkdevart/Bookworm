//
//  DetailView.swift
//  Bookworm
//
//  Created by Brandon Knox on 4/23/21.
//

import CoreData
import SwiftUI

struct DetailView: View {
    @Environment(\.managedObjectContext) var moc
    @Environment(\.presentationMode) var presentationMode
    @State private var showingDeleteAlert = false
    
    let book: Book
    
//    Add a new “date” attribute to the Book entity, assigning Date() to it so it gets the current date and time, then format that nicely somewhere in DetailView.
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                ZStack(alignment: .bottomTrailing) {
                    Image(self.book.genre ?? "Default")
                        .frame(maxWidth: geometry.size.width)
                    
                    Text(self.book.genre?.uppercased() ?? "DEFAULT")
                        .font(.caption)
                        .fontWeight(.black)
                        .padding(8)
                        .foregroundColor(.white)
                        .background(Color.black.opacity(0.75))
                        .clipShape(Capsule())
                        .offset(x: -5, y: -5)
                }
                
                Text(self.book.author ?? "Unknown author")
                    .font(.title)
                    .foregroundColor(.secondary)
                
                Text(self.book.review ?? "No review")
                    .padding()
                
                RatingView(rating: .constant(Int(self.book.rating)))
                    .font(.largeTitle)
                
                Text("Reviewed: \(getPublishDate())")
                    .padding()
                    .font(.footnote)
                Spacer()
            }
        }
        .navigationBarTitle(Text(book.title ?? "Unknown Book"))
        .alert(isPresented: $showingDeleteAlert) {
            Alert(title: Text("Delete book"), message: Text("Are you sure?"), primaryButton: .destructive(Text("Delete")) {
                self.deleteBook()
                }, secondaryButton: .cancel()
            )
        }
        .navigationBarItems(trailing: Button(action: {
            self.showingDeleteAlert = true
        }) {
            Image(systemName: "trash")
        })
    }
    
    func deleteBook() {
        moc.delete(book)
        
        // try? self.moc.save()
        
        presentationMode.wrappedValue.dismiss()
    }
    
    func getPublishDate() -> String {
        // create default date if not entered
        let components = DateComponents(calendar: Calendar.current, timeZone: TimeZone(abbreviation: "MST"), year: 1982, month: 3, day: 30)
        let defaultDate = components.date
        
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        let publishDate = (self.book.date ?? defaultDate)!
        return formatter.string(from: publishDate)
    }
}

struct DetailView_Previews: PreviewProvider {
    static let moc = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
    
    static var previews: some View {
        let book = Book(context: moc)
        book.title = "Test book"
        book.author = "Test author"
        book.genre = "Fantasy"
        book.rating = 4
        book.review = "This was a great book; I really enjoyed it."
//        book.date = Date()
        return NavigationView {
            DetailView(book: book)
        }
    }
}
