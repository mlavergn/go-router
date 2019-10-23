###############################################
#
# Makefile
#
###############################################

.DEFAULT_GOAL := build

#
# Env
#
# ROUTER = 172.16.1.1
ROUTER = 192.168.1.1
# ROUTER = 192.168.2.1

TGT ?= 1

#
# ARM / MIPS router settings
#
GOOS = linux
ifeq (${TGT}, 1)
# Buffalo WZR1750 (ARMv5 32)
GOARCH = arm
GOARM = 5
else ifeq (${TGT}, 2)
# Linksys WRT32X (ARMv7 32)
GOARCH = arm
GOARM = 7
else
# RavPower WD03 (MIPSLE 32 no FPU)
GOARCH = mipsle
GOMIPS = softfloat
endif

build:
	go build -o demo main.go

dist:
	@rm -f demo
ifeq (${GOARCH}, arm)
	GOARCH=${GOARCH} GOOS=${GOOS} GOARM=${GOARM} go build --ldflags "-s -w" -o demo main.go
else
	GOARCH=${GOARCH} GOOS=${GOOS} GOMIPS=${GOMIPS} go build --ldflags "-s -w" -o demo main.go
endif

deploy: dist
	scp demo root@${ROUTER}:demo

test: deploy
	ssh root@${ROUTER} "./demo"

ssh:
	ssh root@${ROUTER}

clean:
	-rm demo
