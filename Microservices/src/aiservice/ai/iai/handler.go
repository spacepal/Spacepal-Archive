package iai

import "aiservice/model/imodel"

// Handler is an interface of TurnHandler
type Handler interface {
	Handle(in imodel.InGetter)
	Start()
}
