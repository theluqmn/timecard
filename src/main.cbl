       IDENTIFICATION DIVISION.
       PROGRAM-ID. TIMECARD.
       AUTHOR. theluqmn.

       DATA DIVISION.
       WORKING-STORAGE SECTION.
      *SYSTEM VARIABLES
       01 CLI-INPUT PIC X(48).         01 CLI-ACCEPT PIC X(48).

      *TEMPORARY VARIABLES
       01 TP-STR-A PIC X(48).          01 TP-STR-B PIC X(48).

      *ANSI FORMATTING
       01 ESC PIC X(2) VALUE X'1B5B'.  01 RES PIC X(2) VALUE "0m".
       01 UND PIC X(2) VALUE "4;".     01 BLD PIC X(2) VALUE "1;".
       01 BLC PIC X(3) VALUE "30m".    01 WHT PIC X(3) VALUE "37m".
       01 RED PIC X(3) VALUE "31m".    01 BLU PIC X(3) VALUE "34m".
       01 GRY PIC X(3) VALUE "30m".
       01 BG-WHT PIC X(3) VALUE "47m".

       PROCEDURE DIVISION.
       CALL "CLI-CLEAR".
       DISPLAY ESC BG-WHT ESC BLD BLC "TIMECARD" ESC RES.
       DISPLAY "A CLI-based task management system built using COBOL!".
       DISPLAY " ".
       DISPLAY "Basics: 'setup', 'help', 'exit'.".
       PERFORM MAIN.

       CLI-HANDLER.
           DISPLAY "> " WITH NO ADVANCING.
           ACCEPT CLI-ACCEPT.
           MOVE FUNCTION LOWER-CASE(CLI-ACCEPT) TO CLI-INPUT.

           IF CLI-INPUT = "exit" THEN
               DISPLAY ESC BLU "Exiting..." ESC RES
           ELSE IF CLI-INPUT  = "help" THEN
               PERFORM SCREEN-HELP
           ELSE
               DISPLAY ESC RED "Unknown command!" ESC RES
           END-IF.

       SCREEN-HELP.
           PERFORM BORDER-TOP.
           DISPLAY "│ " ESC UND BLD WHT "HELP" ESC RES
           "                                                          "
           "│".
           PERFORM BORDER-EMPTY.
           DISPLAY
           "│ GitHub: https://github.com/theluqmn/timecard     "
           ESC RES
           "             │".
           PERFORM BORDER-EMPTY.
           DISPLAY 
           "│ - 'help'           - Displays this message       "
           "             │".
           DISPLAY 
           "│ - 'exit'           - Exits the program           "
           "             │".
           PERFORM BORDER-BOT.

       BORDER-TOP.
           DISPLAY "┌" WITH NO ADVANCING.
           DISPLAY "─────────" WITH NO ADVANCING.
           DISPLAY "─────────" WITH NO ADVANCING.
           DISPLAY "─────────" WITH NO ADVANCING.
           DISPLAY "─────────" WITH NO ADVANCING.
           DISPLAY "─────────" WITH NO ADVANCING.
           DISPLAY "─────────" WITH NO ADVANCING.
           DISPLAY "─────────" WITH NO ADVANCING.
           DISPLAY "┐".
       BORDER-BOT.
           DISPLAY "└" WITH NO ADVANCING.
           DISPLAY "─────────" WITH NO ADVANCING.
           DISPLAY "─────────" WITH NO ADVANCING.
           DISPLAY "─────────" WITH NO ADVANCING.
           DISPLAY "─────────" WITH NO ADVANCING.
           DISPLAY "─────────" WITH NO ADVANCING.
           DISPLAY "─────────" WITH NO ADVANCING.
           DISPLAY "─────────" WITH NO ADVANCING.
           DISPLAY "┘".
       BORDER-EMPTY.
           DISPLAY "│                                        "
           "                       │".

       MAIN.
           PERFORM CLI-HANDLER UNTIL CLI-INPUT = "exit".
           STOP RUN.
       END PROGRAM TIMECARD.
