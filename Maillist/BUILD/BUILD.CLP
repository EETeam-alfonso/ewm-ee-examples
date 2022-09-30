000200111213/* Licensed Materials - Property of IBM                                   */
000201111213/*    [BUILD.CLP]                                                         */
000202111213/* (C) Copyright IBM Corporation 1993, 2011                               */
000203111213/* U.S. Government Users Restricted Rights: Use duplication or            */
000204111213/*      disclosure restricted by GSA ADP Schedule Contract with IBM Corp. */
000205111213             PGM        PARM(&LNAME)
000206111213
000300080910/* This CL program takes a single parameter (library name) and builds all */
000400081111/* of the source for this small RPG-CL application  2:52PM                */
000500080828
000600080828/* To compile this program (all one command):                             */
000700080828/*      CRTCLPGM PGM(lib/BUILD) SRCFILE(lib/BUILD) SRCMBR(*PGM)           */
000800080828/*           OPTION(*SRCDBG)                                              */
000900080910/*                                                                        */
001000080910/* To run this program:                                                   */
001100080910/*      CALL PGM(lib/BUILD) PARM(lib)                                     */
001200080910/*                                                                        */
001300080910/* where lib is the library name which the build is being performed in.   */
001301090529
001700080828             DCL        VAR(&LNAME) TYPE(*CHAR) LEN(10)
001701090529             DCL        VAR(&FLAG) TYPE(*CHAR) LEN(1) VALUE('N')
001800080828
001900080910  /**********************************************************/
002000080910  /* Clean the build library                                */
002100080910  /**********************************************************/
002200080910
002300080910             MONMSG     MSGID(CPF2105)
002400080910             DLTF       FILE(&LNAME/MLGNAMD)
002500080910             DLTF       FILE(&LNAME/MLGMTND)
002600080910             DLTF       FILE(&LNAME/MLGMNUD)
002700080910             DLTF       FILE(&LNAME/MLGINQD)
002800080910             DLTF       FILE(&LNAME/MLGNAML)
002900080910             DLTF       FILE(&LNAME/MLGMSTL3)
003000080910             DLTF       FILE(&LNAME/MLGMSTL2)
003100080910             DLTF       FILE(&LNAME/MLGMSTL)
003200090423   /*        DLTF       FILE(&LNAME/MLGMSTP)      */
003300090423   /*        DLTF       FILE(&LNAME/MLGREFP)      */
003400080910
003500080910
003600080828  /**********************************************************/
003700080828  /* CREATE PF-DTA FILES IN LNAME LIBRARY                   */
003800080828  /**********************************************************/
003900090423             CHKOBJ     OBJ(&LNAME/MLGREFP) OBJTYPE(*FILE)
004000090529             MONMSG     MSGID(CPF9801) EXEC(CHGVAR VAR(&FLAG) +
004001090529                          VALUE('Y'))
004002090529
004003090529             IF         COND(&FLAG *EQ 'Y') THEN(DO)
004100080828             CRTPF      FILE(&LNAME/MLGREFP) SRCFILE(&LNAME/QDDSSRC)
004300090423             ENDDO
004400090423             ELSE (DO)
004500090423             CHGPF      FILE(&LNAME/MLGREFP) SRCFILE(&LNAME/QDDSSRC)
004700090423             ENDDO
004701090723
004702090723             CHGVAR     VAR(&FLAG) VALUE('N')
004703090811             CHKOBJ     OBJ(&LNAME/MLGMSTP) OBJTYPE(*FILE)
004705090723             MONMSG     MSGID(CPF9801) EXEC(CHGVAR VAR(&FLAG) VALUE('Y'))
004708090723
004709090723             IF         COND(&FLAG *EQ 'Y') THEN(DO)
004711090723                CRTPF      FILE(&LNAME/MLGMSTP) SRCFILE(&LNAME/QDDSSRC)
004712090723             ENDDO
004713090723             ELSE       (DO)
004715090723                CHGPF      FILE(&LNAME/MLGMSTP) SRCFILE(&LNAME/QDDSSRC)
004716090723             ENDDO
004717090723
004800080828  /**********************************************************/
004900080828  /* CREATE LF AND DSPF FILES IN LNAME LIBRARY              */
005000080828  /**********************************************************/
005100080828             CRTLF      FILE(&LNAME/MLGMSTL) SRCFILE(&LNAME/QDDSSRC) +
005200080828                          SRCMBR(MLGMSTL)
005300080828
005400080828             CRTLF      FILE(&LNAME/MLGMSTL2) SRCFILE(&LNAME/QDDSSRC) +
005500080828                          SRCMBR(MLGMSTL2)
005600080828
005700080828             CRTLF      FILE(&LNAME/MLGMSTL3) SRCFILE(&LNAME/QDDSSRC) +
005800080828                          SRCMBR(MLGMSTL3)
005900080828
006000080828             CRTLF      FILE(&LNAME/MLGNAML) SRCFILE(&LNAME/QDDSSRC) +
006100080828                          SRCMBR(MLGNAML)
006200080828
006300080828             CRTDSPF    FILE(&LNAME/MLGINQD) SRCFILE(&LNAME/QDDSSRC) +
006400080828                          SRCMBR(MLGINQD)
006500080828
006600080828             CRTDSPF    FILE(&LNAME/MLGMNUD) SRCFILE(&LNAME/QDDSSRC) +
006700080828                          SRCMBR(MLGMNUD)
006800080828
006900080828             CRTDSPF    FILE(&LNAME/MLGMTND) SRCFILE(&LNAME/QDDSSRC) +
007000080828                          SRCMBR(MLGMTND)
007100080828
007200080828             CRTDSPF    FILE(&LNAME/MLGNAMD) SRCFILE(&LNAME/QDDSSRC) +
007300080828                          SRCMBR(MLGNAMD)
007400080828
007500080828  /**********************************************************/
007600080828  /* CREATE *MODULES in LNAME LIBRARY.                      */
007700080828  /**********************************************************/
007800080828             CRTCLMOD   MODULE(&LNAME/MLGMNUC) SRCFILE(&LNAME/QCLSRC)
007900080828
008000080828             CRTCLMOD   MODULE(&LNAME/MLGMTNC) SRCFILE(&LNAME/QCLSRC)
008100080828
008200080828             CRTCLMOD   MODULE(&LNAME/MLGRPTC) SRCFILE(&LNAME/QCLSRC)
008300080828
008400080828             CRTCLMOD   MODULE(&LNAME/MLGRPTC2) SRCFILE(&LNAME/QCLSRC)
008500080828
008600080828             CRTRPGMOD  MODULE(&LNAME/MLGINQR) SRCFILE(&LNAME/QRPGLESRC)
008700080828
008800080828             CRTRPGMOD  MODULE(&LNAME/MLGMTNR) SRCFILE(&LNAME/QRPGLESRC)
008900080828
009000080828             CRTRPGMOD  MODULE(&LNAME/MLGNAMR) SRCFILE(&LNAME/QRPGLESRC)
009100080828
009200080828             CRTRPGMOD  MODULE(&LNAME/MLGLBLR) SRCFILE(&LNAME/QRPGLESRC)
009300080828
009400080828             CRTRPGMOD  MODULE(&LNAME/MLGRPTR) SRCFILE(&LNAME/QRPGLESRC)
009500080828
009600080828  /**********************************************************/
009700080828  /* CREATE *SRVPGMs in LNAME LIBRARY.                      */
009800080828  /**********************************************************/
009900080910             CRTSRVPGM  SRVPGM(&LNAME/MLGRPTS) MODULE(&LNAME/MLGRPTR) +
010000080910                          SRCFILE(&LNAME/QSRVSRC) DETAIL(*FULL)
010100080828
010200080910             CRTSRVPGM  SRVPGM(&LNAME/MLGMTNS) MODULE(&LNAME/MLGMTNC +
010300080910                          &LNAME/MLGMTNR &LNAME/MLGNAMR) +
010400080910                          SRCFILE(&LNAME/QSRVSRC) DETAIL(*FULL)
010500080828
010600080828  /**********************************************************/
010700080828  /* CREATE *PGMs in LNAME LIBRARY.                         */
010800080828  /**********************************************************/
010900080910             CRTPGM     PGM(&LNAME/MAILLIST) MODULE(&LNAME/MLGMNUC +
011000080910                          &LNAME/MLGINQR &LNAME/MLGLBLR) +
011100080910                          ENTMOD(&LNAME/MLGMNUC) BNDSRVPGM(&LNAME/MLGMTNS) +
011200080910                          DETAIL(*FULL)
011300080828
011400080910             CRTPGM     PGM(&LNAME/MLGRPTC) MODULE(&LNAME/MLGRPTC) +
011500080910                          BNDSRVPGM(&LNAME/MLGRPTS) DETAIL(*FULL)
011600080828
011700080910             CRTPGM     PGM(&LNAME/MLGRPTC2) MODULE(&LNAME/MLGRPTC2) +
011800080910                          BNDSRVPGM(&LNAME/MLGRPTS) DETAIL(*FULL)
011900080828
012000080828
012100080828
012200080828 END:        SNDPGMMSG  MSG('Build Has Completed') TOPGMQ(*PRV)
012300080828             GOTO       FINAL
012400100128 ERROR:
012500080828             SNDPGMMSG  MSG('An error occurred during BUILD. See the +
012600080828                          previously listed messages in the job log.') +
012700080828                          TOPGMQ(*PRV)
012800080828 FINAL:      ENDPGM
