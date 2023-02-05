INCLUDE "hardware.inc"
INCLUDE "memory_map.inc"
INCLUDE "constants.inc"

MACRO LoadCursor

    ld d, $00

    Spr_getY d
    ld a, CURSOR_START_POS_Y
	ld [hl], a
    
    Spr_getX d
    ld a, CURSOR_START_POS_X
	ld [hl], a        

    Spr_getTile d
    ld a, $D2
    ld [hl], a

    Spr_getAttr d
    ld [hl], OAMF_PAL0

ENDM

Macro MoveCursorY

    ld d, $00
    ld e, \1

    Spr_getY d
    ld a, [hl]
    add e
    ld [hl], a

ENDM

Macro MoveCursorX

    ld d, $00
    ld e, \1

    Spr_getX d
    ld a, [hl]
    add e
    ld [hl], a

ENDM