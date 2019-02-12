TARGETS=spherometer-scale.pdf spherometer-knob.stl \
      case-cut-test-swatch.dxf \
      case-cut-thick-acrylic.dxf case-cut-thin-acrylic.ps

all: $(TARGETS)

%.stl: %.scad
	openscad -o $@ $^

case-cut-%.ps : case-cut.ps
	(cat $< ; echo "$* showpage") > $@

%.pdf: %.ps
	ps2pdf $^ $@

%.dxf: %.ps
	pstoedit -psarg "-r600x600" -nb -mergetext -dt -f "dxf_s:-mm -ctl" $< $@

clean:
	rm -f $(TARGETS)
