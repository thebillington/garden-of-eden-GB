   IF !DEF(MEMORY_MAP_INC)
DEF MEMORY_MAP_INC = 1

DEF _HW          EQU $FF00
DEF _BLOCK0      EQU $8000 ; $8000->$87FF
DEF _BLOCK1      EQU $8800 ; $8800->$8FFF
DEF _BLOCK2      EQU $9000 ; $9000->$97FF

DEF _TILE_LEN EQU $10

; Sprite VRAM map location
_SPRITE_VRAM EQU _BLOCK2

; Sprites

; -------- Usable RAM ------

; -------- OAM ------\ ; Using the first 160 bytes of RAM as OAM

; -------- GBT ------\ ; Next 128(67) bytes used by gbt_player

; Store previous button state
PREV_BTN_STATE EQU _RAM + $A0 + $80

; Store interrupt state
INTR_STATE EQU PREV_BTN_STATE + $01

ENDC