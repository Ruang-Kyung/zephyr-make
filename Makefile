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
APP ?= application
OPT ?= # NULL

#
# devicetree and overlay
#
OVERLAYS ?= # NULL
EXTRA_OVERLAYS := $(foreach x, $(OVERLAYS), --extra-dtc-overlay $(x))

# =====================================================
# |              application management               |
# =====================================================

#
# global target
#
.PHONY: all
all:
	@clear
	$(WEST) build -b $(BOARD) $(APP) $(EXTRA_OVERLAYS) $(OPT)

#
# menuconfig
#
.PHONY: menuconfig
menuconfig:
	@clear
	$(WEST) build -b $(BOARD) -t menuconfig $(OPT)

#
# guiconfig
#
.PHONY: guiconfig
guiconfig:
	@clear
	$(WEST) build -b $(BOARD) -t guiconfig $(OPT)

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
	@mkdir -p $(APP)
	@touch $(APP)/CMakeLists.txt
	@echo -e 'cmake_minimum_required(VERSION $(CMAKE_VERSION))\n' >> $(APP)/CMakeLists.txt
	@echo 'find_package(Zephyr REQUIRED HINTS $$ENV{ZEPHYR_BASE})' >> $(APP)/CMakeLists.txt
	@echo -e 'project($(APP))\n' >> $(APP)/CMakeLists.txt
	@echo -e 'include_directories($$ENV{ZEPHYR_BASE}/include)\n' >> $(APP)/CMakeLists.txt
	@echo 'target_sources(app PRIVATE main.c)' >> $(APP)/CMakeLists.txt
	@touch $(APP)/app.overlay
	@touch $(APP)/Kconfig
	@touch $(APP)/prj.conf
	@touch $(APP)/main.c
	@echo -e '#include <stdio.h>\n' >> $(APP)/main.c
	@echo 'int main()' >> $(APP)/main.c
	@echo '{' >> $(APP)/main.c
	@echo -e '\tputs("Hello world");' >> $(APP)/main.c
	@echo -e '}\n' >> $(APP)/main.c
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
