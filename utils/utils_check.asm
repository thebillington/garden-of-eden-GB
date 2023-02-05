INCLUDE "hardware.inc"
INCLUDE "memory_map.inc"
INCLUDE "constants.inc"

MACRO Check

    ld hl, CUR_DIR
    ld [hl], MAZE_IN_DIR

.loop\@

    ld a, [hl]

    and DIR_UP
    jr nz, .dirUp

    and DIR_RIGHT
    jr nz, .dirRight

    and DIR_DOWN
    jr nz, .dirDown

    and DIR_LEFT
    jr nz, .dirLeft

.dirUp
    GetNextDIR DIR_UP       ; Get the next tile DIR in A
    ld f, a                 ; Backup CUR_DIR in F

    and DIR_DOWN            ; If DIR_DOWN is set then set NZ flag
    jr z, .failedCheck\@    ; If DIR_DOWN is not set, jump out of check

    ; Can move in dir as next tile in dir has oposite dir set
    ld a, f                 ; Restore CUR_DIR from backup
    and ~DIR_DOWN           ; Remove entry DIR from CUR_DIR
    ; Ready to loop

    jr .loop\@
.dirRight
    GetNextDIR DIR_RIGHT    ; Get the next tile DIR in A
    ld f, a                 ; Backup CUR_DIR in F

    and DIR_LEFT            ; If DIR_LEFT is set then set NZ flag
    jr z, .failedCheck\@    ; If DIR_LEFT is not set, jump out of check

    ; Can move in dir as next tile in dir has oposite dir set
    ld a, f                 ; Restore CUR_DIR from backup
    and ~DIR_LEFT           ; Remove entry DIR from CUR_DIR
    ; Ready to loop

    jr .loop\@
.dirRDown
    GetNextDIR DIR_DOWN     ; Get the next tile DIR in A
    ld f, a                 ; Backup CUR_DIR in F

    and DIR_UP              ; If DIR_UP is set then set NZ flag
    jr z, .failedCheck\@    ; If DIR_UP is not set, jump out of check

    ; Can move in dir as next tile in dir has oposite dir set
    ld a, f                 ; Restore CUR_DIR from backup
    and ~DIR_UP             ; Remove entry DIR from CUR_DIR
    ; Ready to loop

    jr .loop\@
.dirLeft
    GetNextDIR DIR_LEFT     ; Get the next tile DIR in A
    ld f, a                 ; Backup CUR_DIR in F

    and DIR_RIGHT           ; If DIR_RIGHT is set then set NZ flag
    jr z, .failedCheck\@    ; If DIR_RIGHT is not set, jump out of check

    ; Can move in dir as next tile in dir has oposite dir set
    ld a, f                 ; Restore CUR_DIR from backup
    and ~DIR_RIGHT          ; Remove entry DIR from CUR_DIR
    ; Ready to loop

    jr .loop\@

.failedCheck\@
    ld hl, FAIL_FLAG
    ld [hl], $1
ENDMs

MACRO GetNextDIR
; \1 will be the direction of the next tile
; need someway to locate current tile
; OUTPUT: Load A with DIR of next block
;         Set location of next block in ram
ENDM