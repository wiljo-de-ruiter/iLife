//
//  ContentView.swift
//  Life
//
//  Created by Wiljo de Ruiter on 2023-01-08.
//

import SwiftUI

enum ePlayState
{
    case Edit
    case Live
}

struct MenuButton: View {
    let systemImage: String
    let enabled: Bool
    let action: () -> Void
    
    var body: some View {
        Button( action: {
            action()
        }) {
            Image( systemName: systemImage )
        }
        .padding()
        .background( Color.gray )
        .disabled( !enabled )
        .opacity( enabled ? 1.0 : 0.5 )
    }
}

struct ButtonView: View {
    var mCaption: String
    var mImage = "hand.thumbsup.fill"
    var mAction: () -> Void
    
    var body: some View {
        Button( action: mAction ) {
            HStack {
                Text( mCaption )
                    .bold()
                    .font(.headline)
                Image( systemName: mImage )
                    .font(.headline)
            }
            .padding()
            .foregroundColor(.white)
            .background(
                LinearGradient(
                    gradient: Gradient( colors: [Color.blue, Color.red]),
                    startPoint: .top, endPoint: .bottom))
            .cornerRadius(30)
        }
    }
}

struct ContentView: View {
    @State private var mField = Playfield( rows: 31, cols: 21 )
    @State private var mState = ePlayState.Edit
    @State private var isMenuOpen = false
    @State private var showAlert = false
    @State private var mo_GenerationTimer: Timer?
    
    var body: some View {
        ZStack {
            VStack( spacing: 0 ) {
                HStack {
                    Text( "Cell Count = \(mField.mCellCount)" )
                    Spacer()
                    Text( "Generation: \(mField.mGeneration)" )
                }
                .foregroundColor(.white)
                
                ForEach( 0 ..< mField.mcRows, id: \.self ) { row in
                    HStack( spacing: 0 ) {
                        ForEach( 0 ..< mField.mcCols, id: \.self ) { col in
                            Button( action: {
                                if mState == ePlayState.Edit {
                                    mField.mStart.mRow = row
                                    mField.mStart.mCol = col
                                    mField[ row, col ].mbCell.toggle()
                                    mField.mUpdateCellCount()
                                }
                            }) {
                                Image( systemName: mField[ row, col ].mbCell ? "circle.fill" : "circle" )
                                    .foregroundColor( mState == .Edit
                                                      && mField.mStart.mRow == row
                                                      && mField.mStart.mCol == col
                                                      ? Color.yellow
                                                      : ( mField[ row, col ].mbCell ? Color.green : Color.brown ))
                                    .font( .caption2 )
                            }
                        }
                    }
                }
            
                HStack {
                    MenuButton( systemImage: "tray.fill", enabled: mState == .Edit ) {
                        withAnimation() {
                            self.isMenuOpen = true
                        }
                    }

                    MenuButton( systemImage: "stop.fill", enabled: mState == .Edit ) {
                        mField.mClear()
                    }
                    
                    MenuButton( systemImage: "pause.fill", enabled: mState == .Live ) {
                        mStopGame()
                    }
                    
                    MenuButton( systemImage: "forward.end.fill", enabled: mState == .Edit && mField.mCellCount > 0 ) {
                        mStartGame()
                    }
                }
                .padding()
                .foregroundColor(.white)
            }
            .alert( isPresented: $showAlert ) {
                Alert( title: Text( "The game of life" ),
                       message: Text( "The game has stopped!" ),
                       dismissButton: .default( Text( "OK" )))
            }
            
            SideMenuView( isMenuOpen: self.isMenuOpen, onMenuClose: {
                withAnimation() {
                    self.isMenuOpen.toggle()
                }
            }, onObjectSelected: { acName in
                mField.mStart = mField.mSetObject( at: mField.mStart, LifeObjects.objects[ acName ] )
                mField.mStart.mSetNextRow( rows: mField.mcRows )
            })
        }
        .onAppear {
            UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation") // Forcing the rotation to portrait
            AppDelegate.orientationLock = .portrait // And making sure it stays that way
        }.onDisappear {
            AppDelegate.orientationLock = .all // Unlocking the rotation when leaving the view
        }
    }
    
    func mStartGame()
    {
        mState = ePlayState.Live
        self.mo_GenerationTimer = Timer.scheduledTimer( withTimeInterval: 0.1, repeats: true ) { _ in
            mNext()
        }
    }
    
    func mStopGame()
    {
        mState = ePlayState.Edit
        self.mo_GenerationTimer?.invalidate()
        self.mo_GenerationTimer = nil
    }
    
    func mNext()
    {
        mField.mUpdateNeighbours()
        if !mField.mbUpdateCells() {
            mStopGame()
            showAlert = true
        } else if mField.mCellCount == 0 {
            mStopGame()
            showAlert = true
        } else {
            mField.mGeneration += 1
            mField.mbFutureStop = false
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
