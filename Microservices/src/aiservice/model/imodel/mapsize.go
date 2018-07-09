package imodel

// MapSizeGetter has methods for getting main MapSize fields
type MapSizeGetter interface {
	Width() int
	Height() int
	LastCellID() int
}
