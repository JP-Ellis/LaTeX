# General Settings
################################################################################
# Set to use PDFLatex and change the viewer
# $pdflatex = 'pdflatex';
$pdf_mode = 1;
$postscript_mode = 0;
$dvi_mode = 0;
$pdf_previewer = 'xdg-open %S';

# Increase the max repeats (for makeglossaries)
$max_repeat = 9;

# Add other temporary files to the cleanup
push @generated_exts, 'auxlock', 'synctex.gz';
push @generated_exts, 'run.xml';
push @generated_exts, 'nav', 'snm';
push @generated_exts, 'vrb';

# Provide support for Glossaries
################################################################################
add_cus_dep('glo', 'gls', 0, 'run_makeglossaries');
add_cus_dep('acn', 'acr', 0, 'run_makeglossaries');

sub run_makeglossaries {
    if ( $silent ) {
        system "makeglossaries -q '$_[0]'";
    }
    else {
        system "makeglossaries '$_[0]'";
    };
}

push @generated_exts, 'glo', 'gls', 'glg';
push @generated_exts, 'acn', 'acr', 'alg';

# Asymptote support
################################################################################
add_cus_dep("asy", "eps", 0, "asy");
add_cus_dep("asy", "pdf", 0, "asy");
add_cus_dep("asy", "tex", 0, "asy");

sub asy {
    return system("asy '$_[0]'");
}

# Support for PGF/TikZ Externalization
################################################################################
# Add a few files to cleanup
push @generated_exts, 'figlist', 'ist', 'makefile', 'unq';
# On the initial run, %tikzexternalflag is set to an empty list (when
# it reads this .latexmkrc).
#
# %tikzexternalflag is then set after successfully running make.

our %tikzexternalflag = ();

$pdflatex = 'internal tikzpdflatex -shell-escape -synctex=1 %O %S %B';

sub tikzpdflatex {
    our %externalflag;
    my $n = scalar(@_);
    my @args = @_[0 .. $n - 2];
    my $base = $_[$n - 1];

    system 'lualatex', @args;
    # Exit with error on failure
    if ($? != 0) {
        return $?
    }
    if ( !defined $externalflag->{$base} ) {
        $externalflag->{$base} = 1;
        if ( -e "$base.makefile" ) {
            system ("$make -j\$(nproc) -f $base.makefile");
        }
    }
    return $?;
}
