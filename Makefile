MKSQLITE=2.6

default: libdownload

libdownload:
	-mkdir -p lib
	cd lib; git -C bnt pull || git clone https://github.com/bayesnet/bnt bnt
	wget -P lib -nc --no-check-certificate https://sourceforge.net/projects/mksqlite/files/mksqlite-$(MKSQLITE).zip
	cd lib; unzip mksqlite-$(MKSQLITE).zip -d mksqlite/
