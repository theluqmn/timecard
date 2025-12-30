       IDENTIFICATION DIVISION.
       PROGRAM-ID. Timecard.
       AUTHOR. theluqmn.

       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01 CLI-INPUT                            PIC X(32).
      *ansi colours
       01 ESC                                  PIC X VALUE X'1B'.
       01 RES                                  PIC X(3) VALUE "[0m".
      *temporary variables
       01 TP-STR-A                             PIC X(32).
       

       PROCEDURE DIVISION.
       DISPLAY "hello from cobol ahh".
       PERFORM MAIN.
       CLI-HANDLER.
           DISPLAY "> " WITH NO ADVANCING.
           ACCEPT TP-STR-A.
           MOVE FUNCTION LOWER-CASE(TP-STR-A) TO CLI-INPUT.

           IF CLI-INPUT = "exit" THEN
               DISPLAY "exiting..."
           ELSE
               DISPLAY "unknown command."
           END-IF.
       MAIN.
           PERFORM CLI-HANDLER UNTIL CLI-INPUT = "exit".
           STOP RUN.
       END PROGRAM Timecard.
