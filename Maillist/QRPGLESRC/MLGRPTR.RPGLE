000100111213      * Licensed Materials - Property of IBM
000101111213      *    [MLGRPTR.RPGLE]
000102111213      * (C) Copyright IBM Corporation 1993, 2011
000103111213      * U.S. Government Users Restricted Rights: Use duplication or
000104111213      *      disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
000105111213      *
000107111213     F* MLGRPTR - Mailing list report format
000200080828     FMLGMSTP   IF   E           K DISK
000300080828     FQPRINT    O    F  132        PRINTER OFLIND(*INOF)
000301100112      * Include of a copy member --test
000302090417     D/INCLUDE QRPGLEINC,BARCPYR
000400080828     C* Initialize and print heading
000500080828     C                   TIME                    TIME              6 0
000600080828     C                   EXCEPT    HEADNG
000700080828     C* Read an account record and print
000800080828     C     READ          TAG
000900080828     C                   READ      MLGMSTR                                20
001000080828     C   20              GOTO      ENDPGM
001100080828     C                   ADD       1             COUNT             7 0
001200080828     C                   EXCEPT    DETAIL
001300080828     C   OF              EXCEPT    HEADNG
001400080828     C                   GOTO      READ
001500080828     C* End of program routine
001600080828     C     ENDPGM        TAG
001700080828     C                   EXCEPT    TOTAL
001800080828     C                   SETON                                        LR
001900080828     C                   RETURN
002000080828     OQPRINT    E            HEADNG         2 06
002100080828     O                       UDATE         Y     10
002200080828     O                       TIME                20 '0 :  :  '
002300090618     O                                           60 'Cust listing'
002400080828     O                                          120 'Page'
002500080828     O                       PAGE          Z    125
002600080828     O          E            HEADNG         2
002700080828     O                                            7 'Number'
002800080828     O                                           16 'Name'
002900080828     O                                           38 'City'
003000080828     O                                           61 'State'
003100080828     O                                           69 'Zip'
003200080828     O                                           78 'Type'
003300080828     O                                           92 'Name search'
003400080828     O          E            DETAIL         1
003500080828     O                       MLACCT               6
003600080828     O                       MLNAME              32
003700080828     O                       MLCITY              54
003800080828     O                       MLSTAT              59
003900080828     O                       MLZIP               71
004000080828     O                       MLTYPE              76
004100080828     O                       MLSRCH              91
004200080828     O          E            TOTAL       1  1
004300080828     O                                           25 'Count of records-'
004400080828     O                       COUNT         1
