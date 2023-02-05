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

EXPORT dir_table
EXPORT dir_table_end

DEF MAZE_IN_DIR EQU DIR_DOWN

CURSOR_START_POS_Y EQU $30                  ; Starting cursor y location
CURSOR_START_POS_X EQU $28                  ; Starting cursor x location

CURSOR_MAX_POS_Y EQU $30                    ; Max x and y bounds for cursor
CURSOR_MIN_POS_Y EQU $78
CURSOR_MIN_POS_X EQU $28
CURSOR_MAX_POS_X EQU $80

CORNER_PIECE_BOTTOM_RIGHT EQU $C2           ; Tile positions for corner tile maps
CORNER_PIECE_BOTTOM_LEFT EQU $C3
CORNER_PIECE_TOP_LEFT EQU $C4
CORNER_PIECE_TOP_RIGHT EQU $C5

STRAIGHT_PIECE_HORIZONTAL EQU $C6           ; Tile positions for straight tile map
STRAIGHT_PIECE_VERTICAL EQU $C7

    ENDC ; CONSTANTS_INC