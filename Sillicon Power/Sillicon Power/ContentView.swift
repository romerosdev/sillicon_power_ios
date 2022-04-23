////////////////////////////////////////////////////////////////////////////
//
// Copyright 2022. All rights reserved.
//
// Author: Raul Romero (raulromerodev@gmail.com)
//
// For the full copyright and license information, please view the LICENSE
// file that was distributed with this source code.
//
////////////////////////////////////////////////////////////////////////////

import SwiftUI

struct ContentView: View {
    
    @StateObject var vm: MovieViewModelImpl

    init() {
      _vm = StateObject(wrappedValue: MovieViewModelImpl(service: MovieServiceImpl()))
    }
    
    var body: some View {
        Group {
            Text("Hello, world!")
                .padding()
        }
        .onAppear {
            Task {
                await vm.getMovies()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
