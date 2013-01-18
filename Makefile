# Path to the NXC compiler relative to the Makefile
NXC=/Users/micha/bin/nbc
NXTCOM=/Users/micha/bin/nxtcom

# Options to pass to the compiler.
# Use -EF to specify we are using enhanced firmware.
# Use -d to specify we want to download to the brick.

OPTIONS= -I=../$(SOURCE)/ 

# Program settings
#INTERFACE=BTH::NXT::00:16:53:17:BA:E0::1
INTERFACE=/dev/tty.NXT-DevB

# second Interface is for the second NXT brick
# There might be a more elegant way to do this...

INTERFACE2=/dev/tty.NXT-MI1-DevB

SOURCE=source
BUILD=build
#PROGRAM=Tribot
PROGRAM=$(TARGET_NAME)
CALIBRATION=Calibration

#
# If "Build for test" the program will be downloaded to the
# default brick
#

ifeq ($(CONFIGURATION), Debug)
	DEPLOY=$(NXTCOM) -v -S=$(INTERFACE) ../$(BUILD)/$(PROGRAM).rxe
endif

# For the second brick I've created a new config which is used
# for "Build for test"

ifeq ($(CONFIGURATION), NXT-MI1)
	DEPLOY=$(NXTCOM) -v -S=$(INTERFACE2) ../$(BUILD)/$(PROGRAM).rxe
endif


############

all: $(PROGRAM).rxe

$(PROGRAM).rxe: $(SOURCE)/$(PROGRAM).nxc
	cd $(SOURCE); \
	$(NXC) -O=../$(BUILD)/$(PROGRAM).rxe  \
		$(OPTIONS) \
		$(PROGRAM).nxc ; \
	$(DEPLOY)	

test:
	/usr/bin/touch $(SOURCE)/foobar

clean:
	/bin/rm -vf $(BUILD)/*.rxe


download: 
	$(NXTCOM) -v -S=$(INTERFACE) ../$(BUILD)/$(PROGRAM).rxe

