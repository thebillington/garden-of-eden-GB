INCLUDE "hardware.inc"
INCLUDE "memory_map.inc"
INCLUDE "constants.inc"

MACRO LoadMenuCursor

    UnloadCursor
    UnloadCheckCursor                   ; Unload game cursors

    ld d, MENU_CURSOR

    Spr_getY d
    ld a, MENU_CURSOR_START_POS_Y
	ld [hl], a
    
    Spr_getX d
    ld a, MENU_CURSOR_START_POS_X
	ld [hl], a        

    Spr_getTile d
    ld a, $DE
    ld [hl], a

    Spr_getAttr d
    ld [hl], OAMF_PAL0

ENDM

MACRO UnloadMenuCursor

    ld d, MENU_CURSOR

    Spr_getY d
    ld a, 0
	ld [hl], a
    
    Spr_getX d
    ld a, 0
	ld [hl], a        

ENDM

MACRO CursorMovement

    LoadCanMove
    jp nz, .endCheck\@                  ; If menu cursor can't move, end check

.downMenuCheck
; -------- Check for DOWN button press ------
    ld a, c
    and PADF_DOWN      ; If down then set NZ flag

    jp z, .upMenuCheck\@       ; If down not pressed skip to next check

    CheckMenuCursorBoundsY MENU_CURSOR_MIN_POS_Y
    jr z, .upMenuCheck\@                            ; If the position is already equal to the min, end the check

    MoveMenuCursorY $10
    jr .endCheck\@

.upMenuCheck\@
; -------- Check for UP button press ------
    ld a, c
    and PADF_UP      ; If up then set NZ flag

    jp z, .endCheck\@       ; If up not pressed end check

    CheckMenuCursorBoundsY MENU_CURSOR_MAX_POS_Y
    jr z, .endCheck\@                               ; If the position is already equal to the max, end the check

    MoveMenuCursorY -$10

.endCheck\@

ENDM

MACRO MoveMenuCursorY

    ld d, MENU_CURSOR               ; Load cursor sprite position into d
    ld e, \1                        ; Load movement direction into e

    Spr_getY d                      ; Get the sprite y position pointer
    ld a, [hl]                      ; Load the y position into a
    add e                           ; Add the movement direction (1 or -1)
    ld [hl], a                      ; Store the result

    DisableMovement

ENDM

MACRO CheckMenuCursorBoundsY

    ld d, MENU_CURSOR                       ; Point d to the cursor sprite
    ld e, \1                                ;  Set e to the specified bound

    Spr_getY d                              ; Load the y position of the sprite
    ld a, [hl]                              ; Load a with the sprite y location
    sub e                                   ; Subtract the cursor min position

ENDM

MACRO LoadMenuCursorY

    ld d, MENU_CURSOR

    Spr_getY d
	ld a, [hl]                          ; Load y position of the menu cursor into a

ENDM