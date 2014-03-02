class JSON5::Tiny::Actions;

method TOP($/) {
    make $/.values.[0].ast;
};
method object($/) {
    make $<pairlist>.ast.hash.item;
}

method pairlist($/) {
    make $<pair>>>.ast.flat;
}

method pair($/) {
    make $<key>.ast => $<value>.ast;
}

method array($/) {
    make $<arraylist>.ast.item;
}

method arraylist($/) {
    make [$<value>>>.ast];
}

method key ($/) { make $<js-ident> ?? ~$/ !! $<string>.ast }

method string($/) {
    $<str>.map({.ast // .Str}).join;
}
method string:dbqt ($/) { make self.string($/) }
method string:apos ($/) { make self.string($/) }

method value:sym<number>($/) { make +$/.Str }
method value:sym<string>($/) { make $<string>.ast }
method value:sym<true>($/)   { make Bool::True  }
method value:sym<false>($/)  { make Bool::False }
method value:sym<null>($/)   { make Any }
method value:sym<object>($/) { make $<object>.ast }
method value:sym<array>($/)  { make $<array>.ast }

method str($/)               { make ~$/ }

my %h = '\\' => "\\",
        '/'  => "/",
        'b'  => "\b",
        'n'  => "\n",
        't'  => "\t",
        'f'  => "\f",
        'r'  => "\r",
        '"'  => "\"";
method str_escape($/) {
    if $<xdigit> {
        make chr(:16($<xdigit>.join));
    } else {
        make %h{~$/};
    }
}


# vim: ft=perl6
