import SwiftUI
import shared

@MainActor class ViewModel: ObservableObject {
    let api: ApiClass
    
    @Published var coffeeShopList: [CoffeeShop] = []
    
    init(api: ApiClass) {
        self.api = api
    }
    
    func loadCoffeeShops() async {
        do {
            self.coffeeShopList = try await api.getData()
        } catch {
            print(error)
        }
    }
}

struct ContentView: View {
    @StateObject var viewModel = ViewModel(api: ApiClass())
    
    var body: some View {
        ForEach(self.viewModel.coffeeShopList, id: \.name) { coffeeShop in
            VStack {
                Text("\(coffeeShop.id)")
                Text(coffeeShop.name)
                Text(coffeeShop.x + " " + coffeeShop.y)
            }.padding(.bottom, 10)
        }.onAppear {
            Task {
                await self.viewModel.loadCoffeeShops()
            }
        }
    }
}
