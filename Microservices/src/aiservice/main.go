package main

import (
	"aiservice/ai"
	"aiservice/ai/list"
	"aiservice/constants"
	"aiservice/server"
	"flag"
	"net/http"

	log "github.com/sirupsen/logrus"
)

func main() {
	var addr = flag.String("addr", constants.Address, "address to serve")
	flag.Parse()
	var aiManager = ai.NewManager()
	list.RegisterAll(aiManager)
	http.Handle("/ai/names", server.NewAINamesHandler(aiManager))
	var turnHander = ai.NewTurnHandler(aiManager)
	go turnHander.Start()
	http.Handle("/ai/do", server.NewDoHandler(turnHander))
	log.Fatal(http.ListenAndServe(*addr, nil))
}
