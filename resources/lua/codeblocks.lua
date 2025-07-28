function CodeBlock(el)
	el.attributes.long = el.attributes["lst-cap"]

	if el.classes:includes("spss") or el.classes:includes(".spss") then
		if quarto.doc.is_format("pdf") then
			pre = pandoc.RawInline("tex", "\\begin{codelisting}\n\\caption{" .. el.attributes.long .. "}")
			post = pandoc.RawInline("tex", "\\end{codelisting}")

			return {
				pre,
				el,
				post,
			}
		end

		if quarto.doc.is_format("revealjs") then
			return el
		end

		if quarto.doc.is_format("html") then
			return el
		end
	else
		return el
	end
end
