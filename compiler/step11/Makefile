include ../Makefile.common

# testing clean_int.s (For Unix/Linux/WSL)
prog_int: init.c clean_int.s
	gcc -o $@ -W -Wall init.c clean_int.s && \
	./$@

# testing clean_int_mac.s (For Mac)
prog_int_mac: init.c clean_int_mac.s
	gcc -o $@ -W -Wall init.c clean_int_mac.s && \
	./$@

clean::
	rm -f prog_int prog_int_mac

# Compiler
.PHONY: test_compiler
test_compiler: asm.cmi compiler.cmo

# Order is important!
tigerc: config.cmo ../util/util.cmo \
	asm.cmi asm.cmo compiler.cmo \
	driver.cmo init.o
	$(OCAMLC) -o $@ $(filter-out init.o,$(filter-out %.cmi,$^))

init.o: init.c

.PHONY: test
test:   tigerc
	$(OCAML) $(INCLUDES) unix.cma ../util/expect.cmo test_script.ml

