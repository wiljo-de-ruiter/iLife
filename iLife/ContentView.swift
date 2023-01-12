//
//  ContentView.swift
//  Life
//
//  Created by Wiljo de Ruiter on 2023-01-08.
//

import SwiftUI

struct Cell
{
    public var mCell: Bool = false
    public var mNeighbours: UInt8 = 0
}

struct Playfield
{
    public let mcRows: UInt8
    public let mcCols: UInt8
    public var mCellCount = 0
    public var mGeneration = 0
    private var mField: [[Cell]]
    
    init( rows aRows: UInt8, cols aCols: UInt8 )
    {
        mcRows = aRows
        mcCols = aCols
        mField = Array( repeating: Array( repeating: Cell(), count: Int( mcCols )), count: Int( mcRows ))
        mAddGliders()
    }
    
    func mCell( row aRow: UInt8, col aCol: UInt8 ) -> Bool
    {
        assert( aRow < mcRows && aCol < mcCols )
        return mField[ Int( aRow ) ][ Int( aCol ) ].mCell
    }
    
    mutating func mSetCell( row aRow: UInt8, col aCol: UInt8, _ val: Bool )
    {
        print( "row = \(aRow), col = \(aCol)" )
        assert( aRow < mcRows && aCol < mcCols )
        mField[ Int( aRow ) ][ Int( aCol ) ].mCell = val
    }
    
    private func m_LeftOf ( _ aCol: UInt8 ) -> UInt8 { ( aCol + mcCols - 1 ) % mcCols }
    private func m_RightOf( _ aCol: UInt8 ) -> UInt8 { ( aCol + 1 ) % mcCols }
    private func m_Above  ( _ aRow: UInt8 ) -> UInt8 { ( aRow + mcRows - 1 ) % mcRows }
    private func m_Under  ( _ aRow: UInt8 ) -> UInt8 { ( aRow + 1 ) % mcRows }
    
    mutating func mAddGliders()
    {
        mSetCell( row: 0, col: 1, true )
        mSetCell( row: 1, col: 2, true )
        mSetCell( row: 2, col: 0, true )
        mSetCell( row: 2, col: 1, true )
        mSetCell( row: 2, col: 2, true )

        mSetCell( row: 2, col: 12, true )
        mSetCell( row: 3, col: 11, true )
        mSetCell( row: 4, col: 13, true )
        mSetCell( row: 4, col: 12, true )
        mSetCell( row: 4, col: 11, true )

        mSetCell( row: 14, col: 2, true )
        mSetCell( row: 13, col: 3, true )
        mSetCell( row: 12, col: 1, true )
        mSetCell( row: 12, col: 2, true )
        mSetCell( row: 12, col: 3, true )

//        setCell( row: 26, col: 33, true )
//        setCell( row: 27, col: 32, true )
//        setCell( row: 28, col: 34, true )
//        setCell( row: 28, col: 33, true )
//        setCell( row: 28, col: 32, true )
//
//        setCell( row: 26, col: 43, true )
//        setCell( row: 27, col: 42, true )
//        setCell( row: 28, col: 44, true )
//        setCell( row: 28, col: 43, true )
//        setCell( row: 28, col: 42, true )
//
//        setCell( row: 26, col: 53, true )
//        setCell( row: 27, col: 52, true )
//        setCell( row: 28, col: 54, true )
//        setCell( row: 28, col: 53, true )
//        setCell( row: 28, col: 52, true )
//
//        setCell( row: 16, col: 28, true )
//        setCell( row: 17, col: 27, true )
//        setCell( row: 18, col: 29, true )
//        setCell( row: 18, col: 28, true )
//        setCell( row: 18, col: 27, true )
//
//        setCell( row: 16, col: 43, true )
//        setCell( row: 17, col: 42, true )
//        setCell( row: 18, col: 44, true )
//        setCell( row: 18, col: 43, true )
//        setCell( row: 18, col: 42, true )
//
//        setCell( row: 16, col: 58, true )
//        setCell( row: 17, col: 57, true )
//        setCell( row: 18, col: 59, true )
//        setCell( row: 18, col: 58, true )
//        setCell( row: 18, col: 57, true )
    }
    
    mutating func mUpdateNeighbours()
    {
        for row in 0 ..< mcRows {
            for col in 0 ..< mcCols {
                var n: UInt8 = 0
                if mCell( row: row, col: m_LeftOf( col ))      { n += 1 }
                if mCell( row: row, col: m_RightOf( col ))     { n += 1 }
                
                if mCell( row: m_Above( row ), col: m_LeftOf( col ))  { n += 1 }
                if mCell( row: m_Above( row ), col: col )             { n += 1 }
                if mCell( row: m_Above( row ), col: m_RightOf( col )) { n += 1 }
                
                if mCell( row: m_Under( row ), col: m_LeftOf( col ))  { n += 1 }
                if mCell( row: m_Under( row ), col: col )             { n += 1 }
                if mCell( row: m_Under( row ), col: m_RightOf( col )) { n += 1 }
                
                mField[ Int( row ) ][ Int( col ) ].mNeighbours = n
            }
        }
    }
    
    mutating func mUpdateCells()
    {
        mCellCount = 0
        for row in 0 ..< mcRows {
            for col in 0 ..< mcCols {
                switch mField[ Int( row ) ][ Int( col ) ].mNeighbours {
                case 2:     break
                case 3:     mField[ Int( row ) ][ Int( col ) ].mCell = true
                default:    mField[ Int( row ) ][ Int( col ) ].mCell = false
                }
                if mField[ Int( row ) ][ Int( col ) ].mCell {
                    mCellCount += 1
                }
            }
        }
    }
}

enum ePlayState
{
    case Edit
    case Live
}

struct ButtonView: View {
    var caption: String
    var image = "hand.thumbsup.fill"
    var action: () -> Void
    
    var body: some View {
        Button( action: action ) {
            HStack {
                Text( caption )
                    .bold()
                    .font(.headline)
                Image( systemName: image )
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
    @State private var field = Playfield(rows: 27, cols: 18)
    @State var stopTimer = false
    @State var state = ePlayState.Edit
    @State private var mo_GenerationTimer: Timer?
    
    var body: some View {
        VStack( spacing: 0 ) {
            HStack {
                Text( "Cell Count = \(field.mCellCount)" )
                Spacer()
                Text( "Generation: \(field.mGeneration)" )
            }
            .foregroundColor(.white)
    
            ForEach( 0 ..< field.mcRows, id: \.self ) { row in
                HStack( spacing: 0 ) {
                    ForEach( 0 ..< field.mcCols, id: \.self ) { col in
                        let val = field.mCell( row: row, col: col )
                        Image( systemName: val ? "circle.fill" : "circle" )
                            .foregroundColor( val ? Color.white : Color.gray )
                            .font(.caption)
                            .onTapGesture {
                                if state == ePlayState.Edit {
                                    field.mSetCell( row: row, col: col, !field.mCell( row: row, col: col ))
                                }
                            }
                    }
                }
            }
            
            HStack {
                ButtonView( caption: "Stop", image: "stop.fill" ) {
                    stopGame()
                }
                .disabled( state == .Edit )
                .opacity( state == .Edit ? 0.5 : 1.0 )

                ButtonView( caption: "Play", image: "forward.end.fill" ) {
                    startGame()
                }
                .disabled( state == .Live )
                .opacity( state == .Live ? 0.5 : 1.0 )
            }
            .padding()
            .foregroundColor(.white)
        }
        .padding()
        .background(Color.black)
    }
    
    func startGame()
    {
        state = ePlayState.Live
        self.mo_GenerationTimer = Timer.scheduledTimer( withTimeInterval: 0.1, repeats: true ) { _ in
            next()
        }
    }
    
    func stopGame()
    {
        state = ePlayState.Edit
        self.mo_GenerationTimer?.invalidate()
        self.mo_GenerationTimer = nil
    }
    
    func next()
    {
        field.mUpdateNeighbours()
        field.mUpdateCells()
        field.mGeneration += 1
        
        if field.mCellCount == 0 {
            stopGame()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
