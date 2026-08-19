# Report PDF only uses Latin-1 punctuation (·, ±, –), which Prawn's built-in
# AFM fonts render fine via WinAnsi encoding — this just quiets the blanket
# "non-ASCII with built-in fonts" warning that fires regardless.
Prawn::Fonts::AFM.hide_m17n_warning = true
