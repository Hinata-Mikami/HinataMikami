.PHONY: all ex script

all: script ex

script:
	ocaml dsls.ml

ex: lang.cmi lang2.cmi eval.cmo eval2.cmo pp.cmo pp2.cmo neg.cmo neg2.cmo
	ocaml eval.cmo eval2.cmo pp.cmo pp2.cmo neg.cmo neg2.cmo ex2.ml

include ../Makefile.common
