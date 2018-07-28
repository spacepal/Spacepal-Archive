PRODUCTION=__production__
FRONTEND=Frontend
FRONTEND_DIST=$(FRONTEND)/dist
BACKEND=Backend
MICROSERVICES=Microservices
MICROSERVICES_DIST=$(MICROSERVICES)/dist
CHECK_SCRIPT=./.build-tools/check.sh

all: check clean build_backend build_frontend build_microservices
check:
		@bash "$(CHECK_SCRIPT)"
build_frontend:
		@printf "\n\n \033[32m \t--- Frontend --- \033[0m \n\n"
		mkdir -p ./$(PRODUCTION)/$(FRONTEND)
		npm i --prefix ./$(FRONTEND)
		npm run build --prefix ./$(FRONTEND)
		cp ./$(FRONTEND_DIST)/* ./$(PRODUCTION)/$(FRONTEND)/ -r
build_backend:
		mkdir -p ./$(PRODUCTION)/$(BACKEND)
		@printf "\n\n \033[32m \t--- Backend --- \033[0m \n\n"
		+$(MAKE) -C $(BACKEND)
		cp ./$(BACKEND) ./$(PRODUCTION) -r
build_microservices:
		@printf "\n\n \033[32m \t--- Microservices --- \033[0m \n\n"
		mkdir -p ./$(PRODUCTION)/$(MICROSERVICES)
		+$(MAKE) -C $(MICROSERVICES)
		cp ./$(MICROSERVICES_DIST)/* ./$(PRODUCTION)/$(MICROSERVICES)/ -r
clean:
		rm "./$(PRODUCTION)"/* -rf