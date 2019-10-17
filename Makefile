###############################################
#
# Makefile
#
###############################################

.DEFAULT_GOAL := build

#
# Env
#
# GOROOT = /usr/local/go
ROUTER = 172.16.1.1
# ROUTER = 192.168.1.1

#
# ARM router settings
#
GOOS = linux
GOARCH = arm
GOARM = 5

build:
	go build -o demo main.go

dist:
	GOARCH=${GOARCH} GOOS=${GOOS} GOARM=${GOARM} go build -o demo main.go

deploy: dist
	scp demo root@${ROUTER}:demo

test: deploy
	ssh root@${ROUTER} "./demo"

ssh:
	ssh root@${ROUTER}

clean:
	-rm demo
