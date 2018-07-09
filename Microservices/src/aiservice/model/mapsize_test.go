package model

import "testing"

var mapSizeCases = []struct {
	id         int
	valid      bool
	lastCellID int
	mapSize    MapSize
}{
	{id: 1, valid: true, lastCellID: 100, mapSize: MapSize{MapWidth: 10, MapHeight: 10}},
	{id: 2, valid: true, lastCellID: 100, mapSize: MapSize{MapWidth: 100, MapHeight: 1}},
	{id: 3, valid: false, lastCellID: -1, mapSize: MapSize{MapWidth: -10, MapHeight: 10}},
	{id: 4, valid: false, lastCellID: -1, mapSize: MapSize{MapWidth: 10, MapHeight: -10}},
	{id: 5, valid: false, lastCellID: -1, mapSize: MapSize{MapWidth: -10, MapHeight: -101}},
}

func TestMapSizeValidation(t *testing.T) {
	for _, c := range mapSizeCases {
		get := c.mapSize.isValid()
		if c.valid != get {
			t.Error("Invalid validation of case: ", c.id, "; want: ", c.valid, ", get: ", get)
		}
	}
}

func TestMapSizeLastID(t *testing.T) {
	for _, c := range mapSizeCases {
		get := c.mapSize.LastCellID()
		if c.lastCellID != get {
			t.Error("Invalid lastID of case: ", c.id, "; want: ", c.lastCellID, ", get: ", get)
		}
	}
}
