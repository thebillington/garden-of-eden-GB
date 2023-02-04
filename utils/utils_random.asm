;* Random # - Calculate as you go *
; (Allocate 3 bytes of ram labeled 'Seed')
; Exit: A = 0-255, random number

MACRO Rand
    push hl

    ld hl,SEED
    ld a,[hl+]
    sra a
    sra a
    sra a
    xor[hl]
    inc hl
    rra
    rl [hl]
    dec hl
    rl [hl]
    dec hl
    rl [hl]
    ;ld a,[$FFF4]        ; get divider register to increase randomness
    add [hl]

    pop hl
ENDM

MACRO RandMax
    Rand
    MODA \1
ENDM