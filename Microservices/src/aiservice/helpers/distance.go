package helpers

import (
	"math"
)

type mapSize struct {
	width  int
	height int
}

func (m mapSize) lastCellID() int {
	return m.width * m.height
}

func (m mapSize) isValid() bool {
	return m.width > 0 && m.height > 0
}

type cell struct {
	x       int
	y       int
	cellID  int
	mapSize *mapSize
}

func newCellByID(cellID int, mapSize *mapSize) *cell {
	if !mapSize.isValid() || cellID < 1 ||
		cellID > mapSize.lastCellID() {
		return nil
	}
	return &cell{
		x:       (cellID - 1) % mapSize.width,
		y:       int(math.Ceil(float64(cellID-1) / float64(mapSize.width))),
		mapSize: mapSize,
		cellID:  cellID,
	}
}

func newCellByPos(x, y int, mapSize *mapSize) *cell {
	if !mapSize.isValid() || x < 0 || y < 0 ||
		x >= mapSize.width || y >= mapSize.height {
		return nil
	}
	return &cell{
		x:       x,
		y:       y,
		mapSize: mapSize,
		cellID:  x + y*mapSize.width + 1,
	}
}

// safePush append given cell to a slice of cells
// if this cell is not equal to nil
func safePush(to *[]*cell, el *cell) {
	if el != nil {
		*to = append(*to, el)
	}
}

func (c cell) neighbours() []*cell {
	var cells = make([]*cell, 0)
	safePush(&cells, newCellByPos(c.x-1, c.y, c.mapSize))
	safePush(&cells, newCellByPos(c.x+1, c.y, c.mapSize))
	safePush(&cells, newCellByPos(c.x, c.y-1, c.mapSize))
	safePush(&cells, newCellByPos(c.x, c.y+1, c.mapSize))
	var delta = -1 // for odd
	if c.cellID%2 == 0 {
		delta = +1 // for even
	}
	safePush(&cells, newCellByPos(c.x-1, c.y+delta, c.mapSize))
	safePush(&cells, newCellByPos(c.x+1, c.y+delta, c.mapSize))
	return cells
}

// CalcDistance calculates map of distances from specific cell to each other
// cellID  starts  with 1
func CalcDistance(from, mapWidth, mapHeight int) (hexSurface map[int]int) {
	var mapSize = &mapSize{
		width:  mapWidth,
		height: mapHeight,
	}
	if !mapSize.isValid() {
		return nil
	}

	var fromCell = newCellByID(from, mapSize)
	if fromCell == nil {
		return nil
	}

	hexSurface = make(map[int]int)
	var pendingCells = []*cell{newCellByID(from, mapSize)}
	var tmpCells = make([]*cell, 0)
	var step = 0
	for len(pendingCells) > 0 {
		for _, cell := range pendingCells {
			if _, ok := hexSurface[cell.cellID]; ok {
				continue
			}
			hexSurface[cell.cellID] = step
			tmpCells = append(tmpCells, cell.neighbours()...)
		}
		pendingCells = tmpCells
		tmpCells = make([]*cell, 0)
		step++
	}
	return
}
