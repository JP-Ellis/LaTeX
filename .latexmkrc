################################################################################
#
# Configuration file for .latexmkrc
# Copyright (C) 2014  Joshua Ellis
#
# This program is free software; you can redistribute it and/or modify it under
# the terms of the GNU General Public License as published by the Free Software
# Foundation; either version 2 of the License, or (at your option) any later
# version.
#
# This program is distributed in the hope that it will be useful, but WITHOUT ANY
# WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A
# PARTICULAR PURPOSE.  See the GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License along with
# this program; if not, write to the Free Software Foundation, Inc., 51 Franklin
# Street, Fifth Floor, Boston, MA 02110-1301 USA.
#
#
# Some of the code included was kindly provided by people online
# (including stackexchange).
#
################################################################################

# Make the default TeX compiler pdflatex, and change the default viewer.
$pdflatex = 'pdflatex';
$pdf_mode = 1;
$postscript_mode = $dvi_mode = 0;
$pdf_previewer = 'xdg-open %S';

# Ignore auxlock
push @generated_exts, 'auxlock';

# Provide support for Glossaries
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
$clean_ext .= ' %R.ist %R.xdy';

# Under some circumstances, more than 5 runs of latex are required to
# get all the cross-referencing correct.
#
# In particular, this can happen when you have all the following:
# - PGF/TikZ Externalization
# - mathtools set to number only referenced equation
# - glossaries, with equation references within certain entries
$max_repeat = 9;

# Provide support for the PGF/TikZ Externalization
our %externalflag = ();

$pdflatex = 'internal mypdflatex -shell-escape %O %S %B';

sub mypdflatex {
    our %externalflag;
    my $n = scalar(@_);
    my @args = @_[0 .. $n - 2];
    my $base = $_[$n - 1];

    system 'pdflatex', @args;
    if ($? != 0) {
        return $?
    }
    if ( !defined $externalflag->{$base} ) {
        $externalflag->{$base} = 1;
        if ( -e "$base.makefile" ) {
            system ("$make -j8 -f $base.makefile");
        }
    }
    return $?;
}
