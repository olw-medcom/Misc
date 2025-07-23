<?xml version="1.0" encoding="UTF-8"?>
<schema xmlns="http://purl.oclc.org/dsdl/schematron"
        queryBinding="xslt2">

  <!-- namespace used by the XML -->
  <ns prefix="ses" uri="http://example.com/session"/>

  <pattern id="timing-rules">
    <!-- Apply both checks once, on the root <session> element -->
    <rule context="ses:session">

      <!-- 1️⃣ end must be after start -->
      <assert test="xs:dateTime(ses:end) gt xs:dateTime(ses:start)">
        The time must be **later** than.
      </assert>

      <!-- 2️⃣ difference must be ≤ 10 minutes -->
      <assert test="xs:dateTime(ses:end) - xs:dateTime(ses:start)
                    le xs:dayTimeDuration('PT10M')">
        The gap between and must not exceed **10 minutes**.
      </assert>

    </rule>
  </pattern>
</schema>
