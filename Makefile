MKSQLITE=2.6

default: libdownload

libdownload:
	-mkdir -p lib
	cd lib; git -C bnt pull || git clone https://github.com/bayesnet/bnt bnt
	cd lib; git -C mksqlite pull || git clone https://github.com/AndreasMartin72/mksqlite mksqlite
