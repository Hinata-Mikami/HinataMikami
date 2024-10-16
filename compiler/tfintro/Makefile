.PHONY: all ex script

all: script ex

script:
	ocaml dsls.ml

ex: lang.cmi eval.cmo pp.cmo neg.cmo
	ocaml eval.cmo pp.cmo neg.cmo ex1.ml

include ../Makefile.common
