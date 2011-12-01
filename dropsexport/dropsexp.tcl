puts "loading drops-export-module"

global dropsexport_dlg.dropsexport_scaling;
set dropsexport_dlg.dropsexport_scaling 1.0;
#
#  refinement dialog
#
#
proc dropsexport_dlg { } {
    set w .dropsexport_dlg

    if {[winfo exists .dropsexport_dlg] == 1} {
	wm withdraw $w
	wm deiconify $w
	focus $w 
    } {
	toplevel $w


#	global dropsexport_scaling
#	set dropsexport_scaling 1
	tixControl $w.dropsexport_scaling -label "scaling: " -integer false \
	    -variable dropsexport_scaling -min 1e-12 -max 1e12 \
	    -options {
		entry.width 6
		label.width 25
		label.anchor e
	    }	\
        -command { global dropsexport_dlg.dropsexport_scaling ; set dropsexport_dlg.dropsexport_scaling };

	pack $w.dropsexport_scaling

        frame $w.bu
        pack $w.bu -fill x -ipady 3

	button $w.bu.updatefromgui -text "Apply GUI Settings"  \
	    -command { DE_gui_update ${dropsexport_dlg.dropsexport_scaling} }

	button $w.bu.cancle -text "Done" -command "destroy $w"
	pack $w.bu.updatefromgui $w.bu.cancle  -expand yes -side left

	wm withdraw $w
	wm geom $w +200+200
	wm deiconify $w
	wm title $w "Drops Export Options"
	focus $w
    }

}



if { [catch { load libdropsexp[info sharedlibextension] dropsexp } result] } {
    puts "cannot load dropsexp" 
    puts "error: $result"
} {

    .ngmenu add cascade -label "DROPS-Export" -menu .ngmenu.dropsexp -underline 0
 
    menu .ngmenu.dropsexp

    .ngmenu.dropsexp add command -label "Export Options..." \
        -command dropsexport_dlg

    .ngmenu.dropsexp add command -label "Export as DROPS-Mesh" \
    -command {
	set file [tk_getSaveFile  -filetypes "{ \"(Ext.) Gambit\" {*.msh}}" ]
	if {$file != ""} {
	    DE_ExportMesh $file $exportfiletype 
	}
    }



}
