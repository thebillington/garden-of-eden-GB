   IF !DEF(MEMORY_MAP_INC)
DEF MEMORY_MAP_INC = 1

DEF _HW          EQU $FF00
DEF _BLOCK0      EQU $8000 ; $8000->$87FF
DEF _BLOCK1      EQU $8800 ; $8800->$8FFF
DEF _BLOCK2      EQU $9000 ; $9000->$97FF

DEF _TILE_LEN EQU $10
DEF _PIPE_TILE_OFFSET EQU $C2
DEF _PIPE_TILE_VARIATIONS EQU $8

DEF _GAME_WINDOW_START EQU $9884
DEF _GAME_WINDOW_WIDTH EQU $C
DEF _GAME_WINDOW_HEIGHT EQU $A
DEF _GAME_WINDOW_OFFSET EQU $14

; Sprite VRAM map location
_SPRITE_VRAM EQU _BLOCK2

; Sprites

; -------- Usable RAM ------

; -------- OAM ------\ ; Using the first 160 bytes of RAM as OAM

; -------- GBT ------\ ; Next 128(67) bytes used by gbt_player

; Store previous button state [1 bytes]
PREV_BTN_STATE EQU _RAM + $A0 + $80

; Store interrupt state [1 bytes]
INTR_STATE EQU PREV_BTN_STATE + $01

; Random Number Generator (RNG) Seed [3 bytes]
SEED EQU INTR_STATE + $01

; Current tile DIR [1 bytes]
CUR_DIR EQU SEED + $03

; Fail flag, set if check failed [1 bytes]
FAIL_FLAG EQU CUR_DIR + $01

ENDC