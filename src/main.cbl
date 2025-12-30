       IDENTIFICATION DIVISION.
       PROGRAM-ID. Timecard.
       AUTHOR. theluqmn.

       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01 CLI-INPUT                            PIC X(32).
      *ansi colours
       01 ESC                                  PIC X VALUE X'1B'.
       01 RES                                  PIC X(3) VALUE "[0m".
       01 GRY                                  PIC X(4) VALUE "[30m".
       01 UND                                  PIC X(6) VALUE "[4;97m".
       01 BLD                                  PIC X(6) VALUE "[1;37m".
       01 RED                                  PIC X(4) VALUE "[31m".
       01 BLU                                  PIC X(4) VALUE "[34m".
      *temporary variables
       01 TP-STR-A                             PIC X(32).

       PROCEDURE DIVISION.
       DISPLAY ESC UND "Timecard" ESC RES.
       PERFORM MAIN.
       CLI-HANDLER.
           DISPLAY "> " WITH NO ADVANCING.
           ACCEPT TP-STR-A.
           MOVE FUNCTION LOWER-CASE(TP-STR-A) TO CLI-INPUT.

           IF CLI-INPUT = "exit" THEN
               DISPLAY ESC BLU "exiting..." ESC RES
           ELSE
               DISPLAY ESC RED "unknown command." ESC RES
           END-IF.
       MAIN.
           PERFORM CLI-HANDLER UNTIL CLI-INPUT = "exit".
           STOP RUN.
       END PROGRAM Timecard.
