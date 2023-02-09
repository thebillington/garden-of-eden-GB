INCLUDE "hardware.inc"
INCLUDE "memory_map.inc"
INCLUDE "images/images.inc"

; -------- INCLUDE UTILITIES --------
INClUDE "util.asm"
INCLUDE "dir_table.asm"
INCLUDE "constants.inc"

; ------- DEVSOUND LITE ------------
INCLUDE "DevSound.asm"

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
    jp TIHandler    ; Jump to timer handler routine

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

;  -------- Timer setup --------
    xor a               ; (ld a, 0)
    ld [rTIMA], a       ; Set TIMA to 0
    or TACF_STOP        ; Set STOP bit in A
    or TACF_4KHZ        ; Set divider bit in A
    ld [rTAC], a        ; Load TAC with A (settings)
    ld a, 0             ; Load A with 0
    ld [rTMA], a        ; Load TMA with A
    ld [rTIMA], a       ; Load TIMA with A (Reset to zero)

;  -------- Enable interrupts --------
    xor a           ; (ld a, 0)
    or IEF_VBLANK   ; Load VBlank mask into A
    or IEF_TIMER    ; Load Timer mask into A
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

; -------- Studio screen --------
    LoadImageBanked studiologo_tile_data, studiologo_tile_data_end, studiologo_map_data, studiologo_map_data_end
    
    SwitchScreenOn LCDCF_ON | LCDCF_BG8000 | LCDCF_BGON   ; utils_hardware -> SwitchScreenOn Macro

;  -------- Timer start --------
    xor a           ; (ld a, 0)
    ld b, a         ; Load A into B

    or TACF_4KHZ    ; Set divider bit in A 
    or TACF_START   ; Set START bit in A
    ld [rDIV], a    ; Load DIV with A (Reset to zero)
    ld [rTAC], a    ; Load TAC with A

;  -------- Wait before moving on --------
.studio
    ;xor a             ; Debug without splash screen
    ld a, $3F         ; Switch for production
    cp b
    jr nz, .studio

;  -------- Pause the Timer --------
    xor a               ; (ld a, 0)
    ld [rTIMA], a       ; Set TIMA to 0
    or TACF_STOP        ; Set STOP bit in A
    or TACF_4KHZ        ; Set divider bit in A
    ld [rTAC], a        ; Load TAC with A (settings)

; -------- Splash screen --------

.loadSplash

; -------- Clear the screen ---------
    SwitchScreenOff     ; utils_hardware -> SwitchScreenOff Macro

; -------- Load splash screen ---------
    LoadImageBanked splashscreen_tile_data, splashscreen_tile_data_end, splashscreen_map_data, splashscreen_map_data_end    ; utils_load -> LoadImageBanked Macro

    SwitchScreenOn LCDCF_ON | LCDCF_BG8000 | LCDCF_BGON   ; utils_hardware -> SwitchScreenOn Macro

; -------- Load DevSound and start music track 1 --------
    ld a, 0
    call  DS_Init

; ------- Play music track ---------------

    call DS_Play

.splash

; -------- Wait for start or select button press ------

    FetchJoypadState                ; utils_hardware -> FetchJoypadState MACRO
    ld b, a                         ; Backup A register
    and PADF_START                  ; If start then set NZ flag

    jp nz, .loadMenu       ; If not start then loop

    jr .splash

; -------- Menu screen --------

.loadMenu

; -------- Clear the screen ---------
    SwitchScreenOff     ; utils_hardware -> SwitchScreenOff Macro

; -------- Load menu screen ---------
    LoadImageBanked gamewindow_tile_data, gamewindow_tile_data_end, menu_map_data, menu_map_data_end    ; utils_load -> LoadImageBanked Macro

    SwitchScreenOn LCDCF_ON | LCDCF_BG8000 | LCDCF_BGON | LCDCF_OBJON | LCDCF_OBJ8   ; utils_hardware -> SwitchScreenOn Macro

; -------- Load menu cursor ---------
    LoadMenuCursor

;  -------- Set the game loop flag to 1 --------
    ld hl, GAME_START
    ld a, $1
    ld [hl], a

;  -------- Timer start --------
    xor a           ; (ld a, 0)
    or TACF_4KHZ    ; Set divider bit in A 
    or TACF_START   ; Set START bit in A
    ld [rDIV], a    ; Load DIV with A (Reset to zero)
    ld [rTAC], a    ; Load TAC with A

.menu

; -------- Check for A button press ------
    FetchJoypadState    ; utils_hardware -> FetchJoypadState MACRO
    ld c, a             ; Store joypad state
    and PADF_A      ; If start then set NZ flag

    jp nz, .menuSelection       ; If A pressed start game loop

    CursorMovement          ; Check for cursor movement

    jp .menu

; -------- Handle A press on menu screen ------
.menuSelection

    LoadMenuCursorY                 ; Load y position of the menu cursor into a

    cp MENU_PLAY_GAME_POSITION
    jr z, .startGame                ; If the play game position is selected, start the game

    cp MENU_CREDITS_POSITION
    jr z, .loadCredits                ; If the instructions position is selected, start the game

    jp .menu

; -------- Credits screen --------

.loadCredits

;  -------- Set the game loop flag to 0 --------
    ld hl, GAME_START
    ld a, $0
    ld [hl], a

; -------- Load credits screen ---------
    SwitchScreenOff     ; utils_hardware -> SwitchScreenOff Macro

    LoadImageBanked gamewindow_tile_data, gamewindow_tile_data_end, credits_map_data, credits_map_data_end    ; utils_load -> LoadImageBanked Macro

    SwitchScreenOn LCDCF_ON | LCDCF_BG8000 | LCDCF_BGON   ; utils_hardware -> SwitchScreenOn Macro

;  -------- Timer start --------
    xor a           ; (ld a, 0)
    ld b, a         ; Load A into B

    or TACF_4KHZ    ; Set divider bit in A 
    or TACF_START   ; Set START bit in A
    ld [rDIV], a    ; Load DIV with A (Reset to zero)
    ld [rTAC], a    ; Load TAC with A

;  -------- Wait before moving on --------
.credits
    ld a, $3F
    cp b
    jr nz, .credits

;  -------- Pause the Timer --------
    xor a               ; (ld a, 0)
    ld [rTIMA], a       ; Set TIMA to 0
    or TACF_STOP        ; Set STOP bit in A
    or TACF_4KHZ        ; Set divider bit in A
    ld [rTAC], a        ; Load TAC with A (settings)

    jp .loadMenu

.startGame
    
; ------- Seed the Random Number Generator (RNG) ----------
    ld a, [rDIV]        ; Load A with DIV
    ld [SEED], a        ; 
    ld a, [rDIV]
    ld [SEED + 1], a
    ld a, [rDIV]
    ld [SEED + 2], a

;  -------- Set the game loop flag to 1 --------
    ld hl, GAME_START
    ld a, $1
    ld [hl], a

;  -------- Load the dir_table into RAM --------
    CopyData DIR_TABLE, dir_table_data, dir_table_data_end

; -------- Clear the screen ---------
    SwitchScreenOff     ; utils_hardware -> SwitchScreenOff Macro
    ClearVRAM           ; utils_clear -> ClearVRAM Macro

; ------- Load game screen into VRAM----------
    LoadImage gamewindow_tile_data, gamewindow_tile_data_end, gamewindow_map_data, gamewindow_map_data_end

; ------- Draw pipes on screen----------
    ld hl, _GAME_WINDOW_START
REPT _GAME_WINDOW_HEIGHT
REPT _GAME_WINDOW_WIDTH
    RandMax _PIPE_TILE_VARIATIONS
    add a, _PIPE_TILE_OFFSET
    ld [hli], a
ENDR
    AddSixteenBitHL _GAME_WINDOW_OFFSET
ENDR

;  -------- Timer start --------
    xor a           ; (ld a, 0)
    or TACF_4KHZ    ; Set divider bit in A 
    or TACF_START   ; Set START bit in A
    ld [rDIV], a    ; Load DIV with A (Reset to zero)
    ld [rTAC], a    ; Load TAC with A

; ------- Load cursor sprites ----------

    LoadCursor
    
    LoadCheckCursor

; ------- Switch screen on ----------

    SwitchScreenOn LCDCF_ON | LCDCF_BG8000 | LCDCF_BGON | LCDCF_OBJON | LCDCF_OBJ8   ; utils_hardware -> SwitchScreenOn Macro

; -------- START Main Loop ---------
.loop
    WaitVBlankIF                        ; Wait for VBlank interrupt (this should get us running at ~60Hz)

    FetchJoypadState                    ; Fetch current state of joypad

    CheckMovement                       ; Check for D-Pad pressed and move accordingly

    CheckTileRotation                   ; Check for button pressed and rotate tiles accordingly

    FetchJoypadState                    ; utils_hardware -> FetchJoypadState MACRO
    and PADF_SELECT                     ; If select then set NZ flag

    jp z, .loop

    CheckSolved
    ld hl, STATE_FLAG
    ld a, [hl]
    and $1
    jr nz, .loadSolved

    jp .loop                            ; Jump back to the top of the game loop

; -------- END Main Loop --------

.loadSolved

;  -------- Pause the Timer --------
    xor a               ; (ld a, 0)
    ld [rTIMA], a       ; Set TIMA to 0
    or TACF_STOP        ; Set STOP bit in A
    or TACF_4KHZ        ; Set divider bit in A
    ld [rTAC], a        ; Load TAC with A (settings)

; ------- Load game screen into VRAM----------
    SwitchScreenOff
    
    LoadSolvedMessage

    SwitchScreenOn LCDCF_ON | LCDCF_BG8000 | LCDCF_BGON   ; utils_hardware -> SwitchScreenOn Macro

.waitSolved
; -------- Wait for A button press ------
    FetchJoypadState                ; utils_hardware -> FetchJoypadState MACRO
    and PADF_A                      ; If a then set NZ flag

    jp nz, .loadSplash                ; If not A then loop

    jr .waitSolved                  ; If A then jup back to menu

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

; -------- Timer Interrupt Handler ---------
TIHandler:
    push af
    push hl

    ld hl, GAME_START
    ld a, [hl]
    and $1
    jr nz, .timerGame

.timerStudio
    inc b           ; Incriment B register every tick

    pop hl
    pop af
    reti

.timerGame
    ld hl, CAN_MOVE
    ld a, [hl]
    cp CAN_MOVE_COUNT
    jr z, .timerSkip

    inc [hl]

.timerSkip
    pop hl
    pop af
    reti            ; Return and enable interrupts