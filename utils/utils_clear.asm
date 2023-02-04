INCLUDE "hardware.inc"
INCLUDE "memory_map.inc"
INCLUDE "constants.inc"

; -------- Clearing Macros --------
; Writes 0s to RAM
MACRO ClearRAM

    ld hl, _RAM             ; Load HL with pointer to RAM
    ld bc, _RAM_END - _RAM  ; Load BC with length of RAM

.clearRAMLoop\@
    xor a                   ; (ld a, $00)
    ld [hl], a              ; Set RAM address to 0
    inc hl                  ; Load HL with next RAM address
    dec bc                  ; Decrement length of RAM (count)
    ld a, c                 ; Load A with 8 LSBs of count
    or b                    ; OR count 8 LSBs with its 8 MSBs 
    jr nz, .clearRAMLoop\@  ; If result is not zero (BC ~= 0), continue loop
ENDM

; Writes 0s to VRAM (TURN SCREEN OFF FIRST)
MACRO ClearVRAM

    ld hl, _VRAM                ; Load HL with pointer to RAM
    ld bc, _VRAM_END - _VRAM    ; Load BC with length of RAM

.clearVRAMLoop\@
    xor a                       ; (ld a, $00)
    ld [hl], a                  ; Set RAM address to 0
    inc hl                      ; Load HL with next RAM address
    dec bc                      ; Decrement length of RAM (count)
    ld a, c                     ; Load A with 8 LSBs of count
    or b                        ; OR count 8 LSBs with its 8 MSBs 
    jr nz, .clearVRAMLoop\@      ; If result is not zero (BC ~= 0), continue loop
ENDM

; Wipe VRAM
MACRO WipeVRAM

    SwitchScreenOff

; -------- Clear screen ------
    ClearScreen
    
; -------- Set screen enable settings ---------
    SwitchScreenOn \1

ENDM