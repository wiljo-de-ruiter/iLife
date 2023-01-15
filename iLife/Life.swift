//
//  Life.swift
//  iLife
//
//  Created by Wiljo de Ruiter on 2023-01-15.
//

import Foundation

struct Coord
{
    var mRow: UInt8 = 0
    var mCol: UInt8 = 0

    public func mNextRow( rows acRows: UInt8 ) -> UInt8 { ( mRow + 1 ) % acRows }
    public func mNextCol( cols acCols: UInt8 ) -> UInt8 { ( mCol + 1 ) % acCols }
    public func mPrevRow( rows acRows: UInt8 ) -> UInt8 { ( mRow + acRows - 1 ) % acRows }
    public func mPrevCol( cols acCols: UInt8 ) -> UInt8 { ( mCol + acCols - 1 ) % acCols }

    mutating func mSetNextRow( rows acRows: UInt8 ) { mRow = mNextRow( rows: acRows ) }
    mutating func mSetNextCol( cols acCols: UInt8 ) { mCol = mNextCol( cols: acCols ) }
    mutating func mSetPrevRow( rows acRows: UInt8 ) { mRow = mPrevRow( rows: acRows ) }
    mutating func mSetPrevCol( cols acCols: UInt8 ) { mCol = mPrevCol( cols: acCols ) }
}

struct Cell
{
    static public var gMutated = 0
    private var mb_Cell: Bool = false
    public var mNeighbours: UInt8 = 0

    public var mbCell: Bool {
        get {
            mb_Cell
        }
        set {
            if mb_Cell != newValue {
                mb_Cell = newValue
                Cell.gMutated += 1
            }
        }
    }

    public mutating func mClear()
    {
        mb_Cell = false
        mNeighbours = 0
        Cell.gMutated = 0
    }
}

struct Playfield
{
    public let mcRows: UInt8
    public let mcCols: UInt8
    public var mGeneration: UInt32 = 0
    public var mCellCount: UInt16 = 0
    public var mStart = Coord()
    private var m_Field: [[Cell]]
    public var mbFutureStop = false
    
    init( rows acRows: UInt8, cols acCols: UInt8 )
    {
        mcRows = acRows
        mcCols = acCols
        mStart = Coord()
        m_Field = Array( repeating: Array( repeating: Cell(), count: Int( mcCols )), count: Int( mcRows ))
    }
    
    private func mb_IndexIsValid( row acRow: UInt8, col acCol: UInt8 ) -> Bool
    {
        return acRow < mcRows && acCol < mcCols
    }
    
//    subscript( coord acCoord: Coord ) -> Cell
//    {
//        get {
//            assert( mb_IndexIsValid( acCoord ), "Index out of range" )
//            return m_Field[ Int( acCoord.mRow ) ][ Int( acCoord.mCol ) ]
//        }
//        set {
//            assert( mb_IndexIsValid( acCoord ), "Index out of range" )
//            m_Field[ Int( acCoord.mRow ) ][ Int( acCoord.mCol ) ] = newValue
//        }
//    }
    subscript( row: UInt8, col: UInt8 ) -> Cell
    {
        get {
            assert( mb_IndexIsValid( row: row, col: col ), "Index out of range" )
            return m_Field[ Int( row ) ][ Int( col ) ]
        }
        set {
            assert( mb_IndexIsValid( row: row, col: col ), "Index out of range" )
            m_Field[ Int( row ) ][ Int( col ) ] = newValue
        }
    }
//
//    mutating func mSetCell( row aRow: UInt8, col aCol: UInt8, _ val: Bool )
//    {
//        assert( aRow < mcRows && aCol < mcCols )
//        m_Field[ Int( aRow ) ][ Int( aCol ) ].mbCell = val
//    }
    
//    private func m_LeftOf ( _ aCol: UInt8 ) -> UInt8 { ( aCol + mcCols - 1 ) % mcCols }
//    private func m_RightOf( _ aCol: UInt8 ) -> UInt8 { ( aCol + 1 ) % mcCols }
//    private func m_Above  ( _ aRow: UInt8 ) -> UInt8 { ( aRow + mcRows - 1 ) % mcRows }
//    private func m_Under  ( _ aRow: UInt8 ) -> UInt8 { ( aRow + 1 ) % mcRows }
    
    mutating func mClear()
    {
        mStart.mRow = 0
        mStart.mCol = 0
        mCellCount = 0
        mGeneration = 0
        for row in 0 ..< mcRows {
            for col in 0 ..< mcCols {
                self[ row, col ] = Cell()
            }
        }
    }
    
    mutating func mUpdateNeighbours()
    {
        var pos = Coord()
        for row in 0 ..< mcRows {
            pos.mRow = row
            let above = pos.mPrevRow( rows: mcRows )
            let below = pos.mNextRow( rows: mcRows )
        
            for col in 0 ..< mcCols {
                pos.mCol = col
                let left = pos.mPrevCol( cols: mcCols )
                let right = pos.mNextCol( cols: mcCols )
                var n: UInt8 = 0
                
                if self[ above, left  ].mbCell { n += 1 }
                if self[ above, col   ].mbCell { n += 1 }
                if self[ above, right ].mbCell { n += 1 }
                
                if self[ row  , left  ].mbCell { n += 1 }
                if self[ row  , right ].mbCell { n += 1 }
                
                if self[ below, left  ].mbCell { n += 1 }
                if self[ below, col   ].mbCell { n += 1 }
                if self[ below, right ].mbCell { n += 1 }
                
                self[ row, col ].mNeighbours = n
            }
        }
    }
    
    mutating func mbUpdateCells() -> Bool
    {
        Cell.gMutated = 0
        for row in 0 ..< mcRows {
            for col in 0 ..< mcCols {
                switch self[ row, col ].mNeighbours {
                case 2:     break
                case 3:     self[ row, col ].mbCell = true
                default:    self[ row, col ].mbCell = false
                }
            }
        }
        mUpdateCellCount()
        return Cell.gMutated > 0
    }
    
    mutating func mUpdateCellCount()
    {
        mCellCount = 0
        for row in 0 ..< mcRows {
            for col in 0 ..< mcCols {
                if self[ row, col ].mbCell {
                    mCellCount += 1
                }
            }
        }
    }
    
    mutating func mSetObject( at acCoord: Coord, _ acObject: String? ) -> Coord
    {
        assert( acCoord.mRow < mcRows && acCoord.mCol < mcCols )
        guard let object = acObject else {
            return acCoord
        }
        var coord = acCoord
        for ch in object {
            switch ch {
            case "\n":
                coord.mSetNextRow( rows: mcRows )
                coord.mCol = acCoord.mCol
                
            case "o", "O":
                self[ coord.mRow, coord.mCol ].mbCell = true
                coord.mSetNextCol( cols: mcCols )
                
            default:
                self[ coord.mRow, coord.mCol ].mbCell = false
                coord.mSetNextCol( cols: mcCols )
            }
        }
        mUpdateCellCount()
        coord.mSetNextRow( rows: mcRows )
        coord.mCol = acCoord.mCol
        return coord
    }
}
