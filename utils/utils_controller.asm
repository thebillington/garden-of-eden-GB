MACRO CheckMovement

    CheckHorizontalMovement

    CheckVerticalMovement

ENDM

MACRO CheckHorizontalMovement

.rightPadCheck\@

    ld a, [PREV_BTN_STATE]
    AND PADF_RIGHT                          ; Load the pad state and apply right button mask

    jr z, .leftPadCheck\@                   ; If right button isn't pressed, check for left button press

    MoveCursorX 8                           ; Move the player one to the right

    jr .endCheck\@                          ; If the right pad was checked, don't check the left pad

.leftPadCheck\@

    ld a, [PREV_BTN_STATE]
    AND PADF_LEFT                          ; Load the pad state and apply left button mask

    jr z, .endCheck\@                      ; If left button isn't pressed, end check state

    MoveCursorX -8                         ; Move the player 1 to the left

.endCheck\@

ENDM

MACRO CheckVerticalMovement

.downPadCheck\@

    ld a, [PREV_BTN_STATE]
    AND PADF_DOWN                           ; Load the pad state and apply right button mask

    jr z, .upPadCheck\@                   ; If right button isn't pressed, check for left button press

    MoveCursorY 8                           ; Move the player one to the right

    jr .endCheck\@                          ; If the right pad was checked, don't check the left pad

.upPadCheck\@

    ld a, [PREV_BTN_STATE]
    AND PADF_UP                          ; Load the pad state and apply left button mask

    jr z, .endCheck\@                      ; If left button isn't pressed, end check state

    MoveCursorY -8                         ; Move the player 1 to the left

.endCheck\@

ENDM