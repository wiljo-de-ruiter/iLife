//
//  SideMenu.swift
//  iLife
//
//  Created by Wiljo de Ruiter on 2023-01-15.
//

import SwiftUI

struct SideMenuView: View {
    @State var onMenuClose: () -> Void
    @State var onObjectSelected: ( String ) -> Void
    @State var screenWidth = UIScreen.main.bounds.size.width

    var body: some View {
//        ZStack {
//            GeometryReader { _ in
//                EmptyView()
//            }
//            .background( Color.gray.opacity( 0.3 ))
//            .onTapGesture {
//                self.onMenuClose()
//            }
//        }
        HStack {
            List {
                ForEach( LifeObjects.objects.sorted(by: <), id: \.key ) { key, value in
                    Button( key ) {
                        onObjectSelected( key )
                        onMenuClose()
                    }
                }
            }
            .frame( width: screenWidth * 0.6 )
            .offset( x: -screenWidth * 0.2 )
        }
    }
}

