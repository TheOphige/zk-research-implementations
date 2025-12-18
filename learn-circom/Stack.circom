include "circomlib/comparators.circom";
include "circomlib/gates.circom";

// RETURNS 1 IF ALL THE INPUTS ARE 1
template AND3() {
  signal input in[3];
  signal output out;

  signal temp;
  temp <== in[0] * in[1];
  out <== temp * in[2];
}

// This component will be used in a loop to determine if a particular column j should be copied. 
// It sets out = 1 if a particular column should be copied. 
// This component is applied to each column for each row.

// j is the column number 
// bits is how many bits we need for the LessEqThan component
template ShouldCopy(j, bits) {
  signal input sp; // index of the top element + 1
  signal input is_pop;
  signal input is_push;
  signal input is_nop;

  // out = 1 if should copy
  signal output out;

  // sanity checks
  // you can only have one of pop, push or nop at a time
  is_pop + is_push + is_nop === 1;
  is_nop * (1 - is_nop) === 0;
  is_push * (1 - is_push) === 0;
  is_pop * (1 - is_pop) === 0;
  
  // spgteone and spgtetwo to prevent underflow
  // check if sp is greaterthan or equal to one
  // it's cheaper to compute ≠ 0 than > 0 to avoid converting the number to binary
  signal spEqZero;
  signal spGteOne;
  spEqZero <== IsZero()(sp);
  spGteOne <== 1 - spEqZero;

  // check if sp is greaterthan or equal to two
  // it's cheaper to compute ≠ 0 and ≠ 1 than ≥ 2
  signal spEqOne;
  signal spGteTwo;
  spEqOne <== IsEqual()([sp, 1]);
  spGteTwo <== 1 - spEqOne * spEqZero;

  // the current column is 1 or more below the stack pointer
  // Since: top element index = sp - 1
  // Is column j ≤ the top element of the stack?
  signal oneBelowSp <== LessEqThan(bits)([j, sp - 1]);

  // the current column is 2 or more below the stack pointer
  // Since: sp - 2 is one below the top
  // Is column j at least two positions below the stack pointer?
  signal twoBelowSP <== LessEqThan(bits)([j, sp - 2]);

  // condition A
  // if the sp is 1 or greater, and our column is 1 index below sp, and the current instruction is PUSH or NOP, 
  // then all the values 0..sp - 1 inclusive must be copied.
  component a3A = AND3();
  a3A.in[0] <== spGteOne;
  a3A.in[1] <== oneBelowSp;
  a3A.in[2] <== is_push + is_nop;

  // condition B
  // if the sp is 2 or greater, and our column is 2 indexes below sp, and the current instruction is POP 
  // then all the values 0..sp - 2 inclusive must be copied.
  component a3B = AND3();
  a3B.in[0] <== spGteTwo;
  a3B.in[1] <== twoBelowSP;
  a3B.in[2] <== is_pop;

  // copy if condition A or condition B is met
  component or = OR();
  or.a <== a3A.out;
  or.b <== a3B.out;  
  out <== or.out;
}

// CopyStack uses ShouldCopy in a loop to determine which columns of the previous stack should be copied to the new one. 
// It returns an array of 0 or 1 to determine which columns should be copied.
template CopyStack(m) {
    var nBits = 4;
    signal output out[m];
    signal input sp;
    signal input is_pop;
    signal input is_push;
    signal input is_nop;

    component ShouldCopys[m];
    signal copy[m];

    // loop over the columns
    for (var j = 0; j < m; j++) {
        ShouldCopys[j] = ShouldCopy(j, nBits);
        ShouldCopys[j].sp <== sp;
        ShouldCopys[j].is_pop <== is_pop;
        ShouldCopys[j].is_push <== is_push;
        ShouldCopys[j].is_nop <== is_nop;
        out[j] <== ShouldCopys[j].out;
    }
}

// n is how many instructions we can handle since all the instructions might be push, our stack needs capacity of up to n
template StackBuilder(n) {
    var NOP = 0;
    var PUSH = 1;
    var POP = 2;

    signal input instr[2 * n];

    // we add one extra row for sp because our algorithm always writes to the
    // next row and we don't want to conditionally check for an array-out-of-bounds
    signal output sp[n + 1];

    signal output stack[n][n];

    var IS_NOP = 0;
    var IS_PUSH = 1;
    var IS_POP = 2;
    var ARG = 3;

    // metaTable is the columns IS_NOP, IS_PUSH, IS_POP, ARG
    signal metaTable[n][4];

    // first instruction must be PUSH or NOP
    (instr[0] - PUSH) * (instr[0] - NOP) === 0;

    signal first_op_is_push;
    first_op_is_push <== IsEqual()([instr[0], PUSH]);

    // if the first op is NOP, we are forcing the first value to be zero, but this is where the stack pointer is, so it doesn't matter
    stack[0][0] <== first_op_is_push * instr[1];

    // initialize the rest of the first stack to be zero
    for (var i = 1; i < n; i++) {
        stack[0][i] <== 0;
    }

    // we fill out the 0th elements to avoid uninitialzed signals. For a particular
    // execution, we only want one possible witness to correspond to a particular execution
    sp[0] <== 0;
    sp[1] <== first_op_is_push;
    metaTable[0][IS_PUSH] <== first_op_is_push;
    metaTable[0][IS_POP] <== 0;
    metaTable[0][IS_NOP] <== 1 - first_op_is_push;
    metaTable[0][ARG] <== instr[1];

    // spBranch is what we add to the previous stack pointer based on the opcode.
    // Could be 1, 0, or -1 depending on the opcode. Since the first opcode
    // cannot be POP, -1 is not an option here.
    var SAME = 0;
    var INC = 1;
    var DEC = 2;
    signal spBranch[n][3];
    spBranch[0][INC] <== first_op_is_push * 1;
    spBranch[0][SAME] <== (1 - first_op_is_push) * 0;
    spBranch[0][DEC] <== 0;

    // populate the first row of the metaTable and the stack pointer
    component EqPush[n];
    component EqNop[n];
    component EqPop[n];

    component eqSP[n][n];
    signal eqSPAndIsPush[n][n];
    for (var i = 0; i < n; i++) {
        eqSPAndIsPush[0][i] <== 0;
    }

    // signals and components for copying
    component CopyStack[n];
    signal previousCellIfShouldCopy[n][n];
    for (var i = 0; i < n; i++) {
        previousCellIfShouldCopy[0][i] <== 0;
    }
    for (var i = 1; i < n; i++) {
        // check which opcode we are executing
        EqPush[i] = IsEqual();
        EqPush[i].in[0] <== instr[2 * i];
        EqPush[i].in[1] <== PUSH;
        metaTable[i][IS_PUSH] <== EqPush[i].out;

        EqNop[i] = IsEqual();
        EqNop[i].in[0] <== instr[2 * i];
        EqNop[i].in[1] <== NOP;
        metaTable[i][IS_NOP] <== EqNop[i].out;

        EqPop[i] = IsEqual();
        EqPop[i].in[0] <== instr[2 * i];
        EqPop[i].in[1] <== POP;
        metaTable[i][IS_POP] <== EqPop[i].out;

        // get the instruction argument
        metaTable[i][ARG] <== instr[2 * i + 1];

        // if it is a push, write to the stack
        // if it is a copy, write to the stack
        CopyStack[i] = CopyStack(n);
        CopyStack[i].sp <== sp[i];
        CopyStack[i].is_push <== metaTable[i][IS_PUSH];
        CopyStack[i].is_nop <== metaTable[i][IS_NOP];
        CopyStack[i].is_pop <== metaTable[i][IS_POP];
        for (var j = 0; j < n; j++) {
        previousCellIfShouldCopy[i][j] <== CopyStack[i].out[j] * stack[i - 1][j];

        eqSP[i][j] = IsEqual();
        eqSP[i][j].in[0] <== j;
        eqSP[i][j].in[1] <== sp[i];
        eqSPAndIsPush[i][j] <== eqSP[i][j].out * metaTable[i][IS_PUSH];


        // we will either PUSH or COPY or implicilty assign 0
        stack[i][j] <== eqSPAndIsPush[i][j] * metaTable[i][ARG] + previousCellIfShouldCopy[i][j];
        }

        // write to the next row's stack pointer
        spBranch[i][INC] <== metaTable[i][IS_PUSH] * (sp[i] + 1);
        spBranch[i][SAME] <== metaTable[i][IS_NOP] * (sp[i]);
        spBranch[i][DEC] <== metaTable[i][IS_POP] * (sp[i] - 1);
        sp[i + 1] <== spBranch[i][INC] + spBranch[i][SAME] + spBranch[i][DEC];
    }                                 
}

component main = StackBuilder(3);

/* INPUT = {
  "instr": [1, 16, 1, 20, 1, 22]
} */