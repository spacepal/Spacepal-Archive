package helpers

import "testing"

var distanceMainCases = []struct {
	id        int
	from      int
	to        int
	mapWidth  int
	mapHeight int
	want      int
}{
	{
		id:        1,
		from:      3,
		to:        4,
		mapWidth:  0,
		mapHeight: 3,
		want:      -1,
	},
	{
		id:        2,
		from:      0,
		to:        10,
		mapWidth:  9,
		mapHeight: 9,
		want:      -1,
	},
	{
		id:        3,
		from:      1,
		to:        12,
		mapWidth:  4,
		mapHeight: 3,
		want:      4,
	},
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

func TestDistance(t *testing.T) {
	for _, c := range distanceMainCases {
		var get = -1
		surface := CalcDistance(c.from, c.mapWidth, c.mapHeight)
		if surface != nil {
			if toDistance, ok := surface[c.to]; ok {
				get = toDistance
			}
		}
		if get != c.want {
			t.Error("Invalid case: ", c.id, "; want: ", c.want, ", get: ", get)
		}
	}
}

func TestDistanceSurface(t *testing.T) {
	var c = distanceSurfaceCase
	surface := CalcDistance(c.from, c.mapWidth, c.mapHeight)
	for cellID, want := range c.to {
		get := surface[cellID]
		if get != want {
			t.Error("Invalid distance, want: ", want, ", get: ", get)
		}
	}
}
