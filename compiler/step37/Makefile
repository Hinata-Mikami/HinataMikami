vpath parser.ml #empty: generate the parser rather than look it up
vpath %.ml ../step36 ../step35 ../step34 ../step33 ../step32 ../step31 \
	../step24 ../step22 ../step21 ../step20
vpath %.mli ../step36 ../step35 ../step34 ../step33 ../step32 ../step31 \
	../step24 ../step22 ../step21 ../step20
vpath %.mll ../step36 ../step35 ../step34 ../step33
vpath %.c ../step36 ../step35 ../step22 ../step21

tigerc: ../util/util.cmo ../util/common.cmo config.cmo \
	lang_31.cmi lang_32.cmi lang_33.cmi lang_34.cmi lang_35.cmi\
	lang_36.cmi lang.cmi \
	pp_ast_20.cmo pp_ast_21.cmo pp_ast_22.cmo pp_ast_31.cmo \
	pp_ast_32.cmo pp_ast_33.cmo pp_ast_34.cmo \
	pp_ast_35.cmo pp_ast_36.cmo pp_ast.cmo \
	parser.cmo lexer.cmo \
	asm_20.cmi asm_impl_20.cmo asm_21.cmi asm_impl_21.cmo \
	asm_24.cmi asm_impl_24.cmo asm_31.cmi asm_impl_31.cmo \
	asm_32.cmi asm_impl_32.cmo \
	asm_35.cmi asm_impl_35.cmo \
	asm.cmi asm.cmo \
	code_gen_24.cmo code_gen_31.cmo code_gen_32.cmo code_gen_34.cmo \
	code_gen_35.cmo code_gen_36.cmo code_gen.cmo \
	allocator.cmi allocator.cmo \
	temporaries_31.cmo temporaries_32.cmo temporaries_34.cmo \
	temporaries_35.cmo temporaries_36.cmo temporaries.cmo \
	types.cmo env_31.cmi env.cmi env.cmo \
	ctype.cmo \
	compiler_31.cmo compiler_32.cmo compiler_33.cmo \
	compiler_34.cmo compiler_35.cmo compiler_36.cmo \
	compiler.cmo \
	driver.cmo init.o
	$(OCAMLC) -o $@ $(filter-out init.o,$(filter-out %.cmi,$^))

init.o: init.c

include ../Makefile.common

.PHONY: test test20 test21 test24 test31 test32 test33
.PHONY: test34 test35 test36 test371 test372
test:    test34 test35 test36 test371 test372
test34: tigerc
	$(OCAML) $(INCLUDES) unix.cma ../util/expect.cmo \
	../step34/test_script.ml
test35: tigerc
	$(OCAML) $(INCLUDES) unix.cma ../util/expect.cmo \
	../step35/test_script.ml
test36: tigerc
	$(OCAML) $(INCLUDES) unix.cma ../util/expect.cmo \
	../step36/test_script.ml
test371: tigerc
	$(OCAML) $(INCLUDES) unix.cma ../util/expect.cmo \
	test_script_1.ml
test372: tigerc
	$(OCAML) $(INCLUDES) unix.cma ../util/expect.cmo \
	test_script_2.ml

clean::
	rm -f parser.ml parser.output

.depend:: 
	$(OCAMLDEP) $(INCLUDES) *.mly *.mll >> .depend
