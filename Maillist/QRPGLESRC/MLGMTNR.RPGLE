000100111213      * Licensed Materials - Property of IBM
000101111213      *    [MLGMTNR.RPGLE]
000102111213      * (C) Copyright IBM Corporation 1993, 2011
000103111213      * U.S. Government Users Restricted Rights: Use duplication or
000104111213      *      disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
000105111213      *
000107111213     F* MLGMTNR - Maintenance of Mailing list master - call by MLGMTNC
000200080828     FMLGMSTP   UF A E           K DISK    INFDS(FILEDS)
000300080828     FMLGMTND   CF   E             WORKSTN
000301090417      * Include a copy member
000302090417     D/INCLUDE QRPGLEINC,FOOCPYR
000400080828     D ACT             S             10    DIM(6) CTDATA PERRCD(6)
000500080828     D* Data structure to get file error status
000600080828     D FILEDS          DS
000700080828     D  RCDLEN               125    126B 0
000800080828     D  STS              *STATUS
000900080828     D* DSRCD1 DS is used to contain the fields from MLGMSTP
001000080828     D DSRCD1        E DS                  EXTNAME(MLGMSTP)
001100090917     D* DSRCD2 DS is used to test 1st access against 2nd access.
001200080828     D DSRCD2          DS           300
001300080828     C     *ENTRY        PLIST
001400080828     C                   PARM                    RTNCDE            8
001500080828     C* Check for DSRCD2 being too small
001600080828     C     RCDLEN        IFGT      300
001700080828     C                   MOVE      'LENERR  '    RTNCDE
001800080828     C                   GOTO      BADEND
001900080828     C                   END
002000080828     C* Prompt for action and account number
002100080828     C     PROMPT        TAG
002200080828     C                   MOVE      ACCT          PRVACC
002300080828     C                   EXFMT     DSPLY1
002400080828     C                   SETON                                        39
002500080828     C* Check for F3 and invalid action
002600080828     C   93              GOTO      ENDPGM
002700080828     C     ACTION        IFLT      '1'
002800080828     C     ACTION        ORGT      '6'
002900080828     C                   SETON                                        44
003000080828     C                   GOTO      PROMPT
003100080828     C                   END
003200080828     C* Set action text for detail display
003300080828     C     SETTXT        TAG
003400080828     C                   MOVE      ACTION        AX                3 0
003500080828     C                   MOVE      ACT(AX)       ACTTXT
003600080828     C* If name search, call sub program
003700080828     C     '6'           IFEQ      ACTION
003800080828     C     SEARCH        CABEQ     *BLANK        PROMPT                   48
003900080828     C                   EXSR      SUBPGM
004000080828     C                   MOVE      'X'           CALLED            1
004100080828     C* If no account is returned, re-display first prompt
004200080828     C     ACCT          CABEQ     *ZEROS        PROMPT
004300080828     C* If account is returned, use display mode to display
004400080828     C                   MOVE      '1'           ACTION
004500080828     C                   MOVE      ACTION        AX
004600080828     C                   MOVE      ACT(AX)       ACTTXT
004700080828     C                   END
004800080828     C* If Display GE opt, set lower limit, read rcd and branch to dsp
004900080828     C     '5'           IFEQ      ACTION
005000080828     C     ACCT          SETLL     MLGMSTR
005100080828     C                   READ      MLGMSTR                                47
005200080828     C   47              GOTO      PROMPT
005300080828     C                   GOTO      DSPACT
005400080828     C                   END
005500080828     C* Check for zero account number and chain to record
005600080828     C     ACCT          CABEQ     *ZEROS        PROMPT                   46
005700080828     C     ACCT          CHAIN     MLGMSTR                            30
005800080828     C* If Add, check for unique key, write out record with key field
005900080828     C     '3'           IFEQ      ACTION
006000080828     C* If not missing, send back error
006100080828     C  N30              DO
006200080828     C                   SETON                                        41
006300080828     C                   GOTO      PROMPT
006400080828     C                   END
006500080828     C* Write out new record with just key field
006600080828     C                   MOVE      ACCT          MLACCT
006700080828     C                   EXCEPT    ADDNEW
006800080828     C* Re-access record to bring in defaults for all fields
006900080828     C     ACCT          CHAIN     MLGMSTR                            20
007000080828     C   20              DO
007100080828     C                   MOVE      'REACCESS'    RTNCDE
007200080828     C                   GOTO      BADEND
007300080828     C                   END
007400080828     C* Release the record lock and move record to save area
007500080828     C                   EXCEPT    RELESE
007600080828     C                   MOVEL     DSRCD1        DSRCD2
007700080828     C                   SETON                                        53
007800080828     C                   GOTO      DSPLY
007900080828     C                   END
008000080828     C* If missing, return error for other actions (CHG, DLT, DSP)
008100080828     C   30              DO
008200080828     C                   SETON                                        42
008300080828     C                   GOTO      PROMPT
008400080828     C                   END
008500080828     C* Release the record lock and move record to save area
008600080828     C                   EXCEPT    RELESE
008700080828     C                   MOVEL     DSRCD1        DSRCD2
008800080828     C* If Dlt, set for protect and display record
008900080828     C     '4'           IFEQ      ACTION
009000080828     C                   SETON                                        5053
009100080828     C                   SETON                                        51
009200080828     C                   GOTO      DSPLY
009300080828     C                   END
009400080828     C* If either form of display, set for protect and display record
009500080828     C     DSPACT        TAG
009600080828     C     '1'           IFEQ      ACTION
009700080828     C     '5'           OREQ      ACTION
009800080828     C                   SETON                                        5053
009900080828     C                   SETON                                        40
010000080828     C                   GOTO      DSPLY
010100080828     C                   END
010200080828     C* If Chg, display record and allow change
010300080828     C     '2'           CABEQ     ACTION        DSPLY
010400080828     C* If code gets to here, it is a bad action code
010500080828     C                   MOVEL     'BADACTN '    RTNCDE
010600080828     C                   GOTO      BADEND
010700080828     C* Display the record
010800080828     C     DSPLY         TAG
010900080828     C                   EXFMT     DSPLY2
011000080828     C                   MOVE      MLNAME        PRVNAM
011100080828     C* If F3 or F12 and not add, loop back to prompt again
011200080828     C   93'3'           CABNE     ACTION        PROMPT
011300080828     C* Handle roll keys (Only valid on dsp action)
011400080828     C   97
011500080828     COR 98              DO
011600080828     C   97              READ      MLGMSTR                                45
011700080828     C   98              READP     MLGMSTR                                45
011800080828     C   45              GOTO      PROMPT
011900080828     C                   SETON                                        5053
012000080828     C                   GOTO      DSPLY
012100080828     C                   END
012200080828     C* Handle F keys for change, add and delete
012300080828     C                   MOVE      MLACCT        ACCT
012400080828     C                   SETOFF                                       40
012500080828     C   96              DO
012600080828     C                   SETOFF                                       5053
012700080828     C                   MOVE      '2'           ACTION
012800080828     C                   GOTO      SETTXT
012900080828     C                   END
013000080828     C   91              DO
013100080828     C                   MOVE      '4'           ACTION
013200080828     C                   GOTO      SETTXT
013300080828     C                   END
013400080828     C* If DSP type (Record has already been displayed)
013500080828     C     '1'           CABEQ     ACTION        PROMPT
013600080828     C     '5'           CABEQ     ACTION        PROMPT
013700080828     C* Re-access record for CHG, ADD, or DLT: send error if missing
013800080828     C     ACCT          CHAIN     MLGMSTR                            43
013900080828     C   43              GOTO      PROMPT
014000080828     C* Compare against previous record value to see if it changed
014100080828     C     DSRCD1        IFNE      DSRCD2
014200080828     C                   EXCEPT    RELESE
014300080828     C                   MOVEL     DSRCD1        DSRCD2
014400080828     C                   SETON                                        64
014500080828     C                   GOTO      DSPLY
014600080828     C                   END
014700080828     C* The re-access of the data base record has overlayed the display
014800080828     C*   file field values. Use RTNDTA keyword and read again
014900080828     C                   READ      DSPLY2                                 20
015000080828     C* If Add type,  check for F3 and if so delete rcd already added
015100080828     C     '3'           IFEQ      ACTION
015200080828     C   93              DO
015300080828     C                   DELETE    MLGMSTR
015400080828     C                   GOTO      PROMPT
015500080828     C                   END
015600080828     C*    Validate routine goes to DSPLY if error occurs
015700080828     C                   EXSR      VALIDT
015800080828     C* Record is already added, perform update and check for error
015900080828     C                   UPDATE    MLGMSTR                              20
016000080828     C*    Check error routine will not return if error occurs
016100080828     C   20              EXSR      CHKERR
016200080828     C                   GOTO      PROMPT
016300080828     C                   END
016400080828     C* If Chg type, validate fields
016500080828     C     '2'           IFEQ      ACTION
016600080828     C*    Validate routine goes to DSPLY if error or re-prompt occurs
016700080828     C                   EXSR      VALIDT
016800080828     C                   UPDATE    MLGMSTR                              20
016900080828     C*    Check error routine will not return if error occurs
017000080828     C   20              EXSR      CHKERR
017100080828     C                   GOTO      PROMPT
017200080828     C                   END
017300080828     C* If Dlt
017400080828     C     '4'           IFEQ      ACTION
017500080828     C* F12 has already been processed. If not F8, return with error
017600080828     C  N92              DO
017700080828     C                   SETON                                        5159
017800080828     C                   EXCEPT    RELESE
017900080828     C                   GOTO      DSPLY
018000080828     C                   END
018100080828     C                   DELETE    MLGMSTR
018200080828     C                   GOTO      PROMPT
018300080828     C                   END
018400080828     C* End of program routine: end the sub pgm if it was called
018500080828     C     ENDPGM        TAG
018600080828     C     CALLED        IFEQ      'X'
018700080828     C                   MOVE      'X'           PGMEND            1
018800080828     C                   EXSR      SUBPGM
018900080828     C                   END
019000080828     C                   MOVE      'GOOD    '    RTNCDE
019100080828     C     BADEND        TAG
019200080828     C                   SETON                                        LR
019300080828     C                   RETURN
019400080828     C* Validation subroutine
019500080828     C     VALIDT        BEGSR
019600080828     C*    Valid state abbrev and account types are checked via DDS
019700080828     C     MLACCT        CABEQ     *ZEROS        DSPLY                    71
019800080828     C     MLSRCH        CABEQ     *BLANKS       DSPLY                    72
019900080828     C     MLCITY        CABEQ     *BLANKS       DSPLY                    73
020000080828     C     MLSTAT        CABEQ     *BLANKS       DSPLY                    74
020100080828     C     MLZIP         CABEQ     *ZEROS        DSPLY                    75
020200080828     C                   ENDSR
020300080828     C* Check for disk write or update error
020400080828     C     CHKERR        BEGSR
020500080828     C* Status 01021 is a duplicate key error
020600080828     C     STS           CABEQ     01021         DSPLY                    65
020700080828     C                   MOVE      'DSKERR  '    RTNCDE
020800080828     C                   GOTO      BADEND
020900080828     C                   ENDSR
021000080828     C* Call sub pgm for name search
021100080828     C     SUBPGM        BEGSR
021200080828     C                   CALLB     'MLGNAMR'                            49
021300080828     C                   PARM                    SEARCH
021400080828     C                   PARM                    ACCT
021500080828     C                   PARM                    PGMEND
021600080828     C                   ENDSR
021700080828     O* Output specs for releasing a locked record and adding new key
021800080828     OMLGMSTR   E            RELESE
021900080828     O          EADD         ADDNEW
022000080828     O                       MLACCT
022100080828** ACT   Action text
022200080828Display   Change    Add       Delete    GE value  Search
