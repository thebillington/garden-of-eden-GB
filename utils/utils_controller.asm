INCLUDE "hardware.inc"
INCLUDE "memory_map.inc"
INCLUDE "constants.inc"

MACRO CheckMovement

    LoadCanMove
    jp nz, .endCheck\@                       ; If cursor can't move, end check

    CheckHorizontalMovement
    CheckVerticalMovement                   ; Check horizontal and vertical movement

    SetCursorPosition                       ; Set the cursor offset position

.endCheck\@

ENDM

MACRO CheckHorizontalMovement

.rightPadCheck\@

    ld a, [PREV_BTN_STATE]
    AND PADF_RIGHT                          ; Load the pad state and apply right button mask

    jr z, .leftPadCheck\@                   ; If right button isn't pressed, check for left button press

    ld d, CURSOR                            ; Point d to the cursor sprite
    ld e, CURSOR_MAX_POS_X                  ;  Set e to the max x position

    Spr_getX d                              ; Load the x position of the sprite
    ld a, [hl]                              ; Load a with the sprite x location
    sub e                                   ; Subtract the cursor max position

    jr z, .endCheck\@                       ; If the position is already equal to the max, end the check

    MoveCursorX 8                           ; Move the player one to the right

    jr .endCheck\@                          ; If the right pad was checked, don't check the left pad

.leftPadCheck\@

    ld a, [PREV_BTN_STATE]
    AND PADF_LEFT                          ; Load the pad state and apply left button mask

    jr z, .endCheck\@                      ; If left button isn't pressed, end check state

    ld d, CURSOR                               ; Point d to the cursor sprite
    ld e, CURSOR_MIN_POS_X                  ;  Set e to the min x position

    Spr_getX d                              ; Load the x position of the sprite
    ld a, [hl]                              ; Load a with the sprite x location
    sub e                                   ; Subtract the cursor min position

    jr z, .endCheck\@                       ; If the position is already equal to the min, end the check

    MoveCursorX -8                         ; Move the player 1 to the left

.endCheck\@

ENDM

MACRO CheckVerticalMovement

.downPadCheck\@

    ld a, [PREV_BTN_STATE]
    AND PADF_DOWN                           ; Load the pad state and apply right button mask

    jr z, .upPadCheck\@                   ; If right button isn't pressed, check for left button press

    ld d, CURSOR                               ; Point d to the cursor sprite
    ld e, CURSOR_MIN_POS_Y                  ;  Set e to the min y position

    Spr_getY d                              ; Load the y position of the sprite
    ld a, [hl]                              ; Load a with the sprite y location
    sub e                                   ; Subtract the cursor min position

    jr z, .endCheck\@                       ; If the position is already equal to the min, end the check

    MoveCursorY 8                           ; Move the player one to the right

    jr .endCheck\@                          ; If the right pad was checked, don't check the left pad

.upPadCheck\@

    ld a, [PREV_BTN_STATE]
    AND PADF_UP                          ; Load the pad state and apply left button mask

    jr z, .endCheck\@                      ; If left button isn't pressed, end check state

    ld d, CURSOR                               ; Point d to the cursor sprite
    ld e, CURSOR_MAX_POS_Y                  ;  Set e to the max y position

    Spr_getY d                              ; Load the y position of the sprite
    ld a, [hl]                              ; Load a with the sprite y location
    sub e                                   ; Subtract the cursor min position

    jr z, .endCheck\@                       ; If the position is already equal to the max, end the check

    MoveCursorY -8                         ; Move the player 1 to the left

.endCheck\@

ENDM

MACRO EnableMovement

    ld a, 1
    ld hl, CAN_MOVE
    ld [hl], a                      ; Enable movement

ENDM

MACRO DisableMovement

    ld a, 0
    ld hl, CAN_MOVE
    ld [hl], a                      ; Disable movement

ENDM

MACRO LoadCanMove

    ld hl, CAN_MOVE
    ld a, [hl]
    cp CAN_MOVE_COUNT

ENDM