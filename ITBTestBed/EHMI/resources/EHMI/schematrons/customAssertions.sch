<schema xmlns="http://purl.oclc.org/dsdl/schematron" queryBinding="xslt2">

<ns prefix="sbdhNS" uri="http://www.unece.org/cefact/namespaces/StandardBusinessDocumentHeader"></ns>

  <pattern name="Check Sender">
    <rule context="sbdhNS:StandardBusinessDocumentHeader/sbdhNS:Sender/sbdhNS:Identifier">
      <assert test="matches(., '^0088:\d{13}$')" flag="fatal" id="SenderAssertion-01">
        Sender Identifier did not parse as valid GLN number. It must start with “0088:” followed by exactly 13 digits.
      </assert>
    </rule>
  </pattern>

  <pattern name="Check Receiver">
    <rule context="sbdhNS:StandardBusinessDocumentHeader/sbdhNS:Receiver/sbdhNS:Identifier">
      <assert test="matches(., '^0088:\d{13}$')" flag="fatal" id="ReceiverAssertion-01">
        Receiver Identifier did not parse as valid GLN number. It must start with “0088:” followed by exactly 13 digits
      </assert>
    </rule>
  </pattern>

  <!-- Test that the binarycontent type of message conforms to the DocumentIdentification Standard -->

  <pattern name="Check conformance to the MessageHeader EventCoding element">
    <rule context="sbdhNS:StandardBusinessDocumentHeader/sbdhNS:DocumentIdentification/sbdhNS:Standard">
      <assert test="string() = '${expectedMessageType}'" flag="fatal" id="DocumentIdentificationAssertion-01">
        DocumentIdentification Standard must be equivelant to the messageheader eventCoding tag within the message itself (binarycontent)
      </assert>
    </rule>
  </pattern>

</schema>
