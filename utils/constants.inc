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

CURSOR_START_POS_Y EQU $30                  ; Starting cursor y location
CURSOR_START_POS_X EQU $28                  ; Starting cursor x location

CURSOR_MAX_POS_Y EQU $30                    ; Max x and y bounds for cursor
CURSOR_MIN_POS_Y EQU $78
CURSOR_MIN_POS_X EQU $28
CURSOR_MAX_POS_X EQU $80

    ENDC ; CONSTANTS_INC