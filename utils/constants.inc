INCLUDE "hardware.inc"
INCLUDE "memory_map.inc"

    IF !DEF(CONSTANTS_INC)
DEF CONSTANTS_INC EQU 1

; -------- Constants --------
DEF _RAM_END EQU $DFFF                      ; $C000->$DFFF
DEF _VRAM_END EQU $9FFF                     ; $8000->$9FFF
DEF _BG_MAP EQU $9000                       ; $9000->$97FF

DEF OAMDATALOC EQU _RAM                     ; Using the first 160 bytes of RAM as OAM
DEF OAMDATALOCBANK EQU OAMDATALOC / $100    ; gets the upper byte of location

DEF DIR_UP EQU $1
DEF DIR_RIGHT EQU $2
DEF DIR_DOWN EQU $4
DEF DIR_LEFT EQU $8

EXPORT dir_table_data
EXPORT dir_table_data_end

DEF MAZE_IN_DIR EQU DIR_DOWN

CURSOR_START_POS_Y EQU $30                  ; Starting cursor y location
CURSOR_START_POS_X EQU $28                  ; Starting cursor x location

CHECK_CURSOR_START_POS_Y EQU $28                  ; Starting check cursor y location
CHECK_CURSOR_START_POS_X EQU $28                  ; Starting check cursor x location

MENU_CURSOR_START_POS_Y EQU $40                  ; Starting menu cursor y location
MENU_CURSOR_START_POS_X EQU $20                  ; Starting menu cursor x location

CURSOR_MAX_POS_Y EQU $30                    ; Max x and y bounds for cursor
CURSOR_MIN_POS_Y EQU $78
CURSOR_MIN_POS_X EQU $28
CURSOR_MAX_POS_X EQU $80

MENU_CURSOR_MAX_POS_Y EQU $40                    ; Max x and y bounds for menu cursor
MENU_CURSOR_MIN_POS_Y EQU $60

CORNER_PIECE_BOTTOM_RIGHT EQU $C2           ; Tile positions for corner tile maps
CORNER_PIECE_BOTTOM_LEFT EQU $C3
CORNER_PIECE_TOP_LEFT EQU $C4
CORNER_PIECE_TOP_RIGHT EQU $C5

STRAIGHT_PIECE_HORIZONTAL EQU $C6           ; Tile positions for straight tile map
STRAIGHT_PIECE_VERTICAL EQU $C7

MENU_PLAY_GAME_POSITION EQU $40
MENU_INSTRUCTIONS_POSITION EQU $50
MENU_CREDITS_POSITION EQU $60

SOLVED_S EQU $E5
SOLVED_O EQU $E1
SOLVED_L EQU $DE
SOLVED_V EQU $E8
SOLVED_E EQU $D7
SOLVED_D EQU $D6                            ; Tile positions for the SOLVED message

    ENDC ; CONSTANTS_INC