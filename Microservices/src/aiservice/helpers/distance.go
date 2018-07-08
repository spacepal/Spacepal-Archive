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

// DistanceSurface represents a map of offset distances relative to cell
type DistanceSurface struct {
	mapSize mapSize
	cell    cell
	surface map[int]int
}

// NewDistanceSurface initializes DistanceSurface relative to cell
func NewDistanceSurface(cellID, mapWidth, mapHeight int) *DistanceSurface {
	var surface DistanceSurface
	surface.mapSize = mapSize{width: mapWidth, height: mapHeight}
	if !surface.mapSize.isValid() {
		return nil
	}
	if cellID < 1 || cellID > surface.mapSize.lastCellID() {
		return nil
	}
	surface.surface = make(map[int]int)
	surface.cell = cell{cellID}
	var firstCube = surface.cell.cubeCoord(surface.mapSize)
	for i := 1; i <= surface.mapSize.lastCellID(); i++ {
		var secondCube = cell{i}.cubeCoord(surface.mapSize)
		surface.surface[i] = secondCube.distanceTo(firstCube)
	}
	return &surface
}

// DistanceTo returns shortest distance to given cell
func (s DistanceSurface) DistanceTo(cell int) int {
	if cell < 1 || cell > s.mapSize.lastCellID() {
		return -1
	}
	return s.surface[cell]
}

type cell struct {
	id int
}

func (c cell) offsetCoord(mapSize mapSize) offsetCoord {
	return offsetCoord{
		x: (c.id - 1) % mapSize.width,
		y: int(math.Floor(float64(c.id-1) / float64(mapSize.width))),
	}
}

func (c cell) cubeCoord(mapSize mapSize) cubeCoord {
	return c.offsetCoord(mapSize).cubeCoord()
}

type cubeCoord struct {
	x int
	y int
	z int
}

func (first cubeCoord) distanceTo(second cubeCoord) int {
	var dx = math.Abs(float64(first.x - second.x))
	var dy = math.Abs(float64(first.y - second.y))
	var dz = math.Abs(float64(first.z - second.z))
	return int((dx + dy + dz) / 2.0)
}

// odd columns by +0.5 row
type offsetCoord struct {
	x int
	y int
}

func (c offsetCoord) cubeCoord() cubeCoord {
	var oddFactor = c.x & 1
	var z = c.y - (c.x-oddFactor)/2
	return cubeCoord{
		x: c.x,
		z: z,
		y: -c.x - z,
	}
}
