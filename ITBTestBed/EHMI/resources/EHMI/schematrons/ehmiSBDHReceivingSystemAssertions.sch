<?xml version="1.0" encoding="UTF-8"?>
<schema xmlns="http://purl.oclc.org/dsdl/schematron" queryBinding="xslt2">
  
  <ns prefix="sbdhNS" uri="http://www.unece.org/cefact/namespaces/StandardBusinessDocumentHeader"></ns>
  <ns prefix="fn" uri="http://www.w3.org/2005/xpath-functions"/>
  
  <pattern name="Check BusinessScope Reliable Messaging Receipt Ack response is setup correctly">
    <rule context="sbdhNS:StandardBusinessDocumentHeader/sbdhNS:BusinessScope">
      <assert test="sbdhNS:Scope[sbdhNS:Type = 'EHMI-ReceiptAcknowledgement']" flag="fatal" id="BusinessScopeReceiptResponseAssertion-01">
        BusinessScope EHMI-ReceiptAcknowledgement is not found in the BusinessScope enumeration.
      </assert>
    </rule>
    
    <rule context="sbdhNS:StandardBusinessDocumentHeader/sbdhNS:BusinessScope/sbdhNS:Scope[sbdhNS:Type = 'EHMI-ReceiptAcknowledgement']">
      <assert test="normalize-space(sbdhNS:InstanceIdentifier/string()) = 'Response'" flag="fatal" id="BusinessScopeReceiptResponseAssertion-02">
        BusinessScope EHMI-ReceiptAcknowledgement InstanceIdentifier is not 'Response'.
      </assert>
    </rule>
    
    <rule context="sbdhNS:StandardBusinessDocumentHeader/sbdhNS:BusinessScope/sbdhNS:Scope[sbdhNS:Type = 'EHMI-ReceiptAcknowledgement']/sbdhNS:CorrelationInformation">
      
      <assert test="sbdhNS:RequestingDocumentCreationDateTime/string() = '${requestingDocumentCreationDateTime}'"
              flag="fatal"
              id="BusinessScopeReceiptResponseAssertion-03">
        RequestingDocumentCreationDateTime must be the same as the original envelope / sending MSH SBDH message.
      </assert>
      
      <assert test="sbdhNS:RequestingDocumentInstanceIdentifier/string() = '${requestingDocumentInstanceIdentifier}'"
              flag="fatal"
              id="BusinessScopeReceiptResponseAssertion-04">
        RequestingDocumentInstanceIdentifier must be the same as the original envelope / sending MSH SBDH message.
      </assert>
      
      <assert test="not(sbdhNS:ExpectedResponseDateTime)"
              flag="fatal"
              id="BusinessScopeReceiptResponseAssertion-05">
        ExpectedResponseDateTime must not be present in the response.
      </assert>
    </rule>
    
    <rule context="sbdhNS:StandardBusinessDocumentHeader/sbdhNS:BusinessScope/sbdhNS:Scope[sbdhNS:Type = 'EHMI-ReceiptAcknowledgement']/sbdhNS:BusinessService">
      <assert test="sbdhNS:BusinessServiceName = 'EHMI-ReceiptAcknowledgement-Response'"
              flag="fatal"
              id="BusinessScopeReceiptResponseAssertion-06">
        BusinessServiceName must be 'EHMI-ReceiptAcknowledgement-Response'.
      </assert>
    </rule>
    
  </pattern>
  
</schema>
