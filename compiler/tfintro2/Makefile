.PHONY: all ex script

all: script ex ex2

script:
	ocaml dsls.ml

ex: lang.cmi eval.cmo pp.cmo neg.cmo
	ocaml eval.cmo pp.cmo neg.cmo ex1.ml

ex2: lang.cmi  eval.cmo  pp.cmo  neg.cmo \
     lang2.cmi eval2.cmo pp2.cmo neg2.cmo
	ocaml $(filter-out %.cmi,$^) ex2.ml

include ../Makefile.common
