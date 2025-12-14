   IF !DEF(MEMORY_MAP_INC)
DEF MEMORY_MAP_INC = 1

DEF _HW          EQU $FF00
DEF _BLOCK0      EQU $8000 ; $8000->$87FF
DEF _BLOCK1      EQU $8800 ; $8800->$8FFF
DEF _BLOCK2      EQU $9000 ; $9000->$97FF

DEF _TILE_LEN EQU $10
DEF _PIPE_TILE_OFFSET EQU $C2
DEF _PIPE_TILE_VARIATIONS EQU $7

DEF _GAME_WINDOW_START EQU $9884
DEF _GAME_WINDOW_WIDTH EQU $C
DEF _GAME_WINDOW_HEIGHT EQU $A
DEF _GAME_WINDOW_OFFSET EQU $14

DEF CAN_MOVE_COUNT EQU $3

; Sprite VRAM map location
DEF _SPRITE_VRAM EQU _BLOCK2

; Sprites

DEF CURSOR EQU $00
DEF CHECK_CURSOR EQU $01
DEF MENU_CURSOR EQU $02

; -------- Usable RAM ------

; -------- OAM ------\ ; Using the first 160 bytes of RAM as OAM

; -------- GBT ------\ ; Next 128(67) bytes used by gbt_player

; Store previous button state [1 bytes]
DEF PREV_BTN_STATE EQU _RAM + $A0 + $80

; Store interrupt state [1 bytes]
DEF INTR_STATE EQU PREV_BTN_STATE + $01

; Random Number Generator (RNG) Seed [3 bytes]
DEF SEED EQU INTR_STATE + $01

; Current tile DIR [1 bytes]
DEF CUR_DIR EQU SEED + $03

; State flag, set if check passed or failed [1 bytes]
DEF STATE_FLAG EQU CUR_DIR + $01

; Boolean flag to state weather the game loop has started [1 bytes]
DEF GAME_START EQU STATE_FLAG + $01

; Boolean flag to state whether player can move [1 bytes]
DEF CAN_MOVE EQU GAME_START + $01

; Boolean flag to state whether a multiply did carry [1 bytes]
DEF MULT_A_DID_CARRY EQU CAN_MOVE + $01

; Tile position of the cursor [2 bytes]
DEF CURSOR_POSITION_LEFT EQU MULT_A_DID_CARRY + $01
DEF CURSOR_POSITION_RIGHT EQU CURSOR_POSITION_LEFT + $01

; Tile position of the check cursor [2 bytes]
DEF CHECK_CURSOR_POSITION_LEFT EQU CURSOR_POSITION_RIGHT + $01
DEF CHECK_CURSOR_POSITION_RIGHT EQU CHECK_CURSOR_POSITION_LEFT + $01

; Tile position of the menu cursor [2 bytes]
DEF MENU_CURSOR_POSITION_LEFT EQU CHECK_CURSOR_POSITION_RIGHT + $01
DEF MENU_CURSOR_POSITION_RIGHT EQU MENU_CURSOR_POSITION_LEFT + $01

; DIR table for the solving algorthm [7 bytes]
DEF DIR_TABLE EQU MENU_CURSOR_POSITION_RIGHT + $1
ENDC