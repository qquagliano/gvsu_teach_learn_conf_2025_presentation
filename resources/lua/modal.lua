return {
	["modal"] = function(raw_args)
		file_path = pandoc.utils.stringify(quarto.doc.input_file)

		if string.find(file_path, "in_person") then
			date = raw_args[1]
		else
			date = raw_args[2]
		end

		if quarto.doc.is_format("pdf") then
			block = pandoc.RawBlock("tex", date)
		end

		if quarto.doc.is_format("html") then
			block = pandoc.RawBlock("html", date)
		end

		return block
	end,
}
