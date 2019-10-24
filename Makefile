###############################################
#
# Makefile
#
###############################################

.DEFAULT_GOAL := build

#
# Env
#
ROUTER = 172.16.1.1
# ROUTER = 192.168.1.1
# ROUTER = 192.168.2.1

TGT ?= 1

#
# ARM / MIPS router settings
#
GOOS = linux
ifeq (${TGT}, 1)
# ARMv5 32
# Buffalo WZR1750
GOARCH = arm
GOARM = 5
else ifeq (${TGT}, 2)
# ARMv7 32
# Linksys WRT32X
GOARCH = arm
GOARM = 7
else ifeq (${TGT}, 3)
# MIPSLE 32 no FPU
# RavPower WD03
# TripMate Nano TM02
GOARCH = mipsle
GOMIPS = softfloat
else
# RISCV 64
GOARCH = riscv64
endif

build:
	@rm -f demo
	go build --ldflags "-s -w" -o demo main.go

strip:
	# need platform specific build
	strip -x -o demo-stripped demo

dist:
	@rm -f demo
ifeq (${GOARCH}, arm)
	GOOS=${GOOS} GOARCH=${GOARCH} GOARM=${GOARM} go build --ldflags "-s -w" -o demo main.go
else ifeq (${GOARCH}, mipsle)
	GOOS=${GOOS} GOARCH=${GOARCH} GOMIPS=${GOMIPS} go build --ldflags "-s -w" -o demo main.go
else
	GOOS=${GOOS} GOARCH=${GOARCH} go build --ldflags "-s -w" -o demo main.go
endif

deploy: dist
	scp demo root@${ROUTER}:demo

test: deploy
	ssh root@${ROUTER} "./demo"

ssh:
	ssh root@${ROUTER}

clean:
	-rm demo
