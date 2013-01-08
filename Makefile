# Path to the NXC compiler relative to the Makefile
NXC=/Users/micha/bin/nbc

# Options to pass to the compiler.
# Use -EF to specify we are using enhanced firmware.
# Use -d to specify we want to download to the brick.
OPTIONS= -I=../$(SOURCE)/ 

# Program settings
#INTERFACE=BTH::NXT::00:16:53:17:BA:E0::1
INTERFACE=usb
SOURCE=source
BUILD=build
PROGRAM=Tribot


############

all: $(PROGRAM).rxe

$(PROGRAM).rxe: $(SOURCE)/$(PROGRAM).nxc
	cd $(SOURCE); \
	$(NXC) -O=../$(BUILD)/$(PROGRAM).rxe  \
		$(OPTIONS) \
		$(PROGRAM).nxc 

clean:
	/bin/rm -vf $(BUILD)/$(PROGRAM).rxe

# This is only to deploy to the NXT

deploy: $(SOURCE)/$(PROGRAM).nxc
	cd $(SOURCE); \
	$(NXC) -d -S=$(INTERFACE) -O=../$(BUILD)/$(PROGRAM).rxe  \
		$(OPTIONS) \
		$(PROGRAM).nxc 

run: $(SOURCE)/$(PROGRAM).nxc
	cd $(SOURCE); \
	$(NXC) -r -S=$(INTERFACE) -O=../$(BUILD)/$(PROGRAM).rxe  \
		$(OPTIONS) \
		$(PROGRAM).nxc 
