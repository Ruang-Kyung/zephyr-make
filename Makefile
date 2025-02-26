# Copyright (c) 2025 James Roy
# SPDX-License-Identifier: GPL-2.0

#
# compiler variable
#
WEST := west
CMAKE_VERSION := 3.20.0

#
# allow override
#
BOARD ?= mini_stm32h7b0
TEST_RUN_BOARD ?= qemu_x86
APPNAME ?= application
OPT ?=# None

#
# devicetree and overlay
#
OVERLAYS ?=# None
EXTRA_OVERLAYS := $(foreach x, $(OVERLAYS), --extra-dtc-overlay $(x))

# =====================================================
# |              application management               |
# =====================================================

#
# global target
#
.PHONY: all
all:
	$(WEST) build -b $(BOARD) $(APPNAME) $(EXTRA_OVERLAYS) $(OPT)

#
# menuconfig
#
.PHONY: menu
menuconfig:
	$(WEST) build -b $(BOARD) -t menuconfig $(OPT)

#
# guiconfig
#
.PHONY: gui
guiconfig:
	$(WEST) build -b $(BOARD) -t guiconfig $(OPT)

#
# initlevels
#
.PHONY: initlevel
initlevel:
	$(WEST) build -b $(BOARD) -t initilevels $(OPT)

#
# flash
#
.PHONY: flash
flash:
	@clear
	$(WEST) flash $(OPT)

#
# clean build target of zephyr
#
.PHONY: clean
clean:
	@rm -rf build/

# =====================================================
# |              repository and metadata              |
# =====================================================

#
# initialize west workspace of zephyr
#
.PHONY: init
init:
	$(WEST) init $(OPT)

#
# update zephyr repository
#
.PHONY: update
update:
	$(WEST) update $(OPT)

#
# list supported boards
#
.PHONY: boards
boards:
	$(WEST) boards $(OPT)

#
# status
#
.PHONY: status
status:
	$(WEST) status $(OPT)

#
# diff
#
.PHONY: diff
diff:
	$(WEST) diff $(OPT)

# =====================================================
# |          remote debugging and simulation          |
# =====================================================

#
# simulate board
#
.PHONY: nsim
nsim:
	$(WEST) simulate $(OPT)

#
# rtt
#
.PHONY: rtt
rtt:
	$(WEST) rtt $(OPT)

#
# debug
#
.PHONY: debug
debug:
	$(WEST) debug $(OPT)

#
# attach
#
.PHONY: attach
attach:
	$(WEST) attach $(OPT)

#
# debugserver
#
.PHONY: debugserver
debugserver:
	$(WEST) debugserver $(OPT)
