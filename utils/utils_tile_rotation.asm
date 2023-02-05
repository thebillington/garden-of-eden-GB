INCLUDE "hardware.inc"
INCLUDE "memory_map.inc"
INCLUDE "constants.inc"

MACRO CheckTileRotation

    LoadCanMove
    jp nz, .endCheck\@                  ; If cursor can't move, end check

.aPadCheck\@

    FetchJoypadState
    AND PADF_A                          ; Load the pad state and apply A button mask

    jp z, .bPadCheck\@                  ; If right button isn't pressed, check for left button press

    RotateTile 1                       ; Rotate anticlockwise

    jp .endCheck\@                      ; Don't check B if A pressed

.bPadCheck\@

    FetchJoypadState
    AND PADF_B                          ; Load the pad state and apply A button mask

    jp z, .endCheck\@                   ; If right button isn't pressed, check for left button press

    RotateTile -1                       ; Rotate clockwise

.endCheck\@

ENDM

MACRO RotateTile

    GetCursorTile                   ; Fetch the cursor tile into memory

.bottomRightCorner\@

    cp CORNER_PIECE_BOTTOM_RIGHT    ; Compare to the corner piece

    jr nz, .bottomLeftCorner\@        ; Skip check if no match
    
    RotateCornerPiece \1            ; If this is a corner piece, rotate corner

    jp .endCheck\@                  ; End check

.bottomLeftCorner\@

    cp CORNER_PIECE_BOTTOM_LEFT    ; Compare to the corner piece

    jr nz, .topLeftCorner\@           ; Skip check if no match
    
    RotateCornerPiece \1            ; If this is a corner piece, rotate corner

    jp .endCheck\@                  ; End check

.topLeftCorner\@

    cp CORNER_PIECE_TOP_LEFT       ; Compare to the corner piece

    jr nz, .topRightCorner\@       ; Skip check if no match
    
    RotateCornerPiece \1           ; If this is a corner piece, rotate corner

    jp .endCheck\@                 ; End check

.topRightCorner\@

    cp CORNER_PIECE_TOP_RIGHT      ; Compare to the corner piece

    jr nz, .endCheck\@          ; Skip check if no match
    
    RotateCornerPiece \1            ; If this is a corner piece, rotate corner

.endCheck\@

ENDM

MACRO RotateCornerPiece

    ld e, \1                        ; Load passed parameter (direction of rotation)

    ld a, [hl]
    add e                           ; Load the current selected tile and inc/dec
    ld [hl], a                      ; Put the new tile back in

.checkTopWrap\@

    cp CORNER_PIECE_BOTTOM_RIGHT + $04

    jr nz, .checkBottomWrap\@

    ld a, CORNER_PIECE_BOTTOM_RIGHT
    ld [hl], a

    jr .endCheck\@

.checkBottomWrap\@

    cp CORNER_PIECE_BOTTOM_RIGHT - $01

    jr nz, .endCheck\@

    ld a, CORNER_PIECE_TOP_RIGHT
    ld [hl], a

.endCheck\@

    DisableMovement                 ; Debounce

ENDM

MACRO RotateStraightPiece

ENDM