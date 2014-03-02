use v6;
grammar JSON5::Tiny::Grammar;

token TOP       { ^ \s* [ <object> | <array> ] \s* $ }
rule object     { '{' ~ '}' <pairlist>     }
rule pairlist   { <pair> * %% \,           }
rule pair       { <key> ':' <value>        }
rule array      { '[' ~ ']' <arraylist>    }
rule arraylist  {  <value> * %% [ \, ]      }

proto token value {*};
token value:object  { <object> };
token value:array   { <array>  };
token value:string  { <string> }
token value:number:int {
    '-'? [ 0 | <[1..9]> <[0..9]>* ]
}
token value:number:num {
    '-'?
    [ 0 | <[1..9]> <[0..9]>* ]?
    \.
    <[0..9]>*
}
token value:number:exp {
    $<num>=[
      '-'?
      [ 0 | <[1..9]> <[0..9]>* ]?
      \.
      <[0..9]>*
    ]
    <[eE]>
    $<exp>=[ [\+|\-]? <[0..9]>+ ]
}
token value:sym<true>  { <sym> };
token value:sym<false> { <sym> };
token value:sym<null>  { <sym> };

token key { <string> | <js-ident> }

token js-ident { <:alpha+[_$]> <:alpha+[_$]+[0..9]>* }

proto token string {*}
token string:dbqt {
    \" ~ \"
    [
    | <str>                | $<str>=\'
    | \\ [ <str=.str_escape> | $<str>=\" ]
    ]*
}
token string:apos {
    \' ~ \'
    [
    | <str>                | $<str>=\"
    | \\ [ <str=.str_escape> | $<str>=\' ]
    ]*
}

token str {
    <-['"\\\t\n]>+
}

token str_escape {
    <['"\\/bfnrt\n]> | u <xdigit>**4
}

# vim: ft=perl6
