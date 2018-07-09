package model

import (
	"aiservice/constants"
	"errors"
	"fmt"
)

// AIPlayer represents main information about computer-player
type AIPlayer struct {
	Type   string `json:"aiType"`
	Player int    `json:"playerID"`
}

// Check validates AIPlayer model
func (ai AIPlayer) check() error {
	if _, ok := constants.AITypes[ai.Type]; !ok {
		return errors.New(
			fmt.Sprint("Invalid AI type. PlayerID:", ai.Player))
	}
	return nil
}
