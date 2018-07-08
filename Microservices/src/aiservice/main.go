package main

import (
	"aiservice/constants"
	"aiservice/handler"
	"flag"
	"net/http"

	log "github.com/sirupsen/logrus"
)

func main() {
	var addr = flag.String("addr", constants.Address, "address to serve")
	flag.Parse()
	http.Handle("/ai/do", new(handler.MainHandler))
	http.Handle("/ai/types", new(handler.AITypesHandler))
	log.Fatal(http.ListenAndServe(*addr, nil))
}
