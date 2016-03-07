#Answers to lab questions.
##2.1.
###Pros:
<br> Behavioral design modules are easier to write, test and predict their behaviour. They are also more flexible and easier to parametrize. <br>
###Cons:
<br> Behavioral design modules synthesis is highly depending on compilator. Behavioral design can be synthesised into suboptimal schematics. Sometimes it's not possible or obscure to define behavioral design which will synthesise into optimal schematics.<br>
##2.2.
###Pros:
<br> Structural design modules provide schematics that are described, minimizing the influence of the compiler. It allows designers to use the advantages of library components of standard cells and use own implementation of various basic blocks to improve their efficiency.<br>
###Cons:
<br> Structural design modules are hard to write, test and predict their behaviour. They are less flexible compared to behavioral design. Structural design can be dependant on standard cell libraries.<br>
##2.3. 
Behavioral design is more suitable when synthesis and simulating with any particular compiler, when you can predict the resulting schematics (e.g., state machines, multiplexors with aid of samples provided by synthesis tool manufacturer). It's also preferred to use in testbenches, since the code of testbench will not be synthesised. Structural design is commonly used for optimisation purposes, when some behavioral code is synthesised suboptimaly or designer wants to provide specific schematics for some module. Yes, it's a common practice to use both styles in one project. 
##2.4. 
Verilog macro statements provide static compilation control, thus can only be accessed by console arguments or source code. Generate statements provide more agile control, cause it can dynamically affect compilation in compile time. Generate also allows to create more complex constructs with powerful addressing features, of which macros lack. However, macros can be used as a metaprogramming tool for Verilog, allowing the designer to introduce his own language constructs.
