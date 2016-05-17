#Questions
##4.1 
First digit(before comma) represents sign.
0,01100.101<sub>2</sub> = +(1 * 2<sup>3</sup> + 1 * 2<sup>2</sup> + 1 * 2<sup>-1</sup> + 1 * 2<sup>-3</sup>)<sub>10</sub> = +(8 + 4 + 0.5 + 0.125)<sub>10</sub> = 12.625<sub>10</sub>
0,10001.010<sub>2</sub> = +(1 * 2<sup>4</sup> + 1 * 2<sup>0</sup> + 1 * 2<sup>-2</sup>)<sub>10</sub> = +(16 + 1 + 0.25)<sub>10</sub> = 17.250<sub>10</sub>
##4.2 
h0 = 1,11101; h1 = 1,11000; h2 = 1,11000; h3 = 0,00000; h4 = 0,01011; h5 = 0,10000; h6 = 0,01011; h7 = 0,00000; h8 = 1,11000; h9 = 1,11000; h10 = 1,11101.
##4.3
Worst case scenario for accumulator is when all incoming arguments are successively added to each other (same sign) and they have maximum input value. As max input value is 1, we can just sum the absolute values of all the coefficients to get most hostile input. In the actual case the sum is: 3+8+8+11+16+11+8+8+3=76. The number of additional bits required to not overflow while calculating result is [log<sub>2</sub>76] = 7. Overall number of bits is 18 + 7 = 25. We shift result 6 bit right to get rid of additional accuracy we aquired after multiplying by 6-bit-long fracture. We obtain data after checking overflow of accumulator, saturating the output if it's present, and getting rid of additional accuracy by shifting result right and converging result with the remaining bits.