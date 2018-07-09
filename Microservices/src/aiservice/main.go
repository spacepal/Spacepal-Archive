package main

import (
	"aiservice/ai"
	"aiservice/ai/list"
	"aiservice/constants"
	"aiservice/handler"
	"flag"
	"net/http"

	log "github.com/sirupsen/logrus"
)

func main() {
	var addr = flag.String("addr", constants.Address, "address to serve")
	flag.Parse()
	var aiManager = ai.NewManager()
	list.RegisterAll(aiManager)
	http.Handle("/ai/names", handler.NewAINamesHandler(aiManager))
	var turnHander = ai.NewTurnHandler(aiManager)
	http.Handle("/ai/do", handler.NewDoHandler(turnHander))
	log.Fatal(http.ListenAndServe(*addr, nil))
}
