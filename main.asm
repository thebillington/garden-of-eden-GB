INCLUDE "hardware.inc"
INCLUDE "memory_map.inc"
INCLUDE "images/images.inc"

; -------- INCLUDE UTILITIES --------
INClUDE "util.asm"
INCLUDE "constants.inc"

; -------- INTERRUPT VECTORS --------
; specific memory addresses are called when a hardware interrupt triggers


; Vertical-blank triggers each time the screen finishes drawing. Video-RAM
; (VRAM) is only available during VBLANK. So this is when updating OAM /
; sprites is executed.
SECTION "VBlank", ROM0[$0040]
    jp VBHandler    ; Jump to VBlank handler routine

; LCDC interrupts are LCD-specific interrupts (not including vblank) such as
; interrupting when the gameboy draws a specific horizontal line on-screen
SECTION "LCDC", ROM0[$0048]
    reti

; Timer interrupt is triggered when the timer, rTIMA, ($FF05) overflows.
; rDIV, rTIMA, rTMA, rTAC all control the timer.
SECTION "Timer", ROM0[$0050]
    reti

; Serial interrupt occurs after the gameboy transfers a byte through the
; gameboy link cable.
SECTION "Serial", ROM0[$0058]
    reti

; Joypad interrupt occurs after a button has been pressed. Usually we don't
; enable this, and instead poll the joypad state each vblank
SECTION "Joypad", ROM0[$0060]
    reti

; -------- HEADER --------
SECTION "Header", ROM0[$0100]

EntryPoint:
    di          ; Disable interrupts
    jp Start    ; Jump to code start

; RGBFIX will fix this later
rept $150 - $104
    db 0
endr

; -------- MAIN --------
SECTION "Game Code", ROM0[$0150]

Start:
    ld SP, $FFFF    ; Set stack pointer to the top of HRAM

    ClearRAM        ; ClearRAM MACRO

    DMA_COPY        ; Copy the DMA Routine to HRAM

;  -------- Enable interrupts --------
    xor a           ; (ld a, 0)
    or IEF_VBLANK   ; Load VBlank mask into A
    ld [rIE], a     ; Set interrupt flags
    ei              ; Enable interrupts

; ------- Load colour pallet ----------
    ld a, %11100100     ; Load A with colour pallet settings
    ld [rBGP], a        ; Load BG colour pallet with A
    ld [rOBP0], a       ; Load OBJ0 colour pallet with A

; -------- Initial Configuration --------

.init
; -------- Clear the screen ---------
    SwitchScreenOff     ; utils_hardware -> SwitchScreenOff Macro
    ClearVRAM           ; utils_clear -> ClearVRAM Macro

; ------- Set scroll x and y ----------
    xor a               ; (ld a, 0)
    ld [rSCX], a        ; Load BG scroll Y with A
    ld [rSCY], a        ; Load BG scroll X with A

; ------- Load pipe tiles into VRAM----------
    CopyData _VRAM + _TILE_LEN * 1, pipecorner0_tile_data, pipecorner0_tile_data_end
    CopyData _VRAM + _TILE_LEN * 2, pipecorner1_tile_data, pipecorner1_tile_data_end
    CopyData _VRAM + _TILE_LEN * 3, pipecorner2_tile_data, pipecorner2_tile_data_end
    CopyData _VRAM + _TILE_LEN * 4, pipecorner3_tile_data, pipecorner3_tile_data_end

    CopyData _VRAM + _TILE_LEN * 5, pipecross0_tile_data, pipecross0_tile_data_end

    CopyData _VRAM + _TILE_LEN * 6, pipestraight0_tile_data, pipestraight0_tile_data_end
    CopyData _VRAM + _TILE_LEN * 7, pipestraight1_tile_data, pipestraight1_tile_data_end

    CopyData _VRAM + _TILE_LEN * 8, pipet0_tile_data, pipet0_tile_data_end
    CopyData _VRAM + _TILE_LEN * 9, pipet1_tile_data, pipet1_tile_data_end
    CopyData _VRAM + _TILE_LEN * 10, pipet2_tile_data, pipet2_tile_data_end
    CopyData _VRAM + _TILE_LEN * 11, pipet3_tile_data, pipet3_tile_data_end

; ------- Draw pipes on screen----------
    ld a, 1
    ld hl, _SCRN0

REPT 11
    ld [hli], a
    inc a
ENDR

    SwitchScreenOn LCDCF_ON | LCDCF_BG8000 | LCDCF_BGON   ; utils_hardware -> SwitchScreenOn Macro

; -------- Lock up the CPU ---------
.debug         
    jr .debug      ; Use to lock CPU for debugging

; -------- VBlank Interrupt Handler ---------
VBHandler:
    push hl                 ; Preserve HL register

    ld hl, INTR_STATE       ; Load INTR_STATE loc to hl
    ld [hl], IEF_VBLANK     ; load IEF_VBLANK to INTR_STATE

    pop hl                  ; Restore HL register

    jp _HRAM                ; Jump to the start of DMA Routine