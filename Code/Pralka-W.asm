;********************************************************
;     Program sterujacy pralka automatyczna PS663S bio  *
;             w/g archiwalnego zapisu Pana Wiktora      *
;                      z 1985 roku                      *
;********************************************************
            .cr z80           ;https://www.sbprojects.net/sbasm/          
            .tf PS663S-bio.hex,int   
            .lf PS663S-bio.lst
            .sf PS663S-bio.sym
            .in ca80.inc
;********************************************************
;********************************************************

            .or 0C000h 
;*********************************************************************
POCZATEK:   LD      SP,STOS
            LD      A,90H       ; PC OUT PA IN
            OUT     (CONTR),A
            LD      HL,KOM1
            CALL    PRINT       ; KOMUNIKAT "PROG"
            .DB     44H         ; PWYS
            CALL    PARAM       ; NR PROGRAMU
            .DB     10H         ; PWYS
            LD      A,L
            AND     0FH
            JP      Z,ERROR 
            CP      0BH         ; ZA DUZA
            JP      NC,ERROR
            LD      HL,TADR-2   ; POCZATEK TABLICY ADRESOW
            LD      C,A 
            RLCA
            ADD     L
            LD      L,A 
            LD      E,(HL)
            INC     HL
            LD      D,(HL)
            CALL    CO 
            .DB     10H 
            EX      DE,HL
            JP      (HL)        ; SKOK DO WYBRANEGO PROGRAMU
PROG1:      CALL    WODW        ; WODA
            CALL    POW5        ; GRZALKA
            LD      D,3CH       ; 30 MINUT
            CALL    PO10        ; REWERSJI DEL%
            LD      C,02H 
            CALL    CO1
PROG2:      CALL    WOWW        ; WODA
            CALL    POW5        ; GRZALKA
            LD      D,1EH   
            CALL    PO10        ; REWERSJI DEL%
            LD      C,03H 
            CALL    CO1
PROG3:      CALL    WOWW        ; WODA
            CALL    PO10        ; REWERSJI DEL%
            LD      D,1EH   
            CALL    PO10        ; REWERSJI DEL%
            CALL    WIR3        ; WIROWANIE 3 MINUTY
            LD      C,04H 
            CALL    CO1
PROG4:      LD      A,8CH       ; WODA
            OUT     (PC),A
POW8:       CALL    REWD        ; REWERSJA DELIKATNA
            IN      A,(PA)
            RLCA
            JP      NC,POW8
            LD      A,05H       ; GRZALKA ON
            OUT     (CONTR),A
POW9:       CALL    REWD        ; REWERSJA DELIKATNA
            IN      A,(PA)
            AND     10h         ; CZY WYSOKA TEMPERATURA
            JP      NZ,POW9
            LD      A,04H       ; GRZALKA OFF
            OUT     (CONTR),A
            LD      D,1EH       ; 15 MINUT
            CALL    PO10        ; REWERSJI DEL%
            LD      C,05H 
            CALL    CO1
PROG5:      CALL    WODZ        ; PRANIE ZASADNICZE
POW7:       CALL    REWN
            IN      A,(PA)
            AND     08h         ; CZY SREDNIA TEMPERATURA
            JP      NZ,POW7
            LD      A,04H       ; GRZALKA OFF
            OUT     (CONTR),A
            LD      D,1EH       ; 15 MINUT
            CALL    POW6
            LD      C,06H 
            CALL    CO1
PROG6:      CALL    WODZ        ; PRANIE ZASADNICZE
            CALL    POW5
            LD      D,5AH       ; 45 MINUT
            CALL    POW6
            LD      A,05H       ; GRZALKA ON
            OUT     (CONTR),A
            LD      D,3CH       ; 30 MINUT
            CALL    POW6
            LD      C,07H 
            CALL    CO1
PROG7:      CALL    WODZ        ; PRANIE ZASADNICZE
            CALL    POW5
            LD      D,5AH       ; 45 MINUT
            CALL    POW6
            CALL    POMP        ; ODPOMPOWANIE WODY
            CALL    WODW
            CALL    POMP        ; ODPOMPOWANIE WODY
            LD      C,08H 
            CALL    CO1
PROG8:      LD      E,03H       ; 3 RAZY POWT.
POW4:       CALL    WODW
            LD      D,0AH
            CALL    POW3        ; PLUKANIE
            CALL    POMP        ; ODPOMPOWANIE WODY
            CALL    WIR3        ; WIROWANIE 3 MINUTY
            DEC     E 
            JP      NZ,POW4     ; CZY TRZY RAZY
            LD      C,09H 
            CALL    CO1
PROG9:      CALL    WODW
            LD      D,0AH
            CALL    POW3        ; PLUKANIE
            CALL    POMP        ; ODPOMPOWANIE WODY
            LD      C,0AH 
            CALL    CO1
PROGA:      LD      A,0B1H      ; WIROWANIE
            OUT     (PC),A
            CALL    OPOZ 
            .DW     0258H       ; 5 MINUT
FIN:        XOR     A             
            OUT     (PC),A
            LD      HL,FINISH
            CALL    PRINT       ; KOMUNIKAT KONCA
            .DB     71H
            CALL    CI
            RST     6
;*********************************************************************        
;       PODPROGRAMY
;*********************************************************************        
; OPOZNIENIE 0,5 SEK
OPO5:       LD      A,0FFA9H
            LD      HL,TIME
            LD      (HL),A 
POW0:       LD      A,(HL)
            OR      A 
            JP      NZ,POW0
            RET

;OPOZNIENIE DW X 0,5 SEK
OPOZ:       EX      (SP),HL
            INC     HL
            LD      C,(HL)
            INC     HL
            LD      B,(HL)
            INC     HL
            EX      (SP),HL
POW1:       CALL    OPO5
            DEC     BC
            LD      A,B 
            OR      C 
            JP      NZ,POW1
            RET

; REWERSJA NORMALNA 12 SEK LEWO 12 PRAWO 3 STOP
; STOP SILNIKA
STP3:       LD      A,0AH
            OUT     (CONTR),A       ; SILNIK STOP
            CALL    OPOZ
            .DW     0006H           ; 3 SEK
            LD      A,0BH  
            OUT     (CONTR),A       ; SILNIK START
            RET

RENN:       OUT     (CONTR),A
            CALL    STP3
            CALL    OPOZ
            .DW     0018H           ; 12 SEK
            RET

REWN:       LD      A,0DH           ; LEWO
            CALL    RENN
            LD      A,0CH           ; PRAWO
            CALL    RENN
            RET

;REWERSJA DELIKATNA
ST12:       LD      A,0AH
            OUT     (CONTR),A       ; SILNIK STOP
            CALL    OPOZ
            .DW     0018H           ; 12 SEK
            LD      A,0BH  
            OUT     (CONTR),A       ; SILNIK START
            RET

REDD:       OUT     (CONTR),A
            CALL    ST12
            CALL    OPOZ
            .DW     0006H           ; 3 SEK
            RET

REWD:       LD      A,0DH           ; LEWO
            CALL    REDD
            LD      A,0CH           ; PRAWO
            CALL    REDD
            RET

;NAPELNIANIE ZAWOR WST. REWERSJA NORM.
WODW:       LD      A,084H      ; WIROWANIE
            OUT     (PC),A
POW2:       CALL    REWN
            IN      A,(PA)
            RRCA
            JP      NC,POW2
            RET

; DLA PLUKANIA
POW3:       CALL    REWN
            DEC     D 
            JP      NZ,POW3
            RET

; WYPOMPOWANIE WODY
POMP:       LD      D,0AH
            LD      A,81H
            OUT     (PC),A
            CALL    POW3
            RET

;WIROWANIE 3 MINUTY
WIR3:       LD      A,81H
            OUT     (PC),A
            CALL    OPOZ
            .DW     0168H           ; 3 MINUTY
            RET
          
;WPUST WODY DLA PRANIA ZASADNICZEGO DWA ZAWORY
WODZ:       LD      A,8CH
            OUT     (PC),A
            CALL    POW2
            LD      A,05H       ; GRZALKA ON
            OUT     (CONTR),A
            RET

; TERMOSTAT NT NISKICH TEMPERATUR
POW5:       CALL    REWN
            IN      A,(PA)
            AND     04H         ; TERMOSTAT NT ?
            JP      NZ,POW5
            LD      A,04H       ; GRZALKA OFF
            OUT     (CONTR),A
            RET

; POMOCNICZY DLA DLUGIEGO PRANIA
POW6:       CALL    REWN
            DEC     D 
            JP      NZ,POW3
            RET
                
PO10:       CALL    REWD
            DEC     D 
            JP      NZ,PO10
            RET                           

WOWW:       CALL    WODW        ; NAPELNIANIE PRZEZ ZAWOR WSTEPNY
            LD      A,05H       ; REWERSJA DELIKATNA
            OUT     (CONTR),A   ; GRZALKA ON
            RET

; TABLICA ADRESOW
TADR:       .DW     PROG1
            .DW     PROG2
            .DW     PROG3
            .DW     PROG4
            .DW     PROG5
            .DW     PROG6
            .DW     PROG7
            .DW     PROG8
            .DW     PROG9
            .DW     PROGA

;KOMUNIKATY
KOM1:       .DB     73H         ; P
            .DB     50H         ; R
            .DB     5CH         ; O
            .DB     3DH         ; G
            .DB     EOM         ; EOM
            
FINISH:     .DB     71H         ; F
            .DB     50H         ; I
            .DB     54H         ; N
            .DB     30H         ; I
            .DB     6DH         ; S
            .DB     76H         ; H
            .DB     EOM         ; EOM
            
;*********************************************************************        
;       END.
;*********************************************************************        
