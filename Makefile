TARGETS=spherometer-scale.pdf spherometer-knob.stl \
      case-cut-test-swatch.dxf \
      case-cut-thick-acrylic.dxf case-cut-thin-acrylic.dxf

all: $(TARGETS)

%.stl: src/%.scad
	openscad -o $@ $^

src/case-cut-%.ps : src/case-cut.ps
	(cat $< ; echo "$* showpage") > $@

%.pdf: src/%.ps
	ps2pdf $^ $@

%.dxf: src/%.ps
	pstoedit -psarg "-r600x600" -nb -mergetext -dt -f "dxf_s:-mm -ctl" $< $@

clean:
	rm -f $(TARGETS)
