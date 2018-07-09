package model

// MapSize stores size of game-grid
type MapSize struct {
	MapWidth  int `json:"width"`
	MapHeight int `json:"height"`
}

// Width returns width of grid
func (m MapSize) Width() int {
	return m.MapWidth
}

// Height returns width of grid
func (m MapSize) Height() int {
	return m.MapHeight
}

// LastCellID returns ID of last hex-cell
func (m MapSize) LastCellID() int {
	if !m.isValid() {
		return -1
	}
	return m.MapWidth * m.MapHeight
}

func (m MapSize) isValid() bool {
	return m.MapWidth > 0 && m.MapHeight > 0
}
