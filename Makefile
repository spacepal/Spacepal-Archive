PRODUCTION=__production__
FRONTEND=Frontend
FRONTEND_DIST=$(FRONTEND)/dist
BACKEND_DIR=Backend
MICROSERVICES=Microservices
MICROSERVICES_DIST=$(MICROSERVICES)/dist
BUILD_SCRIPTS=./.build-tools
CHECK_SCRIPT=$(BUILD_SCRIPTS)/check.sh
PROMT_SCRIPT=$(BUILD_SCRIPTS)/promt.sh

all: check clean backend frontend microservices done
check:
		@if [ -z $(SPACEPAL_BACKEND) ]; then\
			printf "\n\n \033[31m SPACEPAL_BACKEND is not specified\033[0m \n\n";\
			exit 1;\
		fi
		@bash "$(CHECK_SCRIPT)"
frontend:
		@printf "\n\n \033[32m \t--- Frontend --- \033[0m \n\n"
		mkdir -p ./$(PRODUCTION)/$(FRONTEND)
		+$(MAKE) BACKEND="$(SPACEPAL_BACKEND)" -C $(FRONTEND)
		cp ./$(FRONTEND_DIST)/* ./$(PRODUCTION)/$(FRONTEND)/ -rf
backend:
		mkdir -p ./$(PRODUCTION)/$(BACKEND_DIR)
		@printf "\n\n \033[32m \t--- Backend --- \033[0m \n\n"
		+$(MAKE) -C $(BACKEND_DIR)
		cp ./$(BACKEND_DIR) ./$(PRODUCTION) -rf
microservices:
		@printf "\n\n \033[32m \t--- Microservices --- \033[0m \n\n"
		mkdir -p ./$(PRODUCTION)/$(MICROSERVICES)
		+$(MAKE) -C $(MICROSERVICES)
		cp ./$(MICROSERVICES_DIST)/* ./$(PRODUCTION)/$(MICROSERVICES)/ -rf
clean:
		rm "./$(PRODUCTION)"/* -rf
done:
		@printf "\n\n \033[32m \t--- All Done --- \033[0m \n\n"