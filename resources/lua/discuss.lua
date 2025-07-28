return {
	["discuss"] = function(raw_args)
		-- label = math.random(1, 10000)
		label = raw_args[1]
		text = raw_args[2]

		if quarto.doc.is_format("pdf") then
			block = pandoc.RawBlock(
				"tex",
				"\\begin{tcolorbox}[enhanced jigsaw, opacitybacktitle=0.6, coltitle=black, opacityback=0, colframe=mypurple, leftrule=.75mm, bottomtitle=1mm, left=2mm, rightrule=.15mm, arc=.35mm, breakable, toprule=.15mm, bottomrule=.15mm, titlerule=0mm, title=\\textcolor{mypurple}{\\faBullhorn}\\hspace{0.5em}{Discuss: "
					.. text
					.. "}, toptitle=1mm, colback=white, colbacktitle=mypurple!10!white]"
					.. "\\TextField[width=6.2in,height=1in,setFf={Multiline},unsetFf=Comb]{"
					.. label
					.. "}"
					.. "\\end{tcolorbox}\\vspace{3mm}"
			)
		end

		if quarto.doc.is_format("revealjs") then
			block = pandoc.RawBlock(
				"html",
				"<ul><li class='fragment highlight-current-custom'><b>Discuss: " .. text .. "</b></ul></li>"
			)
		end

		if quarto.doc.is_format("html") then
			block = pandoc.RawBlock(
				"html",
				"<ul><li class='fragment highlight-current-custom'><b>Discuss: " .. text .. "</b></ul></li>"
			)
		end

		return block
	end,
}
