INCLUDE "hardware.inc"
INCLUDE "memory_map.inc"
INCLUDE "constants.inc"

; https://exez.in/gameboy-dma
; https://github.com/lancekindle/DMGreport/blob/master/03_good_sprite_moves.asm

; Copies the DMA code to HRAM
MACRO DMA_COPY

    jr .Copy_DMA\@

; DMACode will run every VBlank Interrupt
; Copy the first 160 bytes from RAM to OAM
.DMA_Code\@
    push af                 ; Temp save af so registers are preserved
    ld a, OAMDATALOCBANK    ; Load RAM start A
    ldh [rDMA], a           ; Load A into DMA Register to start DMA Transfer
    
    ; DMA Transfer has begun. We  need to wait
    ; 160 micro seconds while it completes

    ld a, $28   ; Countdown till DMA finishes
.DMA_Wait\@
    dec a               ; A -= 1
    jr nz, .DMA_Wait\@  ; Loop till a < 0

    pop af              ; Restore register values
    reti                ; Re-enable interrupts and return
.DMA_End\@

.Copy_DMA\@
    ld de, _HRAM
    ld hl, .DMA_Code\@
    ld bc, .DMA_End\@ - .DMA_Code\@

    inc b
    inc c
    jr .skip\@

.loop\@
    ld a, [hl+]
    ld [de], a
    inc de
.skip\@
    dec c
    jr nz, .loop\@
    dec b
    jr nz, .loop\@
ENDM