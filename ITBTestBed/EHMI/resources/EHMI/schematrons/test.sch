<schema xmlns="http://purl.oclc.org/dsdl/schematron"
    queryBinding="xslt2">

<ns prefix="sbdh" uri="http://www.unece.org/cefact/namespaces/StandardBusinessDocumentHeader"></ns>

  <pattern name="Check Sender">
    <rule context="sbdh:StandardBusinessDocumentHeader/sbdh:Sender/sbdh:Identifier">
      <assert test="matches(., '^0088:\d{13}$')" flag="fatal" id="Sender01">
        Sender Identifier did not parse as valid GLN number. It must start with “0088:” followed by exactly 13 digits.
      </assert>
    </rule>
  </pattern>

  <pattern name="Check Receiver">
    <rule context="sbdh:StandardBusinessDocumentHeader/sbdh:Receiver/sbdh:Identifier">
      <assert test="matches(., '^0088:\d{13}$')" flag="fatal" id="Receiver01">
        Receiver Identifier did not parse as valid GLN number. It must start with “0088:” followed by exactly 13 digits
      </assert>
    </rule>
  </pattern>

</schema>
