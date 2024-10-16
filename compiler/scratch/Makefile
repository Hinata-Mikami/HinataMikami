# Sample Makefile

.PHONY: sample mac

# For Unix/Linux/WSL
sample:
	gcc -o sample -W -Wall sample_main.c sample_clean.s

# For Mac (OS X)
mac:
	gcc -o sample -W -Wall sample_main.c sample_clean_mac.s

clean:
	rm -f sample *.o
