INCLUDE "hardware.inc"
INCLUDE "memory_map.inc"
INCLUDE "constants.inc"

; -------- Maths Macros --------
MACRO AddSixteenBitBC

    ld a, c
    add a, \1
    ld c, a
    ld a, b
    adc a, $00
    ld b, a

ENDM

MACRO AddSixteenBitDE

    ld a, e
    add a, \1
    ld e, a
    ld a, d
    adc a, $00
    ld d, a

ENDM

MACRO AddSixteenBitHL

    ld a, l
    add a, \1
    ld l, a
    ld a, h
    adc a, $00
    ld h, a

ENDM

; Modulus method
MACRO MOD

    ld a, \1

.modLoop\@
    sub \2

    jr nc, .modLoop\@
    add \2

ENDM

; Divide method
MACRO DIVIDE

    ld a, \1
    ld b, $00

.divLoop\@
    sub \2
    inc b

    jr nc, .divLoop\@
    ld a, b

ENDM

; Multiply method
MACRO MULT

    ld c, a
    ld b, \1

.multLoop\@
    add c
    dec b

    jr nz, .multLoop\@

ENDM