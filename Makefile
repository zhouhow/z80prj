# Makefile for Arduino based scketches
#
# This Makefile uses the arduino-cli, the Arduino command line interface
# and has been designed and tested to run on Linux, not on Windows.
#
# Please note that:
#
#   1. each sketch must reside in his own folder with this Makefile
#
#   2. the main make targets are:
#      - all     compiles and upload
#      - verify  compiles only
#      - upload  upload via serial port, compile if the binary file is
#                not available
#      - monitor open the serial monitor if device is available
#      - config  show the configuration of this sketch
#      - clean   clean the build directory
#      - install it the file "libraries.txt" exists it will
#                install the libraries listed in this file
#
#   3. default is "all"
#
# Optionally some environment variables can be set:
#
#   FQBN        Fully Qualified Board Name; you cna get FQBN of board by
#               command "arduino-cli board listall"
#
#   DEVS        environment it will be assigned:
#               /dev/ttyUSB0   if it exists, or
#               /dev/ttyACM0   if it exists
#
#   PROJ        the name of this arduino project; if is set in the environment 
#               the *.ino file name should be the same as it

# setup for the project name
PROJ        = blink

# setup for board name
#FQBN       = arduino:avr:uno
#FQBN       = esp32:esp32:esp32
FQBN       = esp8266:esp8266:nodemcu
#FQBN       = rp2040:rp2040:rpipico
#FQBN       = rp2040:rp2040:rpipicow

# setup for serial device
#DEVS       = /dev/ttyUSB0
DEVS       = /dev/ttyACM0

# other default variables
SRC        = $(PROJ).ino
DIR        = build
LIB        = libraries.txt


.PHONY: all
all: verify upload

verify:
	@if [ ! -e $(SRC) ]; \
		then echo "\033[;31mERROR: Can't find the source file, please check SRC variable \033[0m"; \
	else echo "Compiling the source files..."; \
		arduino-cli compile -b $(FQBN) --output-dir $(DIR); \
	fi

upload:
	@if [ ! -c $(DEVS) ]; \
		then echo "\033[;31mERROR: Device not available, please check DEVS variable \033[0m"; \
	else echo "Checking build directory..."; \
		if [ ! -d $(DIR) ]; \
			then echo "\033[;31mERROR: Build directory doesn't exits, please make verify first \033[0m"; \
		else echo "Uploading Sketch to Device..."; \
			arduino-cli upload -b $(FQBN) -p $(DEVS); \
		fi; \
	fi

monitor:
	@if [ ! -c $(DEVS) ]; \
		then echo "\033[;31mERROR: Device not available, please check DEVS variable \033[0m"; \
	else echo "Opening the arduino monitor..."; \
		arduino-cli monitor -p $(DEVS) ; \
	fi

config:
	@echo "Fully Qualified Board Name: "$(FQBN);
	@echo "The Serial Port of Board: "$(DEVS);
	@echo "The Name of Project: "$(PROJ);
	@echo "The Build Directory: "$(DIR);
	@echo "The Source File: "$(SRC);
	@echo "The Library File: "$(LIB);


clean:
	@if [ -d $(DIR) ]; \
		then echo "Cleaning the build directory..."; \
	    rm -rf $(DIR); \
	else echo "\033[;33mWARNING: The build directory doesn't exits \033[0m"; \
		echo "\033[;33mWARNING: You don't need to remove it at all\033[0m"; \
	fi

install:
	@if [ -e $(LIB) ]; \
	then while read -r i ; do echo ; \
		echo "Installing " '"'$$i'"' ; \
	  	arduino-cli lib install "$$i" ; \
	done < $(LIB); \
	else echo "\033[;31mERROR: libraries.txt dosen't exits \033[0m"; \
		echo "Create" $(LIB) "if is needed"; \
	fi
	
