//
//  ContentView.swift
//  Life
//
//  Created by Wiljo de Ruiter on 2023-01-08.
//

import SwiftUI

struct Cell
{
    public var mbCell: Bool = false
    public var mNeighbours: UInt8 = 0
    
    mutating func mClear()
    {
        mbCell = false
        mNeighbours = 0
    }
}

struct Object
{
    public let mcName: String
    public let mcData: String
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
        return mField[ Int( aRow ) ][ Int( aCol ) ].mbCell
    }
    
    mutating func mSetCell( row aRow: UInt8, col aCol: UInt8, _ val: Bool )
    {
        assert( aRow < mcRows && aCol < mcCols )
        mField[ Int( aRow ) ][ Int( aCol ) ].mbCell = val
    }
    
    mutating func mSetObject( row acRow: UInt8, col acCol: UInt8, _ acObject: Object )
    {
        assert( acRow < mcRows && acCol < mcCols )
        var row = acRow
        var col = acCol
        for ch in acObject.mcData {
            switch ch {
            case "\n":
                row = m_Under( row )
                col = acCol
                
            case "o", "O":
                mField[ Int( row ) ][ Int( col ) ].mbCell = true
                col = m_RightOf( col )
            
            default:
                mField[ Int( row ) ][ Int( col ) ].mbCell = false
                col = m_RightOf( col )
            }
        }
    }
    
    private func m_LeftOf ( _ aCol: UInt8 ) -> UInt8 { ( aCol + mcCols - 1 ) % mcCols }
    private func m_RightOf( _ aCol: UInt8 ) -> UInt8 { ( aCol + 1 ) % mcCols }
    private func m_Above  ( _ aRow: UInt8 ) -> UInt8 { ( aRow + mcRows - 1 ) % mcRows }
    private func m_Under  ( _ aRow: UInt8 ) -> UInt8 { ( aRow + 1 ) % mcRows }
    
    mutating func mAddGliders()
    {
//        mSetObject( row: 2, col: 2, Object( mcName: "Glider", mcData: """
//.O
//..O
//OOO
//""" ))
//
//        mSetObject( row: 10, col: 3, Object( mcName: "Spaceship", mcData: """
//O..O
//....O
//O...O
//.OOOO
//""" ))
//
        mSetObject( row: 3, col: 3, Object( mcName: "Pulsar", mcData: """
..OOO...OOO
.
O....O.O....O
O....O.O....O
O....O.O....O
..OOO...OOO
.
..OOO...OOO
O....O.O....O
O....O.O....O
O....O.O....O
.
..OOO...OOO
"""))
//        mSetCells( row: 1, col: 0, "..O" )
//        mSetCells( row: 2, col: 0, "OOO" )
//        mSetCell( row: 0, col: 1, true )
//        mSetCell( row: 1, col: 2, true )
//        mSetCell( row: 2, col: 0, true )
//        mSetCell( row: 2, col: 1, true )
//        mSetCell( row: 2, col: 2, true )

//        mSetCells( row: 2, col: 11, ".O" )
//        mSetCells( row: 3, col: 11, "O" )
//        mSetCells( row: 4, col: 11, "OOO" )
//        mSetCell( row: 2, col: 12, true )
//        mSetCell( row: 3, col: 11, true )
//        mSetCell( row: 4, col: 13, true )
//        mSetCell( row: 4, col: 12, true )
//        mSetCell( row: 4, col: 11, true )

//        mSetCells( row: 12, col: 1, "OOO" )
//        mSetCells( row: 13, col: 1, "..O" )
//        mSetCells( row: 14, col: 1, ".O" )
//        mSetCell( row: 14, col: 2, true )
//        mSetCell( row: 13, col: 3, true )
//        mSetCell( row: 12, col: 1, true )
//        mSetCell( row: 12, col: 2, true )
//        mSetCell( row: 12, col: 3, true )

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
    
    mutating func mClear()
    {
        mCellCount = 0
        mGeneration = 0
        for row in 0 ..< mcRows {
            for col in 0 ..< mcCols {
                mField[ Int( row ) ][ Int( col ) ].mClear()
            }
        }
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
                case 3:     mField[ Int( row ) ][ Int( col ) ].mbCell = true
                default:    mField[ Int( row ) ][ Int( col ) ].mbCell = false
                }
                if mField[ Int( row ) ][ Int( col ) ].mbCell {
                    mCellCount += 1
                }
            }
        }
    }

    public let mcGlider = Object( mcName: "Glider", mcData: """
.O
..O
OOO
""" )

    public let mcSpaceship = Object( mcName: "Spaceship", mcData: """
O..O
....O
O...O
.OOOO
""" )

    public let mcPulsar = Object( mcName: "Pulsar", mcData: """
..OOO...OOO
.
O....O.O....O
O....O.O....O
O....O.O....O
..OOO...OOO
.
..OOO...OOO
O....O.O....O
O....O.O....O
O....O.O....O
.
..OOO...OOO
""" )

}

enum ePlayState
{
    case Edit
    case Live
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
    @State private var mField = Playfield(rows: 27, cols: 18)
    @State var mState = ePlayState.Edit
    @State private var mo_GenerationTimer: Timer?
    
    var body: some View {
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
                        let val = mField.mCell( row: row, col: col )
                        Image( systemName: val ? "circle.fill" : "circle" )
                            .foregroundColor( val ? Color.white : Color.gray )
                            .font(.caption)
                            .onTapGesture {
                                if mState == ePlayState.Edit {
                                    mField.mSetCell( row: row, col: col, !mField.mCell( row: row, col: col ))
                                }
                            }
                    }
                }
            }
            
            HStack {
                ButtonView( mCaption: "Stop", mImage: "stop.fill" ) {
                    stopGame()
                }
                .disabled( mState == .Edit )
                .opacity( mState == .Edit ? 0.5 : 1.0 )

                ButtonView( mCaption: "Play", mImage: "forward.end.fill" ) {
                    startGame()
                }
                .disabled( mState == .Live )
                .opacity( mState == .Live ? 0.5 : 1.0 )
            }
            .padding()
            .foregroundColor(.white)
            
            HStack {
                Button( action: {
                    mField.mClear()
                    mField.mSetObject( row: 3, col: 3, mField.mcGlider )
                    
                }) {
                    Text( "Glider" )
                        .bold()
                        .font(.headline)
                }
                .padding(.horizontal)
                .foregroundColor(.white)
                .background( mState == .Edit ? Color.blue : Color.gray )
                .disabled( mState != .Edit )

                Button( action: {
                    mField.mClear()
                    mField.mSetObject( row: 5, col: 3, mField.mcSpaceship )
                    
                }) {
                    Text( "Spaceship" )
                        .bold()
                        .font(.headline)
                }
                .padding(.horizontal)
                .foregroundColor(.white)
                .background( mState == .Edit ? Color.blue : Color.gray )
                .disabled( mState != .Edit )

                Button( action: {
                    mField.mClear()
                    mField.mSetObject( row: 4, col: 2, mField.mcPulsar )
                    
                }) {
                    Text( "Pulsar" )
                        .bold()
                        .font(.headline)
                }
                .padding(.horizontal)
                .foregroundColor(.white)
                .background( mState == .Edit ? Color.blue : Color.gray )
                .disabled( mState != .Edit )
            }
        }
        .padding()
        .background(Color.black)
    }
    
    func startGame()
    {
        mState = ePlayState.Live
        self.mo_GenerationTimer = Timer.scheduledTimer( withTimeInterval: 0.1, repeats: true ) { _ in
            next()
        }
    }
    
    func stopGame()
    {
        mState = ePlayState.Edit
        self.mo_GenerationTimer?.invalidate()
        self.mo_GenerationTimer = nil
    }
    
    func next()
    {
        mField.mUpdateNeighbours()
        mField.mUpdateCells()
        mField.mGeneration += 1
        
        if mField.mCellCount == 0 {
            stopGame()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
