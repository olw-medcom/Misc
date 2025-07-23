<?xml version="1.0" encoding="UTF-8"?>
<schema xmlns="http://purl.oclc.org/dsdl/schematron" queryBinding="xslt2">
  
  <ns prefix="sbdhNS" uri="http://www.unece.org/cefact/namespaces/StandardBusinessDocumentHeader"></ns>
  <ns prefix="fn" uri="http://www.w3.org/2005/xpath-functions"/>
  
  <pattern name="Check Sender is a valid GLN number">
    <rule context="sbdhNS:StandardBusinessDocumentHeader/sbdhNS:Sender/sbdhNS:Identifier">
      <assert test="matches(., '^0088:\d{13}$')" flag="fatal" id="SenderAssertion-01">
        Sender Identifier did not parse as valid GLN number. It must start with “0088:” followed by exactly 13 digits without any hidden characters or padding.
      </assert>
    </rule>
  </pattern>
  
  <pattern name="Check Receiver is a valid GLN number">
    <rule context="sbdhNS:StandardBusinessDocumentHeader/sbdhNS:Receiver/sbdhNS:Identifier">
      <assert test="matches(., '^0088:\d{13}$')" flag="fatal" id="ReceiverAssertion-01">
        Receiver Identifier did not parse as valid GLN number. It must start with “0088:” followed by exactly 13 digits without any hidden characters or padding.
      </assert>
    </rule>
  </pattern>
  
  <pattern name="Check DocumentIdentification Standard conformance to the MessageHeader EventCoding element">
    <rule context="sbdhNS:StandardBusinessDocumentHeader/sbdhNS:DocumentIdentification/sbdhNS:Standard">
      <assert test="string() = '${expectedDocumentIdentifierStandard}'" flag="fatal" id="DocumentIdentificationAssertion-01">
        DocumentIdentification Standard is not ${expectedDocumentIdentifierStandard}. 
        It must be equivelant to the messageheader eventCoding tag within the message itself (binarycontent) without any hidden characters or padding.
      </assert>
    </rule>
  </pattern>
  
  <!-- EHMI SBDH IG TODO: The FhirPath is wrong -->
  <pattern name="Check DocumentIdentification TypeVersion conformance to the MessageHeader Definition element">
    <rule context="sbdhNS:StandardBusinessDocumentHeader/sbdhNS:DocumentIdentification/sbdhNS:TypeVersion">
      <assert test="string() = '${expectedMessageDefinitionVersion}'" flag="fatal" id="DocumentIdentificationAssertion-02">
        DocumentIdentification TypeVersion is not ${expectedMessageDefinitionVersion}.
        It must be equivelant to the messageheader definition tag within the message itself (binarycontent) without any hidden characters or padding.
      </assert>
    </rule>
  </pattern>
  
  <pattern name="Check DocumentIdentification InstanceIdentifier is an UUID">
    <rule context="sbdhNS:StandardBusinessDocumentHeader/sbdhNS:DocumentIdentification/sbdhNS:InstanceIdentifier">
      <assert test="matches(., '^[0-9a-f]{8}-[0-9a-f]{4}-[0-5][0-9a-f]{3}-[089ab][0-9a-f]{3}-[0-9a-f]{12}$')" flag="fatal" id="DocumentIdentificationAssertion-03">
        DocumentIdentification InstanceIdentifier is not a UUID. Make sure it doesn't contain any hidden characters or padding.
      </assert>
    </rule>
  </pattern>
  
  <!-- In the production pilot we only support FHIR messages, so this needs to be expanded once it is to be used for real -->
  <pattern name="Check DocumentIdentification Type is Bundle">
    <rule context="sbdhNS:StandardBusinessDocumentHeader/sbdhNS:DocumentIdentification/sbdhNS:Type">
      <assert test="string() = 'Bundle'" flag="fatal" id="DocumentIdentificationAssertion-04">
        DocumentIdentification Type is not 'Bundle'. Make sure it doesn't contain any hidden characters or padding.
      </assert>
    </rule>
  </pattern>
  
  <!-- TODO: Assert that the businessscopes actually are there -->
  
  <!-- NOTE: I have not followed Ole's recommendation here, as I think it should point to the actual structuredefinition -->
  <pattern name="Check BusinessScope DocumentID InstanceIdentifier conforms to the values found in BinaryContent">
    <rule context="sbdhNS:StandardBusinessDocumentHeader/sbdhNS:BusinessScope/sbdhNS:Scope[sbdhNS:Type = 'DOCUMENTID']/sbdhNS:InstanceIdentifier">
      <assert test="string() = 'urn:dk:medcom:prod:messaging:fhir:structuredefinition:${expectedStructureDefinition}#urn:dk:medcom:fhir:${expectedStructureDefinition}:${expectedMessageDefinitionVersion}'" flag="fatal" id="BusinessScopeDocumentIDAssertion-01">
        BusinessScope DocumentID InstanceIdentifier is not urn:dk:medcom:prod:messaging:fhir:structuredefinition:${expectedStructureDefinition}#urn:dk:medcom:fhir:${expectedStructureDefinition}:${expectedMessageDefinitionVersion}.
        Make sure it doesn't contain any hidden characters or padding.
      </assert>
    </rule>
  </pattern>
  
  <pattern name="Check BusinessScope ProcessID InstanceIdentifier is sdn-emergence">
    <rule context="sbdhNS:StandardBusinessDocumentHeader/sbdhNS:BusinessScope/sbdhNS:Scope[sbdhNS:Type = 'PROCESSID']/sbdhNS:InstanceIdentifier">
      <assert test="string() = 'sdn-emergence'" flag="fatal" id="BusinessScopeProcessIDAssertion-01">
        BusinessScope ProcessID InstanceIdentifier is not 'sdn-emergence'. Make sure it doesn't contain any hidden characters or padding.
      </assert>
    </rule>
  </pattern>
  
  <pattern name="Check BusinessScope PatientID InstanceIdentifier is the CPR from the BinaryContent">
    <rule context="sbdhNS:StandardBusinessDocumentHeader/sbdhNS:BusinessScope/sbdhNS:Scope[sbdhNS:Type = 'PATIENTID']/sbdhNS:InstanceIdentifier">
      <assert test="string() = '${expectedPatientCPR}'" flag="fatal" id="BusinessScopePatientIDAssertion-01">
        BusinessScope PatientID InstanceIdentifier is not ${expectedPatientCPR}
        It must be equivelant to the patient identifier tag within the message itself (BinaryContent) without any hidden characters or padding.
      </assert>
    </rule>
  </pattern>
  
  <pattern name="Check BusinessScope SenderID InstanceIdentifier is the SOR identifier from the BinaryContent">
    <rule context="sbdhNS:StandardBusinessDocumentHeader/sbdhNS:BusinessScope/sbdhNS:Scope[sbdhNS:Type = 'SENDERID']/sbdhNS:InstanceIdentifier">
      <assert test="string() = '${expectedSenderId}'" flag="fatal" id="BusinessScopeSenderIDAssertion-01">
        BusinessScope SenderID InstanceIdentifier is not ${expectedSenderId}
        It must be equivelant to the sender SOR identifier tag within the message itself (BinaryContent) without any hidden characters or padding.
      </assert>
    </rule>
  </pattern>
  
  <pattern name="Check BusinessScope ReceiverID InstanceIdentifier is the SOR identifier from the BinaryContent">
    <rule context="sbdhNS:StandardBusinessDocumentHeader/sbdhNS:BusinessScope/sbdhNS:Scope[sbdhNS:Type = 'RECEIVERID']/sbdhNS:InstanceIdentifier">
      <assert test="string() = '${expectedReceiverId}'" flag="fatal" id="BusinessScopeReceiverIDAssertion-01">
        BusinessScope ReceiverID InstanceIdentifier is not ${expectedReceiverId}
        It must be equivelant to the receiver SOR identifier tag within the message itself (BinaryContent) without any hidden characters or padding.
      </assert>
    </rule>
  </pattern>
  
  <pattern name="Check BusinessScope MessageIdentifier is the id from the BinaryContent">
    <rule context="sbdhNS:StandardBusinessDocumentHeader/sbdhNS:BusinessScope/sbdhNS:Scope[sbdhNS:Type = 'MESSAGEIDENTIFIER']/sbdhNS:InstanceIdentifier">
      <assert test="string() = '${expectedMessageIdentifier}'" flag="fatal" id="BusinessScopeMessageIdentifierAssertion-01">
        BusinessScope MessageIdentifier is not ${expectedMessageIdentifier}
        It must be equivelant to the messageheader id tag within the message itself (BinaryContent) without any hidden characters or padding.
      </assert>
    </rule>
  </pattern>
  
  <!-- TODO: The Example has hidden characters (it goes to a new line between the <InstanceIdentifier> tag) -->
  <pattern name="Check BusinessScope MessageEnvelopeIdentifier is the id from the BinaryContent">
    <rule context="sbdhNS:StandardBusinessDocumentHeader/sbdhNS:BusinessScope/sbdhNS:Scope[sbdhNS:Type = 'MESSAGEENVELOPEIDENTIFIER']/sbdhNS:InstanceIdentifier">
      <assert test="string() = '${expectedMessageEnvelopeIdentifier}'" flag="fatal" id="BusinessScopeMessageEnvelopeIdentifierAssertion-01">
        BusinessScope MessageEnvelopeIdentifier is not ${expectedMessageEnvelopeIdentifier}.
        It must be equivelant to id tag within the message itself (BinaryContent) without any hidden characters or padding.
      </assert>
    </rule>
  </pattern>
  
  <!-- TODO: When the DocumentIdentification Standard type is ebbp-signals we need to assert a lot more scopes, I think we need an entirely new schematron and test for that specifically -->
  
  <!-- TODO: When there is a designated postfix-value for a message standard. We need to test that it is in there. But how do I know when the standard has a postfix-value -->
  <pattern name="Check BusinessScope StatisticalInformation is a valid MedCom monitoring id">
    <rule context="sbdhNS:StandardBusinessDocumentHeader/sbdhNS:BusinessScope/sbdhNS:Scope[sbdhNS:Type = 'StatisticalInformation']/sbdhNS:InstanceIdentifier">
      <assert test="string() = 'MCM:${expectedDocumentIdentifierStandard}'" flag="fatal" id="BusinessScopeStatisticalInformationAssertion-01">
        BusinessScope StatisticalInformation is not a valid MedCom monitoring id. It should be MCM:${expectedDocumentIdentifierStandard}.
      </assert>
    </rule>
  </pattern>
  
  <!-- TODO: I think there needs to be another test here if it's intended for XDS-metadata? -->
  
  <!-- TODO: We need a new test when it's a response, but I think that needs to be another test in another schematron -->
  <pattern name="Check BusinessScope Reliable Messaging Receipt Ack is setup correctly">
    <rule context="sbdhNS:StandardBusinessDocumentHeader/sbdhNS:BusinessScope/sbdhNS:Scope[sbdhNS:Type = 'EHMI-ReceiptAcknowledgement']">
      <assert test="sbdhNS:InstanceIdentifier/string() = 'Request'" flag="fatal" id="BusinessScopeReceiptRequestAssertion-01">
        BusinessScope Reliable Messaging Receipt Ack InstanceIdentifier is not 'Request' without any hidden characters or padding.
      </assert>

      <assert test="xs:dateTime(sbdhNS:CorrelationInformation/sbdhNS:ExpectedResponseDateTime) gt xs:dateTime(sbdhNS:CorrelationInformation/sbdhNS:RequestingDocumentCreationDateTime)">
        The time must be **later** than.
      </assert>
      <!-- TODO: I should look into ignoring whitespace and padding etc. -->
    </rule>
    <!-- TODO: Is CorrelationInformation required? If so we should change the xsd -->
    
    
    <!-- TODO: When we make the schematron for a response we need to assert that the expectedResponseDateTime is not present -->
  </pattern>
</schema>
