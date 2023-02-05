INCLUDE "hardware.inc"
INCLUDE "memory_map.inc"
INCLUDE "constants.inc"

MACRO Check
    ld hl, CUR_DIR
    ld [hl], MAZE_IN_DIR

    ld a, [hl]

.checkLoop\@
    cp DIR_UP
    jp z, .dirUp\@

    cp DIR_RIGHT
    jp z, .dirRight\@

    cp DIR_DOWN
    jp z, .dirDown\@

    cp DIR_LEFT
    jp z, .dirLeft\@

.dirUp\@
    MoveCheckCursorY -8
    ; A has tile number
    sub CORNER_PIECE_BOTTOM_RIGHT
    ; A has offset of pipe
    ld hl, dir_table
    ld bc, $0
    ld c, a
    add hl, bc
    ld a, [hl]
    ld b, a                 ; Backup CUR_DIR in B

    and DIR_DOWN            ; If DIR_UP is set then set NZ flag
    jp z, .failedCheck\@    ; If DIR_UP is not set, jump out of check

    ; Can move in dir as nex    pop aft tile in dir has oposite dir set
    ld a, b                 ; Restore CUR_DIR from backup
    and ~DIR_DOWN           ; Remove entry DIR from CUR_DIR
    ; Ready to loop

    jp .checkLoop\@
.dirRight\@
    MoveCheckCursorX 8
    ; A has tile number
    sub CORNER_PIECE_BOTTOM_RIGHT
    ; A has offset of pipe
    ld hl, dir_table
    ld bc, $0
    ld c, a
    add hl, bc
    ld a, [hl]
    ld b, a                 ; Backup CUR_DIR in B

    and DIR_LEFT            ; If DIR_UP is set then set NZ flag
    jp z, .failedCheck\@    ; If DIR_UP is not set, jump out of check

    ; Can move in dir as next tile in dir has oposite dir set
    ld a, b                 ; Restore CUR_DIR from backup
    and ~DIR_LEFT           ; Remove entry DIR from CUR_DIR
    ; Ready to loop

    jp .checkLoop\@
.dirDown\@
    MoveCheckCursorY 8
    jp .debug
    ; A has tile number
    sub CORNER_PIECE_BOTTOM_RIGHT
    ; A has offset of pipe
    ld hl, dir_table
    ld bc, $0
    ld c, a
    add hl, bc
    ld a, [hl]
    ld b, a                 ; Backup CUR_DIR in B

    and DIR_UP              ; If DIR_UP is set then set NZ flag
    jp z, .failedCheck\@    ; If DIR_UP is not set, jump out of check

    ; Can move in dir as next tile in dir has oposite dir set
    ld a, b                 ; Restore CUR_DIR from backup
    and ~DIR_UP             ; Remove entry DIR from CUR_DIR
    ; Ready to loop

    jp .checkLoop\@
.dirLeft\@
    MoveCheckCursorX -8
    ; A has tile number
    sub CORNER_PIECE_BOTTOM_RIGHT
    ; A has offset of pipe
    ld hl, dir_table
    ld bc, $0
    ld c, a
    add hl, bc
    ld a, [hl]
    ld b, a                 ; Backup CUR_DIR in B

    and DIR_RIGHT           ; If DIR_UP is set then set NZ flag
    jp z, .failedCheck\@    ; If DIR_UP is not set, jump out of check

    ; Can move in dir as next tile in dir has oposite dir set
    ld a, b                 ; Restore CUR_DIR from backup
    and ~DIR_RIGHT          ; Remove entry DIR from CUR_DIR
    ; Ready to loop

    jp .checkLoop\@
.failedCheck\@
    ld hl, FAIL_FLAG
    ld [hl], $1
ENDM

MACRO GetNextDIR
; \1 will be the direction of the next tile
; need someway to locate current tile
; OUTPUT: Load A with DIR of next block
;         Set location of next block in ram

ENDM