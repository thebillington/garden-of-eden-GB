INCLUDE "hardware.inc"
INCLUDE "memory_map.inc"
INCLUDE "constants.inc"

; -------- Loading Macros --------
; Copys data from src address to dst address
MACRO CopyData

    ld hl, \1               ; Load HL with pointer to dst address
    ld de, \2               ; Load DE with pointer to the start of src data
    ld bc, \3 - \2          ; Load BC with pointer to the end of src data

.copyDataLoop\@
    ld a, [de]              ; Load src data into A
    ld [hli], a             ; Load A into dst address and move to next address
    inc de                  ; Move to next src data address
    dec bc                  ; Decrement length of src data (count)
    ld a, b                 ; Load A with 8 LSBs of count
    or c                    ; OR count 8 LSBs with its 8 MSBs
    jr nz, .copyDataLoop\@  ; If the result is not zero (BC ~= 0), continue loop
ENDM

; Load image data and map to VRAM
MACRO LoadImage
; -------- Load image data ------
    CopyData _VRAM, \1, \2

; -------- Load image map ------
    CopyData _SCRN0, \3, \4
ENDM

; Load image data and map to VRAM, switch screen
MACRO LoadImageSwitched
    SwitchScreenOff

    LoadImage \1, \2, \3, \4    ; LoadImage MACRO

    SwitchScreenOn \5
ENDM

; Load an image file from bank
MACRO LoadImageBanked

    ld a, BANK(\1)              ; Load bank containing the label to a
    ld [rROMB0], a              ; Load bank to bank register to switch

    LoadImage \1, \2, \3, \4    ; LoadImage MACRO

ENDM

; Load an image file from bank, switch screen
MACRO LoadImageBankedSwitched
    SwitchScreenOff

    LoadImageBanked \1, \2, \3, \4  ; LoadImageBanked MACRO

    SwitchScreenOn \5

ENDM