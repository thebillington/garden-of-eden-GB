NAME = main

SRC = ./main.asm ./images/images.asm

OBJS = $(SRC:.asm=.o)

ASM = rgbasm
LINK = rgblink
FIX = rgbfix

ASMFLAGS = -v -i ./music/ -i ./images/ -i ./utils/
LINKFLAGS = -v -w -n $@.sym -m $@.map -p 0xFF
FIXFLAGS = -v -m 0x19 -p 0xFF

all:
	$(MAKE) entry || $(MAKE) clean

entry: $(NAME)
	@printf "Fixing $<.gb...\n"
	$(FIX) $(FIXFLAGS) $<.gb
	@rm -f ./*.o
	@rm -f ./images/*.o
	@rm -f ./music/*.o
	@printf "DONE\n\n"

$(NAME): $(OBJS)
	@printf "Linking $(OBJS) to $@.gb...\n"
	$(LINK) $(LINKFLAGS) -o $@.gb $(OBJS)
	@printf "DONE\n\n"

$(OBJS): $(SRC)
	@printf "Assembling $*.asm to $@\n"
	$(ASM) $(ASMFLAGS) -o $@ $*.asm
	@printf "DONE\n\n"

.PHONY: clean
clean:
	@printf "Cleaning work space...\n"
	@rm -f ./*.gb
	@rm -f ./*.sym
	@rm -f ./*.map

	@rm -f ./*.o
	@rm -f ./images/*.o
	@rm -f ./music/*.o
	@printf "DONE\n"