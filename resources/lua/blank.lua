return {
	["blank"] = function(raw_args)
		text = raw_args[1]

		if quarto.doc.is_format("pdf") then
			block = pandoc.RawBlock("tex", "\\underline{\\TextField[width=4cm]{" .. text .. "}}")
		end

		if quarto.doc.is_format("revealjs") then
			block =
				pandoc.RawBlock("html", '<span class="fragment highlight-current-custom"><u>' .. text .. "</u></span>")
		end

		if quarto.doc.is_format("html") then
			block =
				pandoc.RawBlock("html", '<span class="fragment highlight-current-custom"><u>' .. text .. "</u></span>")
		end

		return block
	end,
}
