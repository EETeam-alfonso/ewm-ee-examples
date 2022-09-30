000100111213      * Licensed Materials - Property of IBM
000101111213      *    [MLGINQR.RPGLE]
000102111213      * (C) Copyright IBM Corporation 1993, 2011
000103111213      * U.S. Government Users Restricted Rights: Use duplication or
000104111213      *      disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
000105111213      *
000106111213     F* MLGINQR - Mailing List Inquiry
000200080828     FMLGMSTP   IF   E           K DISK
000300080828     FMLGINQD   CF   E             WORKSTN
000301100112      * Include a copy member  --test
000302090417     D/INCLUDE QRPGLEINC,FOOCPYR
000400080828     C* Prompt for account number
000500080828     C     PROMPT        TAG
000600080828     C                   EXFMT     DSPLY1
000700080828     C* Check for F3
000800080828     C   93              GOTO      ENDPGM
000900080828     C* If account number is zeros, show prompt again with error msg
001000080828     C     ACCT          CABEQ     *ZEROS        PROMPT                   41
001100080828     C* Chain to account number record in file
001200080828     C     ACCT          CHAIN     MLGMSTR                            42
001300080828     C* If missing, show prompt again with error message
001400080828     C   42              GOTO      PROMPT
001500080828     C* Display the record
001600080828     C                   EXFMT     DSPLY2
001700080828     C                   GOTO      PROMPT
001800080828     C* End of program routine
001900090831     C     ENDPGM        TAG
002000080828     C                   SETON                                        LR
002100080828     C                   RETURN
