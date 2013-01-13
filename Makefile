# Path to the NXC compiler relative to the Makefile
NXC=/Users/micha/bin/nbc
NXTCOM=/Users/micha/bin/nxtcom

# Options to pass to the compiler.
# Use -EF to specify we are using enhanced firmware.
# Use -d to specify we want to download to the brick.
OPTIONS= -EF -I=../$(SOURCE)/ 

# Program settings
#INTERFACE=BTH::NXT::00:16:53:17:BA:E0::1
INTERFACE=/dev/tty.NXT-DevB
SOURCE=source
BUILD=build
#PROGRAM=Tribot
PROGRAM=$(TARGET_NAME)
CALIBRATION=Calibration

ifeq ($(CONFIGURATION), Debug)
	DEPLOY=$(NXTCOM) -v -S=$(INTERFACE) ../$(BUILD)/$(PROGRAM).rxe
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

