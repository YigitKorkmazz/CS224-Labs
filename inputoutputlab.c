void Wait() {
 Delay_ms(1000);
}




void main() {
 AD1PCFG = 0xFFFF;
 DDPCON.JTAGEN = 0; 
 TRISE = 0XFFFF; 
 TRISA = 0X0000;  








 LATA.F0 = 0;
 LATA.F1 = 0;
 LATA.F2 = 0;




 Wait();




 while(1)
 {
         unsigned int btn0 = PORTE.F0;
         unsigned int btn1 = PORTE.F1;




         if(btn0 ^ btn1){
                Wait();




                if(btn1 == 1){
                  LATA.F0 = 1;
                  LATA.F1 = 1;
                  LATA.F2 = 0;
                }
                else{
                     LATA.F0 = 0;
                     LATA.F1 = 0;
                     LATA.F2 = 1;
                }




                Wait();
                LATA.F0 = 0;
                LATA.F1 = 0;
                LATA.F2 = 0;
         }




         else
         {
             LATA.F0 = 0;
             LATA.F1 = 0;
             LATA.F2 = 0;
         }
}
}








(c ) 
- TRISA: Configures PORTA as output (used to drive segment lines a–g)
- TRISE: Configures PORTE as output (used to enable digits)
- PORTA: Used to output the binary pattern for each digit segment
- PORTE: Used to select which digit to activate (only one active at a time




(d )
/*
CS224 - Lab 7
Seven-Segment Display: Fibonacci Sequence Visualization




Displays each Fibonacci number with a wait proportional to its value.
Each number is broken into 4 digits and shown using multiplexing.
*/




unsigned char segmentMap[10] = {
    0x3F, // 0
    0x06, // 1
    0x5B, // 2
    0x4F, // 3
    0x66, // 4
    0x6D, // 5
    0x7D, // 6
    0x07, // 7
    0x7F, // 8
    0x6F  // 9
};




unsigned int prevVal = 0;
unsigned int currVal = 1;
unsigned int displayCounter = 0;




unsigned int d1 = 0; // leftmost digit
unsigned int d2 = 0;
unsigned int d3 = 0;
unsigned int d4 = 0; // rightmost digit




void setup() {
    AD1PCFG = 0xFFFF;    // All analog pins to digital
    JTAGEN_bit = 0;      // Release pins from JTAG




    TRISA = 0x00;        // PORTA as output (segments A-G)
    TRISE = 0x00;        // PORTE as output (digit selectors)
}




void displayNumber(unsigned int num, unsigned int duration_ms) {
    // Break the number into 4 digits
    d1 = num / 1000;
    d2 = (num / 100) % 10;
    d3 = (num / 10) % 10;
    d4 = num % 10;




    // Multiplex the display for num * 100 ms total
    while (displayCounter < num * 100) {
        // Digit 1
        PORTA = segmentMap[d1];
        PORTE = 0x01;
        Delay_ms(1);




        // Digit 2
        PORTA = segmentMap[d2];
        PORTE = 0x02;
        Delay_ms(1);




        // Digit 3
        PORTA = segmentMap[d3];
        PORTE = 0x04;
        Delay_ms(1);




        // Digit 4
        PORTA = segmentMap[d4];
        PORTE = 0x08;
        Delay_ms(1);




        displayCounter++;
    }




    displayCounter = 0;
}




void main() {
    setup();




    while (1) {
        displayNumber(currVal, currVal * 100);




        // Fibonacci update
        currVal = currVal + prevVal;
        prevVal = currVal - prevVal;
    }
}