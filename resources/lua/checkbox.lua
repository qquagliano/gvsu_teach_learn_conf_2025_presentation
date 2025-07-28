return {
	["checkbox"] = function(raw_args)
		if quarto.doc.is_format("pdf") then
			block = pandoc.RawBlock(
				"tex",
				"\\CheckBox{"
					.. math.random(1, 10000) -- Need unique label to process separately
					.. "}"
			)
		end

		if quarto.doc.is_format("revealjs") then
			block = pandoc.RawBlock("html", '<input type="checkbox" name="check" id="checkbox1" value="html">')
		end

		if quarto.doc.is_format("html") then
			block = pandoc.RawBlock("html", '<input type="checkbox" name="check" id="checkbox1" value="html">')
		end

		return block
	end,
}
