unit GenerateFunctionUnit;

interface

uses SysUtils;

Function Generate:string;

implementation

Function Generate:string;
var k,v:integer;
begin
  randomize;
  k:=random(19);
  v:=random(k);
  case k of
    0:result:='SIN(X)';
    1:result:='COS(X)';
    2:result:='TAN(X)';
    3:result:='ATAN(X)';
    4:result:='SINH(X)';
    5:result:='COSH(X)';
    6:result:='COTAN(X)';
    7:result:='EXP(X)';
    8:result:='SQR(X)';
    9:result:='SIGN(X)*LN(ABS(X))';
    10:result:='SIGN(X)*LOG(ABS(X))';
    11:result:='SIGN(X)*SQRT(ABS(X))';
    12:result:='( [ SIN(X)^2 ] + COS(X) ) * PI/2';
    13:result:='( [ COS(X)^2 ] + SIN(X) ) * PI/2';
    14:result:='(X^'+inttostr(v+1)+')';
    15:result:='( [ SIN(X)^2 ] + COS(1) ) * PI/2';
    16:result:='25993.894*EXP(-1.53389*(X-32))';
    17:result:='SIGN(X)*LN(ABS(X))';
    18:result:='SIGN(X)*LOG(ABS(X))';
    19:result:='SIGN(X)*SQRT(ABS(X))';
  else result:='';
  end;
end;

{SIGN: SIGN(X) returns -1 if X<0; +1 if X>0, 0 if X=0; it can be used as SQR(X)

      TRUNC: Discards the fractional part of a number. e.g. TRUNC(-3.2) is -3, TRUNC(3.2) is 3.

      CEIL: CEIL(-3.2) = 3, CEIL(3.2) = 4

      FLOOR: FLOOR(-3.2) = -4, FLOOR(3.2) = 3

      RND:  Random number generator.

            RND(X) generates a random INTEGER number such that 0 <= Result < int(X).
            Call TbcParser.Randomize to initialize the random number generator
            with a random seed value before using RND function in your expression.

      RANDOM: Random number generator.

            RANDOM(X) generates a random floating point number such that 0 <= Result < X.
            Call TbcParser.Randomize to initialize the random number generator
            with a random seed value before using RANDOM function in your expression.

      Predefined functions that take two parameters are:

      INTPOW: The INTPOW function raises Base to an integral power. INTPOW(2, 3) = 8.
              Note that result of INTPOW(2, 3.4) = 8 as well.

      POW: The Power function raises Base to any power. For fractional exponents
          or exponents greater than MaxInt, Base must be greater than 0.

      LOGN: The LogN function returns the log base N of X. Example: LOGN(10, 100) = 2

      MIN: MIN(2, 3) is 2.

      MAX: MAX(2, 3) is 3.

      Predefined functions that take more than 2 parameters are:

      IF: IF(BOOL, X, Y) returns X if BOOL is <> 0, returns Y if BOOL =0.
      Values of X and Y are calculated regardless of BOOL (Full Boolean Evaluation).
    }

end.
