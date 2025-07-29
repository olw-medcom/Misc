#!/usr/bin/env bash
# Convert MySchema.sch  →  MySchema.xslt (ISO Schematron → XSLT 2.0)

set -euo pipefail

##############################################################################
# Configuration (override with env‑vars if you like)
##############################################################################
SAXON_JAR=${SAXON_JAR:-/home/olw/development/Misc/ITBTestBed/schematronFiles/SaxonHE12-8J/saxon-he-12.8.jar}
SCHEMATRON_HOME=${SCHEMATRON_HOME:-/home/olw/development/Misc/ITBTestBed/schematronFiles}

INCLUDE_XSL=iso_dsdl_include.xsl
ABSTRACT_XSL=iso_abstract_expand.xsl
COMPILE_XSL=iso_svrl_for_xslt2.xsl

##############################################################################
# Argument checking
##############################################################################
if [[ $# -ne 1 ]]; then
    echo "Usage: $(basename "$0") <schema.sch>"
    exit 1
fi

IN="$1"
if [[ ! -f "$IN" ]]; then
    echo "File not found: $IN" >&2
    exit 1
fi

BASE="${IN%.*}"
OUT="${BASE}.xslt"

##############################################################################
# Dependency sanity‑check
##############################################################################
for f in "$INCLUDE_XSL" "$ABSTRACT_XSL" "$COMPILE_XSL"; do
    if [[ ! -f "$SCHEMATRON_HOME/$f" ]]; then
        echo "Missing $f in \$SCHEMATRON_HOME ($SCHEMATRON_HOME)" >&2
        exit 1
    fi
done
if [[ ! -f "$SAXON_JAR" ]]; then
    echo "Cannot find Saxon JAR at $SAXON_JAR" >&2
    exit 1
fi

##############################################################################
# Work area
##############################################################################
TMP1=$(mktemp)
TMP2=$(mktemp)
trap 'rm -f "$TMP1" "$TMP2"' EXIT

##############################################################################
# 1. Pull in <sch:include> / <xi:include>
##############################################################################
java -jar "$SAXON_JAR" -s:"$IN"   \
     -xsl:"$SCHEMATRON_HOME/$INCLUDE_XSL" \
     -o:"$TMP1"

##############################################################################
# 2. Expand abstract patterns <sch:pattern is-a="…"> → concrete rules
##############################################################################
java -jar "$SAXON_JAR" -s:"$TMP1" \
     -xsl:"$SCHEMATRON_HOME/$ABSTRACT_XSL" \
     -o:"$TMP2"

##############################################################################
# 3. Compile to executable XSLT 2.0 that outputs SVRL
##############################################################################
java -jar "$SAXON_JAR" -s:"$TMP2" \
     -xsl:"$SCHEMATRON_HOME/$COMPILE_XSL" \
     -o:"$OUT"

echo "✓  Generated $OUT"
