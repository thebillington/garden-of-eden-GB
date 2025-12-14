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

DEF CURSOR_START_POS_Y EQU $30                  ; Starting cursor y location
DEF CURSOR_START_POS_X EQU $28                  ; Starting cursor x location

DEF CHECK_CURSOR_START_POS_Y EQU $28                  ; Starting check cursor y location
DEF CHECK_CURSOR_START_POS_X EQU $28                  ; Starting check cursor x location

DEF MENU_CURSOR_START_POS_Y EQU $40                  ; Starting menu cursor y location
DEF MENU_CURSOR_START_POS_X EQU $20                  ; Starting menu cursor x location

DEF CURSOR_MAX_POS_Y EQU $30                    ; Max x and y bounds for cursor
DEF CURSOR_MIN_POS_Y EQU $78
DEF CURSOR_MIN_POS_X EQU $28
DEF CURSOR_MAX_POS_X EQU $80

DEF MENU_CURSOR_MAX_POS_Y EQU $40                    ; Max x and y bounds for menu cursor
DEF MENU_CURSOR_MIN_POS_Y EQU $60

DEF CORNER_PIECE_BOTTOM_RIGHT EQU $C2           ; Tile positions for corner tile maps
DEF CORNER_PIECE_BOTTOM_LEFT EQU $C3
DEF CORNER_PIECE_TOP_LEFT EQU $C4
DEF CORNER_PIECE_TOP_RIGHT EQU $C5

DEF STRAIGHT_PIECE_HORIZONTAL EQU $C6           ; Tile positions for straight tile map
DEF STRAIGHT_PIECE_VERTICAL EQU $C7

DEF MENU_PLAY_GAME_POSITION EQU $40
DEF MENU_INSTRUCTIONS_POSITION EQU $50
DEF MENU_CREDITS_POSITION EQU $60

DEF SOLVED_S EQU $E5
DEF SOLVED_O EQU $E1
DEF SOLVED_L EQU $DE
DEF SOLVED_V EQU $E8
DEF SOLVED_E EQU $D7
DEF SOLVED_D EQU $D6                            ; Tile positions for the SOLVED message

    ENDC ; CONSTANTS_INC