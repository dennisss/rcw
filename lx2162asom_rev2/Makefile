# The RCW sources of this module are not committed: ../GenerateSRConfigs.sh
# generates them from the ../*.tmpl templates into
# ../build/<this module>/<board>/rcw_*.rcw (run by the top-level Makefile).
# They are compiled from there; their #include paths are relative to this
# directory, which rcw.py always adds to the include path.
RCW_SRC_PREFIX := ../build/$(notdir $(CURDIR))/
rcw_sources := $(wildcard $(RCW_SRC_PREFIX)*/*.rcw)

include ../Makefile.inc
