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
  
  
  <!-- TODO AFTER TALKING WITH OLE:
  1. Point to the Bundle/MessageHeader/eventCoding/code.value instead of the profile meta data
  2. Update the SBDH IG to include the correct code (homecareobservation-message) from the terminology code system
  3. Optional update the EHMI terminology event code system. Write that our convention/best-practice
      is to take the structuredefinition name and remove the medcom- prefix
   -->
  <pattern name="Check BusinessScope DocumentID InstanceIdentifier conforms to the values found in BinaryContent">
    <rule context="sbdhNS:StandardBusinessDocumentHeader/sbdhNS:BusinessScope">
      <assert test="sbdhNS:Scope[sbdhNS:Type = 'DOCUMENTID']" flag="fatal" id="BusinessScopeDocumentIDAssertion-01">
        BusinessScope DocumentID is not found in the BusinessScope enumeration.
      </assert>
    </rule>

    <rule context="sbdhNS:StandardBusinessDocumentHeader/sbdhNS:BusinessScope/sbdhNS:Scope[sbdhNS:Type = 'DOCUMENTID']/sbdhNS:InstanceIdentifier">
      <assert test="string() = 'urn:dk:medcom:prod:messaging:fhir:structuredefinition:${expectedStructureDefinition}#urn:dk:medcom:fhir:${expectedStructureDefinition}:${expectedMessageDefinitionVersion}'" flag="fatal" id="BusinessScopeDocumentIDAssertion-01">
        BusinessScope DocumentID InstanceIdentifier is not urn:dk:medcom:prod:messaging:fhir:structuredefinition:${expectedStructureDefinition}#urn:dk:medcom:fhir:${expectedStructureDefinition}:${expectedMessageDefinitionVersion}.
        Make sure it doesn't contain any hidden characters or padding.
      </assert>
    </rule>
  </pattern>
  
  <pattern name="Check BusinessScope ProcessID InstanceIdentifier is sdn-emergence">
    <rule context="sbdhNS:StandardBusinessDocumentHeader/sbdhNS:BusinessScope">
      <assert test="sbdhNS:Scope[sbdhNS:Type = 'PROCESSID']" flag="fatal" id="BusinessScopeProcessIDAssertion-01">
        BusinessScope ProcessID is not found in the BusinessScope enumeration.
      </assert>
    </rule>

    <rule context="sbdhNS:StandardBusinessDocumentHeader/sbdhNS:BusinessScope/sbdhNS:Scope[sbdhNS:Type = 'PROCESSID']/sbdhNS:InstanceIdentifier">
      <assert test="string() = 'sdn-emergence'" flag="fatal" id="BusinessScopeProcessIDAssertion-01">
        BusinessScope ProcessID InstanceIdentifier is not 'sdn-emergence'. Make sure it doesn't contain any hidden characters or padding.
      </assert>
    </rule>
  </pattern>
  
  <pattern name="Check BusinessScope PatientID InstanceIdentifier is the CPR from the BinaryContent">
    <rule context="sbdhNS:StandardBusinessDocumentHeader/sbdhNS:BusinessScope">
      <assert test="sbdhNS:Scope[sbdhNS:Type = 'PATIENTID']" flag="fatal" id="BusinessScopePatientIDAssertion-01">
        BusinessScope PatientID is not found in the BusinessScope enumeration.
      </assert>
    </rule>
    <rule context="sbdhNS:StandardBusinessDocumentHeader/sbdhNS:BusinessScope/sbdhNS:Scope[sbdhNS:Type = 'PATIENTID']/sbdhNS:InstanceIdentifier">
      <assert test="string() = '${expectedPatientCPR}'" flag="fatal" id="BusinessScopePatientIDAssertion-01">
        BusinessScope PatientID InstanceIdentifier is not ${expectedPatientCPR}
        It must be equivelant to the patient identifier tag within the message itself (BinaryContent) without any hidden characters or padding.
      </assert>
    </rule>
  </pattern>
  
  <pattern name="Check BusinessScope SenderID InstanceIdentifier is the SOR identifier from the BinaryContent">
    <rule context="sbdhNS:StandardBusinessDocumentHeader/sbdhNS:BusinessScope">
      <assert test="sbdhNS:Scope[sbdhNS:Type = 'SENDERID']" flag="fatal" id="BusinessScopeSenderIDAssertion-01">
        BusinessScope SenderID is not found in the BusinessScope enumeration.
      </assert>
    </rule>
    <rule context="sbdhNS:StandardBusinessDocumentHeader/sbdhNS:BusinessScope/sbdhNS:Scope[sbdhNS:Type = 'SENDERID']/sbdhNS:InstanceIdentifier">
      <assert test="string() = '${expectedSenderId}'" flag="fatal" id="BusinessScopeSenderIDAssertion-01">
        BusinessScope SenderID InstanceIdentifier is not ${expectedSenderId}
        It must be equivelant to the sender SOR identifier tag within the message itself (BinaryContent) without any hidden characters or padding.
      </assert>
    </rule>
  </pattern>
  
  <pattern name="Check BusinessScope ReceiverID InstanceIdentifier is the SOR identifier from the BinaryContent">
    <rule context="sbdhNS:StandardBusinessDocumentHeader/sbdhNS:BusinessScope">
      <assert test="sbdhNS:Scope[sbdhNS:Type = 'RECEIVERID']" flag="fatal" id="BusinessScopeReceiverIDAssertion-01">
        BusinessScope ReceiverID is not found in the BusinessScope enumeration.
      </assert>
    </rule>
    <rule context="sbdhNS:StandardBusinessDocumentHeader/sbdhNS:BusinessScope/sbdhNS:Scope[sbdhNS:Type = 'RECEIVERID']/sbdhNS:InstanceIdentifier">
      <assert test="string() = '${expectedReceiverId}'" flag="fatal" id="BusinessScopeReceiverIDAssertion-02">
        BusinessScope ReceiverID InstanceIdentifier is not ${expectedReceiverId}
        It must be equivelant to the receiver SOR identifier tag within the message itself (BinaryContent) without any hidden characters or padding.
      </assert>
    </rule>
  </pattern>
  
  <pattern name="Check BusinessScope MessageIdentifier is the id from the BinaryContent">
    <rule context="sbdhNS:StandardBusinessDocumentHeader/sbdhNS:BusinessScope">
      <assert test="sbdhNS:Scope[sbdhNS:Type = 'MESSAGEIDENTIFIER']" flag="fatal" id="BusinessScopeMessageIdentifierAssertion-01">
        BusinessScope MessageIdentifier is not found in the BusinessScope enumeration.
      </assert>
    </rule>

    <rule context="sbdhNS:StandardBusinessDocumentHeader/sbdhNS:BusinessScope/sbdhNS:Scope[sbdhNS:Type = 'MESSAGEIDENTIFIER']/sbdhNS:InstanceIdentifier">
      <assert test="string() = '${expectedMessageIdentifier}'" flag="fatal" id="BusinessScopeMessageIdentifierAssertion-02">
        BusinessScope MessageIdentifier is not ${expectedMessageIdentifier}
        It must be equivelant to the messageheader id tag within the message itself (BinaryContent) without any hidden characters or padding.
      </assert>
    </rule>
  </pattern>
  
  <!-- TODO: AFTER OLE: If there is hidden characters give a warning. But let the test pass otherwise. This is for all examples  -->
  <pattern name="Check BusinessScope MessageEnvelopeIdentifier is the id from the BinaryContent">
    <rule context="sbdhNS:StandardBusinessDocumentHeader/sbdhNS:BusinessScope">
      <assert test="sbdhNS:Scope[sbdhNS:Type = 'MESSAGEENVELOPEIDENTIFIER']" flag="fatal" id="BusinessScopeMessageEnvelopeIdentifierAssertion-01">
        BusinessScope MessageEnvelopeIdentifier is not found in the BusinessScope enumeration.
      </assert>
    </rule>
    <rule context="sbdhNS:StandardBusinessDocumentHeader/sbdhNS:BusinessScope/sbdhNS:Scope[sbdhNS:Type = 'MESSAGEENVELOPEIDENTIFIER']/sbdhNS:InstanceIdentifier">
      <assert test="string() = '${expectedMessageEnvelopeIdentifier}'" flag="fatal" id="BusinessScopeMessageEnvelopeIdentifierAssertion-02">
        BusinessScope MessageEnvelopeIdentifier is not ${expectedMessageEnvelopeIdentifier}.
        It must be equivelant to id tag within the message itself (BinaryContent) without any hidden characters or padding.
      </assert>
    </rule>
  </pattern>
  
  <!-- TODO: AFTER OLE: EBBP-SIGNALS is the SBDH ACK that we need to test for. For every message passing through EHMI, it always needs to request an
    acknolwedgement. And it will then receive an acknolwedgement in the form of a EBBP-SIGNAL (which we need to make an entire test for)
    Then if the FHIR standard requires a FHIR ack message to be sent. That has to also be sent through EHMI.
    And upon sending the FHIR ack the ebbp-signal ack will also be created.
    So for one message, we create 2 ebbp-signal ack and one fhir ack.
  -->
  
  <pattern name="Check BusinessScope StatisticalInformation is a valid MedCom monitoring id">
    <rule context="sbdhNS:StandardBusinessDocumentHeader/sbdhNS:BusinessScope">
      <assert test="sbdhNS:Scope[sbdhNS:Type = 'StatisticalInformation']" flag="fatal" id="BusinessScopeStatisticalInformationAssertion-01">
        BusinessScope StatisticalInformation is not found in the BusinessScope enumeration.
      </assert>
    </rule>

    <rule context="sbdhNS:StandardBusinessDocumentHeader/sbdhNS:BusinessScope/sbdhNS:Scope[sbdhNS:Type = 'StatisticalInformation']/sbdhNS:InstanceIdentifier">
      <assert test="string() = 'MCM:${expectedDocumentIdentifierStandard}'" flag="fatal" id="BusinessScopeStatisticalInformationAssertion-02">
        BusinessScope StatisticalInformation is not a valid MedCom monitoring id. It should be MCM:${expectedDocumentIdentifierStandard}.
      </assert>
    </rule>
  </pattern>
  
  <!-- TODO: AFTER OLE: We need a completely seperate test for an SBDH that is also to be sent to the XDS metadata
    We need to validate the XDS scope and then instead of sdn-emergence it should be dds-emergence
    We need to validate that if it's dds-emergence there also needs to be an XDS metadata scope
  -->
  
  <pattern name="Check BusinessScope Reliable Messaging Receipt Ack is setup correctly">
    <rule context="sbdhNS:StandardBusinessDocumentHeader/sbdhNS:BusinessScope">
      <assert test="sbdhNS:Scope[sbdhNS:Type = 'EHMI-ReceiptAcknowledgement']" flag="fatal" id="BusinessScopeReceiptRequestAssertion-01">
        BusinessScope EHMI-ReceiptAcknowledgement is not found in the BusinessScope enumeration.
      </assert>
    </rule>
    <rule context="sbdhNS:StandardBusinessDocumentHeader/sbdhNS:BusinessScope/sbdhNS:Scope[sbdhNS:Type = 'EHMI-ReceiptAcknowledgement']">
      <assert test="normalize-space(sbdhNS:InstanceIdentifier/string()) = 'Request'" flag="fatal" id="BusinessScopeReceiptRequestAssertion-02">
        BusinessScope EHMI-ReceiptAcknowledgement InstanceIdentifier is not 'Request'.
      </assert>
      
    </rule>
    
    <rule context="sbdhNS:StandardBusinessDocumentHeader/sbdhNS:BusinessScope/sbdhNS:Scope[sbdhNS:Type = 'EHMI-ReceiptAcknowledgement']/sbdhNS:CorrelationInformation">
      
      <assert test="xs:dateTime(sbdhNS:ExpectedResponseDateTime) gt xs:dateTime(sbdhNS:RequestingDocumentCreationDateTime)"
              flag="fatal"
              id="BusinessScopeReceiptRequestAssertion-03">
        ExpectedResponseDateTime must be later than RequestingDocumentCreationDateTime.
      </assert>
      
      <assert test="xs:dateTime(sbdhNS:ExpectedResponseDateTime) - xs:dateTime(sbdhNS:RequestingDocumentCreationDateTime)
        le xs:dayTimeDuration('PT10M')"
              flag="fatal"
              id="BusinessScopeReceiptRequestAssertion-04">
        ExpectedResponseDateTime must be within 10 minutes of RequestingDocumentCreationDateTime.
      </assert>
      
    </rule>
    
    <!-- TODO: AFTER OLE: All the MedCom scopes are required always. See if we can incorporate it in the xsd schema otherwise just
    test it here with xPath
    -->
    
    <rule context="sbdhNS:StandardBusinessDocumentHeader/sbdhNS:BusinessScope/sbdhNS:Scope[sbdhNS:Type = 'EHMI-ReceiptAcknowledgement']/sbdhNS:BusinessService">
      <assert test="sbdhNS:BusinessServiceName = 'EHMI-ReceiptAcknowledgement-Request'"
              flag="fatal"
              id="BusinessScopeReceiptRequestAssertion-05">
        BusinessServiceName must be 'EHMI-ReceiptAcknowledgement-Request'.
      </assert>
    </rule>

  </pattern>

</schema>
