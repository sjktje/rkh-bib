
all: references.pdf

clean:
	rm -f references.log references.aux references.aux2 references.toc references.out references.blg references.bbl references.brf references.bcf references.run.xml

distclean: clean
	rm -f references.pdf

%.pdf: references.tex $(wildcard *.tex) $(wildcard *.bib)
	pdflatex -file-line-error $< </dev/null ||:
	biber $(patsubst %.tex,%,$<)
	while ! diff -q $(basename $<).aux $(basename $<).aux2 > /dev/null; do \
		cp $(basename $<).aux $(basename $<).aux2 2> /dev/null || :> $(basename $<).aux2 ; \
		pdflatex -file-line-error $< </dev/null ||: ; \
	done
	rm -f *.log *.aux2
viewpdf: references.pdf
	osascript\
	    -e "set theFile to POSIX file \"references.pdf\" as alias" \
	    -e "set thePath to POSIX path of theFile" \
	    -e "tell application \"Skim\"" \
	    -e "	activate" \
	    -e "	set theDocs to get documents whose path is thePath" \
	    -e " 	try" \
	    -e " 		if (count of theDocs) > 0 then revert theDocs" \
	    -e " 	end try" \
	    -e " 	open theFile" \
	    -e "end tell"
