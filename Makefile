
ROOT = /data/lenin2/Scripts/MyStuff/ciao46/ciao-4.6/contrib
DEV  = /data/da/Docs/scripts/dev
CP_FV = /bin/cp -fv



all:
	@mkdir -p $(ROOT)/bin $(ROOT)/config $(ROOT)/doc/xml
	@$(CP_FV) bin/* $(ROOT)/bin/
	@$(CP_FV) config/* $(ROOT)/config/
	@$(CP_FV) doc/xml/* $(ROOT)/doc/xml/

install: all

dev:
	@mkdir -p $(DEV)/bin $(DEV)/config $(DEV)/doc/xml
	@$(CP_FV) bin/* $(DEV)/bin/
	@$(CP_FV) config/* $(DEV)/config/
	@$(CP_FV) doc/xml/* $(DEV)/doc/xml/
