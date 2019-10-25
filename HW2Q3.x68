*-----------------------------------------------------------
* Title      : HW2 Q3
* Written by : Kaib Cropley
* Date       : 10/22/2019
* Description: Pattern Finding and Cumulative program.
*-----------------------------------------------------------


    ORG    $1000
START:                  ; first instruction of program
    JSR         GET_USER_BYTE   * Get first input
    MOVE.B      D1,input        * Move it to specified address
    MOVE.W      #$6000,A1       * Move it to specified address
    CLR         D3              * Clear D3 just to make sure no data is in there
    MOVE.L      #0,CarryBit     * Clear the carry bit address just to make sure it's empty
    BRA         CHECK_VAL

GET_USER_BYTE:
    LEA         Message_input,A1 * Prompt the user
    JSR         PRINT_STR
    MOVE.B      #5,D0           * Task 5: Read byte from the keyboard
    TRAP        #15             * Execute task 5
    RTS
    
CHECK_VAL:
    CMP.B       (A1)+,D1        * Compare curr addr to our value   
    BEQ         VALUE_FOUND     * If equal then move on
    
    CMPA.L      #$8000,A1       * See if A1 is at the end of our range
    BNE         CHECK_VAL       * If not at end of the range keep checking the value
    BEQ         VALUE_NOT_FOUND * If at the end of range assume it's not found
    
VALUE_FOUND:
    MOVE.L      A1,Addr1        * Save address we found value at
    CLR         D2              * Make sure D2 is clear
    BRA         ADD_SUM         * Start getting the sum

VALUE_NOT_FOUND:                * If no value was found keep addr1 at default (6000)
    CLR         D2              * Make sure D2 is clear
    BRA         ADD_SUM         * Start getting the sum
    
ADD_SUM:
    CLR         D4
    CMP.L       #512,D2         * Loop until counter is at 512 meaning it has ran 512 times
    BEQ         DONE            * If D2 = 512 then were done
    ADDQ        #1,D2           * Increment counter

    ADD.B       (A1)+,D4        * Intermediary to only get the first byte
    ADD.W       D4,D3           * D3 is our placeholder for addsum
    BCC         ADD_SUM         * If no overflow continue to loop
    BRA         CHANGE_CARRY_BIT * If we over flow add to carrybit, will come back to loop

CHANGE_CARRY_BIT:
    MOVE.L      #1,CarryBit     * Store carry bit as 1 to signify it was carried
    BRA         ADD_SUM         * Continue to loop

PRINT_STR:
    MOVE.B      #14,D0          * Print string without ending the line
    TRAP        #15
    RTS

PRINT_STR_END_LINE:
    MOVE.B      #13,D0          * Print string with an end of line
    TRAP        #15
    RTS

PRINT_NUM:
    MOVE.B      #3,D0           * Print a number
    TRAP        #15
    RTS

DONE:
    MOVE.L      D3,Addsum       * Move sum value that was kept in D3 to Addsum

    LEA         Message_newLine,A1
    JSR         PRINT_STR_END_LINE

    * Print out all results

    LEA         Message_addr1,A1
    JSR         PRINT_STR
    MOVE.L      (Addr1),D1
    JSR         PRINT_NUM
    LEA         Message_newLine,A1
    JSR         PRINT_STR_END_LINE
    
    LEA         Message_addsum,A1
    JSR         PRINT_STR
    MOVE.L      Addsum,D1
    JSR         PRINT_NUM
    LEA         Message_newLine,A1
    JSR         PRINT_STR_END_LINE

    LEA         Message_carryBit,A1
    JSR         PRINT_STR
    MOVE.L      CarryBit,D1
    JSR         PRINT_NUM
    LEA         Message_newLine,A1
    JSR         PRINT_STR_END_LINE

    SIMHALT                         * End program
    
* Variables & constant references
input           DC.W    $A000
Addsum          EQU     $A004
CarryBit        EQU     $A008
Addr1           EQU     $6000

* Ouput text
CR              EQU     $0D     * Ascii for carriage return
LF              EQU     $0D     * Ascii for carriage return
Message_newLine DC.B    CR,LF,0
Message_input   DC.B    'Please input a hex byte: ',0
Message_addr1   DC.B    'Addr1: ',0
Message_addsum  DC.B    'Addsum: ',0
Message_carryBit DC.B   'CarryBit: ',0


    END    START        ; last line of source



*~Font name~Courier New~
*~Font size~14~
*~Tab type~0~
*~Tab size~4~
