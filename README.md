# Towards-Substructural-Property-Based-Testing
Code correlated to paper "Towards Substructural Property-Based Testing" by Mantovani and Momigliano.

We propose to extend property-based testing to substructural logics to 
overcome the current lack of reasoning tools in the field. 
We take the first step byimplementing a property-based testing (PBT) system 
for specifications written in Lolli.
We employ the foundational proof certificates (FPC) architecture to model various datageneration strategies. 
We validate our approach by encoding a model of a simpleimperative  programming  language  and  its  compilation  
and  by  testing  its  meta-theory via mutation analysis.

We  move  the  first  steps  in  this  programme  by  implementing  PBT  for Lolli; 
we evaluate its capability in catching bugs by applying it to a mid-size case study: 
we give a linear encoding of the static and dynamic semantic of an imperative 
programming languages and its compilation into a stack machine and validate several properties, 
among which type preservation and soundness of compilation. 
We have tried to test properties inthe way they would be stated and hopefully proved in a linear proof 
assistant based onthe two-level architecture. 
That is, we are not arguing (yet) that linear PBT is “better”
than the traditional one, based on state-passing specifications. 
Besides, in the case studies we  have  carried  out  so  far  we  generate  
mostly persistent data  (expressions,  programs).
Rather,  we  advocate  the  coupling  of  validation  and  (eventually)  verification  for  thoseencoding  where  linearity  
does  make  a  difference  in  terms  of  drastically  simplifying  therequired infrastructure. 

## Code
In folder "Implementazione" is possible to find Lolli interpreter.
In folder "Imp" is possibile to find IMP language interpreter. "Classic" folder contains intuitionistic code, while "linear" code contains linear code.  
In folder "Asm" is possibile to find ASM language interpreter. "Classic" folder contains intuitionistic code, while "linear" code contains linear code.  
The other folders contain other examples.
