INCLUDE "hardware.inc"
INCLUDE "memory_map.inc"
INCLUDE "constants.inc"

MACRO LoadCheckCursor

    ld d, CHECK_CURSOR

    Spr_getY d
    ld a, CHECK_CURSOR_START_POS_Y
	ld [hl], a
    
    Spr_getX d
    ld a, CHECK_CURSOR_START_POS_X
	ld [hl], a        

    Spr_getTile d
    ld a, $D2
    ld [hl], a

    Spr_getAttr d
    ld [hl], OAMF_PAL0

ENDM

MACRO SetCheckCursorY

    ld d, CHECK_CURSOR                    ; Load cursor sprite position into d
    ld a, \1                        ; Load new position into a

    Spr_getY d                      ; Get the sprite y position pointer
    ld [hl], a                      ; Put the new position into the sprite y location

    SetCheckCursorPosition
    GetCheckCursorTile              ; Put the tile data for the new position in a register

ENDM

MACRO SetCheckCursorX

    ld d, CHECK_CURSOR                    ; Load cursor sprite position into d
    ld a, \1                        ; Load new position into a

    Spr_getX d                      ; Get the sprite x position pointer
    ld [hl], a                      ; Put the new position into the sprite x location

    SetCheckCursorPosition
    GetCheckCursorTile              ; Put the tile data for the new position in a register

ENDM

MACRO MoveCheckCursorY

    ld d, CHECK_CURSOR                    ; Load cursor sprite position into d
    ld e, \1                        ; Load movement direction into e

    Spr_getY d                      ; Get the sprite y position pointer
    ld a, [hl]                      ; Load the y position into a
    add e                           ; Add the movement direction (1 or -1)
    ld [hl], a                      ; Store the result

    SetCheckCursorPosition
    GetCheckCursorTile              ; Put the tile data for the new position in a register

ENDM

MACRO MoveCheckCursorX

    ld d, CHECK_CURSOR                    ; Load cursor sprite position into d
    ld e, \1                        ; Load movement direction into e

    Spr_getX d                      ; Get the sprite x position pointer
    ld a, [hl]                      ; Load the x position into a
    add e                           ; Add the movement direction (1 or -1)
    ld [hl], a                      ; Store the result

    SetCheckCursorPosition
    GetCheckCursorTile              ; Put the tile data for the new position in a register

ENDM

MACRO SetCheckCursorPosition

    ld d, CHECK_CURSOR                    ; Load cursor sprite position into d

    Spr_getX d                      ; Get the sprite x position pointer
    ld a, [hl]                      ; Load the x position into a

    DIVIDEA $08                     ; Resolve the pixel location into a Tile by dividing by no. of pixels
    sub $02                         ; Resolve the offset

    ld b, a                         ; Store the result in b

    ld d, CHECK_CURSOR                    ; Load cursor sprite position into d

    Spr_getY d                      ; Get the sprite y position pointer
    ld a, [hl]                      ; Load the y position into a

    DIVIDEA $08                     ; Resolve the pixel location into a Tile by dividing by no. of pixels
    SUB 3                           ; Account for the fact tiles are drawn from the bottom up

    MULTA $1F                       ; Multiply by 32 to get the tiles row number

    add b                           ; Add the x offset

    ld hl, CHECK_CURSOR_POSITION_RIGHT
    ld [hl], a                      ; Store the result

    ld hl, MULT_A_DID_CARRY
    ld a, [hl]
    ld hl, CHECK_CURSOR_POSITION_LEFT
    add $98
    ld [hl], a                      ; Store the tile position left bit based on whether we carried

ENDM

MACRO GetCheckCursorTile

    ld hl, CHECK_CURSOR_POSITION_LEFT
    ld a, [hl]
    ld b, a                             ; Store the left cursor pointer in b

    ld hl, CHECK_CURSOR_POSITION_RIGHT
    ld a, [hl]
    ld c, a                             ; Store the right cursor pointer in c

    ld hl, 0
    add hl, bc                          ; Load hl with the pointer to the memory map tile for cursor

    ld a, [hl]                          ; Load the tile map pointer for the cursor

ENDM