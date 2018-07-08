package helpers

import (
	"testing"
)

var coordConvCases = []struct {
	id          int
	offsetCoord offsetCoord
	cubeCoord   cubeCoord
}{
	{
		id:          1,
		offsetCoord: offsetCoord{x: 0, y: 0},
		cubeCoord:   cubeCoord{x: 0, z: 0, y: 0},
	},
	{
		id:          2,
		offsetCoord: offsetCoord{x: -2, y: -2},
		cubeCoord:   cubeCoord{x: -2, z: -1, y: +3},
	},
	{
		id:          3,
		offsetCoord: offsetCoord{x: +2, y: +1},
		cubeCoord:   cubeCoord{x: +2, z: 0, y: -2},
	},
	{
		id:          4,
		offsetCoord: offsetCoord{x: +2, y: -1},
		cubeCoord:   cubeCoord{x: +2, z: -2, y: 0},
	},
}

func TestCoordinateConversions(t *testing.T) {
	for _, c := range coordConvCases {
		var get = c.offsetCoord.cubeCoord()
		if c.offsetCoord.cubeCoord() != c.cubeCoord {
			t.Error("Invalid case: ", c.id, "; want: ", c.cubeCoord, ", get: ", get)
		}
	}
}

func TestCubeCoordinatesDistance(t *testing.T) {
	var first = cubeCoord{x: -1, y: +1, z: 0}
	var second = cubeCoord{x: -4, y: +2, z: +2}
	var want = 3
	var get = first.distanceTo(second)
	if want != get {
		t.Error("Invalid distance; want: ", want, ", get: ", get)
	}
}

var mapSizeValidationCases = []struct {
	id      int
	valid   bool
	mapSize mapSize
}{
	{id: 1, valid: true, mapSize: mapSize{width: 10, height: 10}},
	{id: 2, valid: true, mapSize: mapSize{width: 100, height: 1}},
	{id: 3, valid: false, mapSize: mapSize{width: -10, height: 10}},
	{id: 4, valid: false, mapSize: mapSize{width: 10, height: -10}},
	{id: 5, valid: false, mapSize: mapSize{width: -10, height: -101}},
}

func TestMapSizeValidation(t *testing.T) {
	for _, c := range mapSizeValidationCases {
		get := c.mapSize.isValid()
		if c.valid != get {
			t.Error("Invalid case: ", c.id, "; want: ", c.valid, ", get: ", get)
		}
	}
}

var cellConvCases = []struct {
	id      int
	mapSize mapSize
	cell    cell
	coord   offsetCoord
}{
	{
		id:      1,
		mapSize: mapSize{width: 10, height: 10},
		cell:    cell{1},
		coord:   offsetCoord{x: 0, y: 0},
	},
	{
		id:      2,
		mapSize: mapSize{width: 4, height: 3},
		cell:    cell{5},
		coord:   offsetCoord{x: 0, y: 1},
	},
	{
		id:      3,
		mapSize: mapSize{width: 4, height: 3},
		cell:    cell{10},
		coord:   offsetCoord{x: 1, y: 2},
	},
	{
		id:      4,
		mapSize: mapSize{width: 4, height: 3},
		cell:    cell{12},
		coord:   offsetCoord{x: 3, y: 2},
	},
}

func TestCellConversions(t *testing.T) {
	for _, c := range cellConvCases {
		get := c.cell.offsetCoord(c.mapSize)
		if c.coord != get {
			t.Error("Invalid case: ", c.id, "; want: ", c.coord, ", get: ", get)
		}
	}
}

var distanceSurfaceCase = struct {
	mapWidth  int
	mapHeight int
	from      int
	to        map[int]int
}{
	mapWidth:  4,
	mapHeight: 3,
	from:      5,
	to: map[int]int{
		1:  1,
		2:  1,
		3:  2,
		4:  3,
		5:  0,
		6:  1,
		7:  2,
		8:  3,
		9:  1,
		10: 2,
		11: 2,
		12: 3,
	},
}

func TestDistanceSurface(t *testing.T) {
	if NewDistanceSurface(1, -10, 10) != nil {
		t.Fatal("NewDistanceSurface(1, -10, 10) != nil")
	}
	if NewDistanceSurface(-1, 10, 10) != nil {
		t.Fatal("NewDistanceSurface(-1, 10, 10) != nil")
	}
	if NewDistanceSurface(-1, 10, 10) != nil {
		t.Fatal("NewDistanceSurface(-1, 10, 10) != nil")
	}
	var c = distanceSurfaceCase
	var s = NewDistanceSurface(c.from, c.mapWidth, c.mapHeight)
	if s == nil {
		t.Fatal("s == nil")
	}
	for to, want := range c.to {
		get := s.DistanceTo(to)
		if get != want {
			t.Error("Invalid distance to: ", to, "; want: ", want, ", get: ", get)
		}
	}
}
