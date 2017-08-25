#!/bin/tclsh

# Template autogeneration for Plumed 2.  This file will generate (on
# stdout) "templates_list_v2_autogen.tcl" file.  The "unsubst" string
# contains a proc which returns a list, which defines the CURATED
# Templates menu to be used for Plumed 2. Right-hand sides can be
# specified manually (here), or contain %%XXXX placeholders that are
# expanded with the corresponding "plumed gentemplate" command.



# Curated menu template
set unsubst {
package provide plumed 2.7
# AUTOGENERATED! 
namespace eval ::Plumed {
    variable templates_list_v2 {
	"Group definition"		"grp:   GROUP ATOMS=[chain A and name CA]"
	"Center of mass"		"com:   COM   ATOMS=[chain A and name CA]"
	"Ghost atom"			"%%GHOST"
	- -
	"Distance"			"%%DISTANCE"
	"Angle"				"%%ANGLE"
	"Torsion"			"%%TORSION"
        "Radius of gyration"		"%%GYRATION"
	"Electric dipole"		"%%DIPOLE"
	"Coordination"			"%%COORDINATION"
	- -
	"RMSD from reference structure" "RMSD REFERENCE=ref.pdb TYPE=OPTIMAL"
	"S- and Z-path variables"	"%%PATHMSD"
	"Amount of \u03b1-helical structure"        
	                                "%%ALPHARMSD"
        "Amount of parallel-\u03b2 structure"       
	                                "%%PARABETARMSD"
	"Amount of antiparallel-\u03b2 structure"   
	                                "%%ANTIBETARMSD"
	"Distance RMSD"                 "%%DRMSD"
	- -
	"Polynomial function of CVs"	"%%COMBINE"
	"Piecewise function of CVs"	"%%PIECEWISE"
	"Arbitrary function of CVs"	"MATHEVAL ARG=cv1.x,cv2.y VAR=x,y FUNC=sin(x)+y   # If compiled-in"
	"Distance in CV space"		"%%TARGET"
	"Contact map"			"CONTACTMAP ATOMS1=1,2 ATOMS2=3,4 ... SWITCH=(RATIONAL R_0=1.5)"
	"Distance list"			"DISTANCES ATOMS1=3,5 ATOMS2=1,2 MIN={BETA=0.1}"
	"Coordination number list"	"%%COORDINATIONNUMBER"
	- -
	"Restraint"			"RESTRAINT ARG=mycv AT=0 SLOPE=-1"
        "Moving restraint"		"%%MOVINGRESTRAINT"
	"Metadynamics"			"%%METAD"
	"Adiabatic bias"		"%%ABMD"
	"Lower wall (allow higher)"	"%%LOWER_WALLS"
	"Upper wall (allow lower)"	"%%UPPER_WALLS"
	- -
	"Set system topology"           "%%MOLINFO"
	"Switch to VMD units"           "UNITS  LENGTH=A  ENERGY=kcal/mol  TIME=ps"
    }
}

# These are in the menu, but with a manual template
#       %%COM 
#       %%GROUP
#       %%RMSD
#	%%CONTACTMAP 
#       %%DISTANCES 
#       %%UNITS

      
}




proc get_template {kw} {
    set t [exec plumed gentemplate --action $kw ]
    set t [string trim $t]
    set t [string map { " selection>" _selection> } $t]
    return $t
}

proc get_template_full {kw} {
    set t [exec plumed gentemplate --action $kw --include-optional ]
    set t [string trim $t]
    set t [string map { " selection>" _selection> } $t]
    return $t
}




# Get list of keywords (stderr)
set keyword_list [exec plumed gentemplate --list 2>@1 ]


# Replace all the %%'s
while {[regexp {%%([A-Z_]+)} $unsubst pkw kw]} {
    set templ [get_template $kw]
#    puts stderr [format "%20s --> %s" $kw $templ]
    set unsubst [regsub $pkw $unsubst $templ]
    # Remember the set of replacements in the menu
    lappend menu_kw_list $kw
}


# ----------------------------------------
# Start output

puts "# AUTOGENERATED! DO NOT EDIT! on [exec date] via Plumed [exec plumed info --long-version], git version [exec plumed info --git-version]"

# Print menu
puts "$unsubst"


# ----------------------------------------
# Part 2: popup to insert "short" template

# Generate keyword-help hashes for ALL keywords. 
puts "array set ::Plumed::template_keyword_hash {"
foreach kw $keyword_list {
    set templ [get_template $kw]
    puts "  {$kw} {$templ}"
}
puts "}"


# ----------------------------------------
# Part 3: popup to insert full template keywords

puts "array set ::Plumed::template_full_hash {"
foreach kw $keyword_list {
    set templ [get_template_full $kw]
    puts "  {$kw} {$templ}"
}
puts "}"


# ----------------------------------------
# Part 4: Remind of unused KWs (possibly new)

puts  "\n\n"
puts "# NOTE: The following keywords were known, but left out of the menu"
foreach kw $keyword_list {
    if {[lsearch $menu_kw_list $kw]==-1} {
	puts   "#  $kw"
    }
}
puts  "\n\n"


