INCLUDE "hardware.inc"
INCLUDE "memory_map.inc"
INCLUDE "constants.inc"

; -------- Hardware Macros --------
; Waits for VBLANK before commiting any memory to VRAM
MACRO WaitVBlank

.waitVBlank\@
    ld a, [rLY]             ; Load LCDC Y-Coordinate into A
    cp a, SCRN_Y            ; rLY - SCRN_Y
    jr c, .waitVBlank\@     ; if rLY < SCRN_Y then jump to .waitVBlank
ENDM

; Gets the joypad state
MACRO FetchJoypadState

    ld a, $20       ; Mask to pull bit 4 low (read the D pad)           #TODO: Replace hard coded value with EQU
    ld [_HW], a     ; Pull bit 4 low
    ld a, [_HW]     ; Read the value of the inputs
    ld a, [_HW]     ; Read again to avoid debounce

    cpl             ; (A = ~A)
    and $0F         ; Remove top 4 bits

    swap a          ; Move the lower 4 bits to the upper 4 bits
    ld b, a         ; Save the buttons states to b

    ld a, $10       ; Mask to pull bit 4 low (read the buttons pad)     #TODO: Replace hard coded value with EQU
    ld [_HW], a     ; Pull bit 4 low
    ld a, [_HW]     ; Read the value of the inputs
    ld a, [_HW]     ; Read again to avoid debounce

    cpl             ; (A = ~A)
    and $0F         ; Remove top 4 bits

    or b            ; Combine with the button states

    ld [PREV_BTN_STATE], a   ; store current state in RAM - use EQU

ENDM

; Check state of button press
MACRO JpIfButtonHeld

; -------- Check button state ---------
    ld a, [PREV_BTN_STATE]      ; Load last state from RAM - use EQU
    AND \1                      ; apply button mask
    ld b, a                     ; Load current state into b

    push bc
    FetchJoypadState            ; Check for button press
    AND \1                      ; apply button mask

    pop bc

    xor b                       ; Compare stored state vs current state

    jp z, \2    ; if not 0 jump to passed label
ENDM

; Only continue if VBlank interrupt
MACRO WaitVBlankIF
.loop\@
    halt                ; Wait till interrupt
    ld a, [INTR_STATE]  ; Load INTR_STATE to A
    and IEF_VBLANK      ; AND A with IEF_VBLANK
    jp z, .loop\@       ; If z then jump to loop
    ld hl, INTR_STATE   ; Load INTR_STATE loc to A
    ld [hl], $0         ; Clear INTR_STATE
ENDM

; Switch screen off
MACRO SwitchScreenOn
    ld a, \1
    ld [rLCDC], a
ENDM

; Switch screen off
MACRO SwitchScreenOff
    xor a           ; (ld a, 0)
    ld [rLCDC], a   ; Load A into LCDC register
ENDM