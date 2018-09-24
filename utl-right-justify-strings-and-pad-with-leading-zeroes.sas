
Right justify strings and pad with leading zeroes

see github
https://tinyurl.com/y7s68cvf
https://github.com/rogerjdeangelis/utl-left-justify-strings-and-pad-with-leading-zeroes

StackOverflow
https://tinyurl.com/yd498zrs
https://stackoverflow.com/questions/52445272/sas-how-can-i-pad-a-character-variable-with-zeroes-while-reading-in-from-csv

another good solution by data_null
https://stackoverflow.com/users/2196220/data-null

Nice use of the vlength function which returns the allocated length
for a character variable in the PDF. Charater variables have
a fixed length in the pdv.

INPUT
=====

 WORK.HAVE total obs=5

    COLA    COLB

      12    ABC
     445    DEFG
   34534    HI
     234    JKL
    6453    MNOPQR

   Variable    Type    Len

   COLA        Char    200
   COLB        Char    200


EXAMPLE OUTPUT
--------------

 WANT total obs=5

     COLA      COLB

     00012    000ABC
     00445    00DEFG
     34534    0000HI
     00234    000JKL
     06453    MNOPQR

  Variable    Type    Len

  COLA        Char      5
  COLB        Char      6

PROCESS
=======

 data want;

   * get the longest lengths for cola and colb;
   if _n_=0 then do;  %let rc=%sysfunc(dosubl('
      proc sql;
        select
           max(length(cola))
          ,max(length(colb))
        into
           :la trimmed
          ,:lb trimmed
        from
           have;
      ;quit;
    '));
   end;

   length a $&la b $&lb; * set the lengths;
   set have;

   a=strip(reverse(cola));          * double reverse '21   ;
   a=reverse(translate(a,'0',' ')); * 0s for blanks and reverse again;

   b=strip(reverse(colb));
   b=reverse(translate(b,'0',' '));

   drop cola colb;
   rename a=cola b=colb;

run;quit;

*                _              _       _
 _ __ ___   __ _| | _____    __| | __ _| |_ __ _
| '_ ` _ \ / _` | |/ / _ \  / _` |/ _` | __/ _` |
| | | | | | (_| |   <  __/ | (_| | (_| | || (_| |
|_| |_| |_|\__,_|_|\_\___|  \__,_|\__,_|\__\__,_|

;

data have;
 informat cola colb $200.;
 input ColA colB  ;
cards4;
12 ABC
445 DEFG
34534 HI
234 JKL
6453 MNOPQR
;;;;
run;quit;

