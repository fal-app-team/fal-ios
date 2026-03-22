import SwiftUI

struct CoffeeDetailView: View {
    var body: some View {
        VStack {
            Text("Kahve Falı")
                .font(.largeTitle)
                .bold()

            Text("Burada kahve falı yorumlanacak.")
        }
        .navigationTitle("Kahve Falı")
        .navigationBarTitleDisplayMode(.inline)
    }
}
