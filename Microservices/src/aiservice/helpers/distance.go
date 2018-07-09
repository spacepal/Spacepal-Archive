package helpers

import (
	"aiservice/model/imodel"
	"math"
)

// DistanceSurface represents a map of offset distances relative to cell
type DistanceSurface struct {
	mapSize imodel.MapSizeGetter
	cell    cell
	surface map[int]int
}

// NewDistanceSurface initializes DistanceSurface relative to cell
func NewDistanceSurface(cellID int, mapSize imodel.MapSizeGetter) *DistanceSurface {
	var surface DistanceSurface
	surface.mapSize = mapSize
	if cellID < 1 || cellID > surface.mapSize.LastCellID() {
		return nil
	}
	surface.surface = make(map[int]int)
	surface.cell = cell{cellID}
	var firstCube = surface.cell.cubeCoord(surface.mapSize)
	for i := 1; i <= surface.mapSize.LastCellID(); i++ {
		var secondCube = cell{i}.cubeCoord(surface.mapSize)
		surface.surface[i] = secondCube.distanceTo(firstCube)
	}
	return &surface
}

// DistanceTo returns shortest distance to given cell
func (s DistanceSurface) DistanceTo(cell int) int {
	if cell < 1 || cell > s.mapSize.LastCellID() {
		return -1
	}
	return s.surface[cell]
}

type cell struct {
	id int
}

func (c cell) offsetCoord(mapSize imodel.MapSizeGetter) offsetCoord {
	return offsetCoord{
		x: (c.id - 1) % mapSize.Width(),
		y: int(math.Floor(float64(c.id-1) / float64(mapSize.Width()))),
	}
}

func (c cell) cubeCoord(mapSize imodel.MapSizeGetter) cubeCoord {
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
