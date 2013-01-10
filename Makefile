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
SOURCE=source
BUILD=build
PROGRAM=Tribot
LINKBOT=IRLinkBot

############

all: $(PROGRAM).rxe

$(PROGRAM).rxe: $(SOURCE)/$(PROGRAM).nxc
	cd $(SOURCE); \
	echo $(ACTION); \
	$(NXC) -O=../$(BUILD)/$(PROGRAM).rxe  \
		$(OPTIONS) \
		$(PROGRAM).nxc 

$(LINKBOT).rxe: $(SOURCE)/$(LINKBOT).nxc
	cd $(SOURCE); \
	$(NXC) -O=../$(BUILD)/$(LINKBOT).rxe \
		$(OPTIONS) \
		$(LINKBOT).nxc
test:
	/usr/bin/touch $(SOURCE)/foobar

clean:
	/bin/rm -vf $(BUILD)/$(PROGRAM).rxe

#deploy: $(SOURCE)/$(PROGRAM).nxc
#	cd $(SOURCE); \
#	$(NXC) -O=../$(BUILD)/$(PROGRAM).rxe  \
#		$(OPTIONS) \
#		$(PROGRAM).nxc ;\
#	$(NXTCOM) -v -S=$(INTERFACE) ../$(BUILD)/$(PROGRAM).rxe

download: 
	$(NXTCOM) -v -S=$(INTERFACE) ../$(BUILD)/$(PROGRAM).rxe

