000100111213      * Licensed Materials - Property of IBM
000101111213      *    [MLGLBLR.RPGLE]
000102111213      * (C) Copyright IBM Corporation 1993, 2011
000103111213      * U.S. Government Users Restricted Rights: Use duplication or
000104111213      *      disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
000105111213      *
000106111213     F* MLGLBLR - Mailing list label printing program
000107111213     F* MLGLBLR - Mailing list label printing program
000200080828     FMLGMSTL   IP   E           K DISK
000300080828     FQPRINT    O    F  132        PRINTER OFLIND(*INOF)
000400080828     F                                     FORMLEN(8)
000500080828     F                                     FORMOFL(6)
000501090417      * Include a copy member
000502090417     D/INCLUDE QRPGLEINC,FOOCPYR
000600080828     IMLGMSTR       01
000700080828     OQPRINT    D    01                     1 03
000800080828     O                       MLNAME              44
000900080828     O          D    01                     1
001000080828     O                       MLADDR              44
001100080828     O          D    01                     1
001200080828     O                       MLCITY              44
001300080828     O          D    01                     1
001400080828     O                       MLSTAT              26
001500080828     O                       MLZIP               33
