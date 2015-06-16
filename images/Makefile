GNUPLOT=gnuplot
INKSCAPE=inkscape
DIA=dia

all: $(patsubst %.plot,%.eps,$(wildcard *.plot)) $(patsubst %.svg,%.eps,$(wildcard *.svg)) $(patsubst %.dia,%.eps,$(wildcard *.dia))

# GNUPLOT rule
%.eps : %.plot 
	$(GNUPLOT) $<

# INKSCAPE rule
%.eps : %.svg
	$(INKSCAPE) --without-gui --export-eps=$@ $<

# DIA rule
%.eps : %.dia
	$(DIA) --export=$@ $<

clean:
	rm -f *.eps *.bib.bak *~
