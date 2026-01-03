       IDENTIFICATION DIVISION.
       PROGRAM-ID. TIMECARD.
       AUTHOR. theluqmn.


       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT TASK-FILE ASSIGN TO "tasks"
               ORGANIZATION IS INDEXED
               ACCESS IS DYNAMIC
               RECORD KEY IS TASK-ID
               FILE STATUS IS SFS-TASK.


       DATA DIVISION.
       FILE SECTION.
       FD TASK-FILE.
       01 TASK-RECORD.
           05 TASK-ID                  PIC X(24).
           05 TASK-DETAILS             PIC X(48).
           05 TASK-DATE                PIC 9(8).
           05 TASK-STATUS              PIC 9(1).

       WORKING-STORAGE SECTION.
      *SYSTEM VARIABLES
       01 CLI-INPUT PIC X(48).         01 CLI-ACCEPT PIC X(48).
       01 SFS-TASK PIC XX.             88 SFS-TASK-NOT-FOUND VALUE "35".
       01 SYS-CURRENT-DATE PIC 9(8).
       01 SYS-CURRENT-DATE-REDEF REDEFINES SYS-CURRENT-DATE.
           05 SYS-CURRENT-YEAR         PIC 9(4).
           05 SYS-CURRENT-MONTH        PIC 9(2).
           05 SYS-CURRENT-DAY          PIC 9(2).

      *TEMPORARY VARIABLES
       01 TP-STR-A PIC X(48).          01 TP-STR-B PIC X(48).

      *ANSI FORMATTING
       01 ESC PIC X(2) VALUE X'1B5B'.  01 RES PIC X(2) VALUE "0m".
       01 UND PIC X(2) VALUE "4;".     01 BLD PIC X(2) VALUE "1;".
       01 BLC PIC X(3) VALUE "30m".    01 WHT PIC X(3) VALUE "37m".
       01 RED PIC X(3) VALUE "31m".    01 BLU PIC X(3) VALUE "34m".
       01 GRY PIC X(3) VALUE "30m".    01 GRN PIC X(3) VALUE "32m".
       01 YEL PIC X(3) VALUE "33m".
       01 BG-WHT PIC X(3) VALUE "47m".


       PROCEDURE DIVISION.
       CALL "CLI-CLEAR".
       DISPLAY ESC BG-WHT ESC BLD BLC "TIMECARD" ESC RES.
       DISPLAY "A CLI-based task management system built using COBOL!".
       DISPLAY " ".
       PERFORM INITIALISATION.
       PERFORM MAIN.

       INITIALISATION.
           DISPLAY "Initialising...".
           ACCEPT SYS-CURRENT-DATE FROM DATE YYYYMMDD.
           DISPLAY ESC BLU "[i] Current date: "
           SYS-CURRENT-YEAR "/" SYS-CURRENT-MONTH "/" SYS-CURRENT-DAY
           ESC RES.
           
           OPEN INPUT TASK-FILE.
           IF SFS-TASK-NOT-FOUND THEN
               DISPLAY ESC YEL "[!] Task file not found." ESC RES
               OPEN OUTPUT TASK-FILE
               CLOSE TASK-FILE
               DISPLAY ESC GRN "[/] Task file was created." ESC RES
           ELSE
               DISPLAY ESC BLU "[i] Task file located." ESC RES
           END-IF.
           CLOSE TASK-FILE.

           DISPLAY ESC GRN "Timecard is ready" ESC RES.
           DISPLAY " ".

       CLI-HANDLER.
           DISPLAY "> " WITH NO ADVANCING.
           ACCEPT CLI-ACCEPT.
           MOVE FUNCTION LOWER-CASE(CLI-ACCEPT) TO CLI-INPUT.
           CALL "CLI-CLEAR".

           IF CLI-INPUT = "exit" THEN
               DISPLAY ESC BLU "[i] Exiting..." ESC RES
           ELSE IF CLI-INPUT  = "help" THEN
               PERFORM SCREEN-HELP
           ELSE
               DISPLAY ESC RED "[!] Unknown command!" ESC RES
           END-IF.
       
       CLI-HEADER.
           DISPLAY "  Timecard                                        "
           "   "
           SYS-CURRENT-YEAR "/" SYS-CURRENT-MONTH "/" SYS-CURRENT-DAY.

       SCREEN-HELP.
           PERFORM CLI-HEADER.
           CALL "BORDER-TOP".
           DISPLAY "│ " ESC UND BLD WHT "HELP" ESC RES
           "                                                          "
           "│".
           CALL "BORDER-EMPTY".
           DISPLAY
           "│ GitHub: https://github.com/theluqmn/timecard     "
           ESC RES
           "             │".
           CALL "BORDER-EMPTY".
           DISPLAY 
           "│ - 'help'           - Displays this message       "
           "             │".
           DISPLAY 
           "│ - 'exit'           - Exits the program           "
           "             │".
           CALL "BORDER-BOT".

       MAIN.
           PERFORM CLI-HANDLER UNTIL CLI-INPUT = "exit".
           STOP RUN.
       END PROGRAM TIMECARD.
