000100111213      * Licensed Materials - Property of IBM
000101111213      *    [MLGNAMR.RPGLE]
000102111213      * (C) Copyright IBM Corporation 1993, 2011
000103111213      * U.S. Government Users Restricted Rights: Use duplication or
000104111213      *      disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
000105111213      *
000107111213     F* MLGNAMR - Mailing list name search
000200080828     FMLGNAML   IF   E           K DISK
000300080828     FMLGNAMD   CF   E             WORKSTN
000400080828     F                                     SFILE(SFLRCD:SFLNBR)
000401090417      * Include a copy member
000402090417     D/INCLUDE QRPGLEINC,FOOCPYR
000500080828     D TYP             S              1    DIM(10) CTDATA PERRCD(1)
000600080828     D TXT             S             15    DIM(10) ALT(TYP)
000700080828     D NAM             S              1    DIM(11)
000800080828     C     *ENTRY        PLIST
000900080828     C                   PARM                    SEARCH
001000080828     C                   PARM                    MLACCT
001100080828     C                   PARM                    PGMEND            1
001200080828     C* End program if Pgm end switch is set
001300080828     C     PGMEND        CABNE     *BLANK        ENDPGM                   LR
001400080828     C* Determine len of the search field (end of non-blank or 0 len)
001500080828     C                   MOVEA     SEARCH        NAM(1)
001600080828     C                   Z-ADD     11            NX                3 0
001700080828     C     LOOP          TAG
001800080828     C                   SUB       1             NX                   20
001900080828     C   20NAM(NX)       CABEQ     *BLANK        LOOP
002000080828     C                   ADD       1             NX
002100080828     C* Clear out the subfile
002200080828     C                   Z-ADD     0             BOTNBR
002300080828     C                   SETON                                        68
002400080828     C                   WRITE     SFLCTL
002500080828     C                   SETOFF                                       68
002600080828     C                   SETOFF                                       71
002700080828     C* Use SEARCH field to set lower limit
002800080828     C     SEARCH        SETLL     MLGMSTR
002900080828     C* Start rollup or first display
003000080828     C     ROLLUP        TAG
003100080828     C                   Z-ADD     BOTNBR        SFLNBR
003200080828     C                   Z-ADD     0             LINCNT            3 0
003300080828     C                   SETOFF                                       67
003400080828     C* 71 is rollup. If rollup was allowed, a DB rcd was already read
003500080828     C   71              GOTO      WRTSFL
003600080828     C* Read a record
003700080828     C     RDRCD         TAG
003800080828     C                   READ      MLGMSTR                                83
003900080828     C   83              GOTO      ENDDB
004000080828     C* Determine if record matches the search field
004100080828     C                   MOVEA     MLSRCH        NAM(1)
004200080828     C                   MOVEA     *BLANKS       NAM(NX)
004300080828     C     *LIKE         DEFINE    MLSRCH        SAVNAM
004400080828     C                   MOVEA     NAM(1)        SAVNAM
004500080828     C     SEARCH        CABNE     SAVNAM        ENDDB                8383
004600080828     C     13            CABEQ     LINCNT        ENDDB                    71
004700080828     C* Write to the subfile record
004800080828     C     WRTSFL        TAG
004900080828     C                   SETOFF                                       71
005000080828     C                   ADD       1             SFLNBR
005100080828     C                   MOVE      *BLANK        SELECT
005200080828     C* Move left to shorten field lengths for display
005300080828     C                   MOVEL     MLNAME        ABBNAM
005400080828     C                   MOVEL     MLCITY        ABBCTY
005500080828     C                   MOVEL     MLADDR        ABBADD
005600080828     C* Blank the text for detail display and lookup text descrp
005700080828     C                   MOVE      *BLANKS       TYPTXT
005800080828     C                   Z-ADD     1             TX                3 0
005900080828     C     MLTYPE        LOOKUP    TYP(TX)                                20
006000080828     C   20              MOVE      TXT(TX)       TYPTXT
006100080828     C                   WRITE     SFLRCD
006200080828     C  N67              Z-ADD     SFLNBR        TOPNBR            4 0
006300080828     C                   SETON                                        67
006400080828     C                   ADD       1             LINCNT
006500080828     C                   GOTO      RDRCD
006600080828     C* End of data base processing
006700080828     C     ENDDB         TAG
006800080828     C* N67 indicates that no records were written to the sub file
006900080828     C  N67              GOTO      DISPLY
007000080828     C                   Z-ADD     SFLNBR        BOTNBR            4 0
007100080828     C                   Z-ADD     TOPNBR        SFLNBR
007200080828     C* Display the subfile
007300080828     C     DISPLY        TAG
007400080828     C* Reset BOTTOM indicators and write SFLCTL
007500080828     C                   MOVE      *BLANK        SLTRCD            1
007600080828     C                   WRITE     BOTTOM
007700080828     C                   SETOFF                                       505152
007800080828     C                   EXFMT     SFLCTL
007900080828     C  N67
008000080828     COR 93              DO
008100080828     C                   Z-ADD     *ZEROS        MLACCT
008200080828     C                   GOTO      ENDPGM
008300080828     C                   END
008400080828     C* If rollup key was pressed, loop back
008500080828     C   98              GOTO      ROLLUP
008600080828     C* Do READC for detail display
008700080828     C     READC         TAG
008800080828     C                   READC     SFLRCD                                 21
008900080828     C* A record was selected in the subfile, check and display
009000080828     C  N21              DO
009100080828     C     SELECT        CABEQ     ' '           READC
009200080828     C                   MOVE      'X'           SLTRCD
009300080828     C* Select=1 Detail display of the record
009400080828     C     SELECT        IFEQ      '1'
009500080828     C                   EXFMT     DETAIL
009600080828     C                   END
009700080828     C* Select=2 Return with selected account number
009800080828     C     SELECT        IFEQ      '2'
009900080828     C                   GOTO      ENDPGM
010000080828     C                   END
010100080828     C* End of SFL rcd which has an action, blank selection entry
010200080828     C                   MOVE      *BLANK        SELECT
010300080828     C                   UPDATE    SFLRCD
010400080828     C                   GOTO      READC
010500080828     C                   END
010600080828     C* End of SFL reached (READC has found no more)
010700080828     C*    If one or more detail records displayed, redisplay subfile
010800080828     C     SLTRCD        CABEQ     'X'           DISPLY
010900080828     C* No SFL records displayed, no F3 or rollup, return as good end
011000080828     C                   Z-ADD     *ZEROS        MLACCT
011100080828     C     ENDPGM        TAG
011200080828     C                   RETURN
011300080828** TYP and TXT
0114000808281Business
0115000808282Government
0116000808283Organization
0117000808284School
0118000808285Private
0119000808289Other
