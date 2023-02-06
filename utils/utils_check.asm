INCLUDE "hardware.inc"
INCLUDE "memory_map.inc"
INCLUDE "constants.inc"

MACRO CheckSolved
    ld hl, CUR_DIR
    ld [hl], MAZE_IN_DIR

    ld a, [hl]

.checkLoop\@
    push af
    WaitVBlankIF                        ; Wait for VBlank interrupt (this should get us running at ~60Hz)
    pop af

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
    sub CORNER_PIECE_BOTTOM_RIGHT
    HandleCrossover $0
    ld hl, DIR_TABLE
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
    sub CORNER_PIECE_BOTTOM_RIGHT
    HandleCrossover $1
    ld hl, DIR_TABLE
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
    cp $CC                  ; Check for solved state
    jp z, .passedCheck\@

    sub CORNER_PIECE_BOTTOM_RIGHT
    HandleCrossover $0
    ld hl, DIR_TABLE
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
    sub CORNER_PIECE_BOTTOM_RIGHT
    HandleCrossover $1
    ld hl, DIR_TABLE
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
    SetCheckCursorXY CHECK_CURSOR_START_POS_X, CHECK_CURSOR_START_POS_Y
    jr .end\@

.passedCheck\@
    ld hl, STATE_FLAG
    ld [hl], $1

.end\@
ENDM

MACRO HandleCrossover
    cp $6               ; If pipe is not corssover, set NZ flag
    jr nz, .skip\@      ; Skip macro if pipe is not crossover

    ld b, a             ; Backup A register
    ld a, \1            ; load A with dir input
    and $1              ; Check weather param is 0: Vertical, 1: Horizontal

    jr nz, .handleHorizontal\@

.handleVertical\@
    ld a, $5
    ld hl, DIR_TABLE
    ld c, b
    ld b, $0
    add hl, bc
    ld [hl], a
    ld a, c                 ; Backup CUR_DIR in B
    jr .skip\@

.handleHorizontal\@
    ld a, $A
    ld hl, DIR_TABLE
    ld c, b
    ld b, $0
    add hl, bc
    ld [hl], a
    ld a, c                 ; Backup CUR_DIR in B

.skip\@
ENDM