<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<xsl:stylesheet xmlns:fn="http://www.w3.org/2005/xpath-functions"
                xmlns:iso="http://purl.oclc.org/dsdl/schematron"
                xmlns:saxon="http://saxon.sf.net/"
                xmlns:sbdhNS="http://www.unece.org/cefact/namespaces/StandardBusinessDocumentHeader"
                xmlns:schold="http://www.ascc.net/xml/schematron"
                xmlns:xhtml="http://www.w3.org/1999/xhtml"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:xsd="http://www.w3.org/2001/XMLSchema"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version="2.0"><!--Implementers: please note that overriding process-prolog or process-root is 
    the preferred method for meta-stylesheets to use where possible. -->
   <xsl:param name="archiveDirParameter"/>
   <xsl:param name="archiveNameParameter"/>
   <xsl:param name="fileNameParameter"/>
   <xsl:param name="fileDirParameter"/>
   <xsl:variable name="document-uri">
      <xsl:value-of select="document-uri(/)"/>
   </xsl:variable>
   <!--PHASES-->

   <!--PROLOG-->
   <xsl:output xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
               method="xml"
               omit-xml-declaration="no"
               standalone="yes"
               indent="yes"/>
   <!--XSD TYPES FOR XSLT2-->

   <!--KEYS AND FUNCTIONS-->

   <!--DEFAULT RULES-->

   <!--MODE: SCHEMATRON-SELECT-FULL-PATH-->
   <!--This mode can be used to generate an ugly though full XPath for locators-->
   <xsl:template match="*" mode="schematron-select-full-path">
      <xsl:apply-templates select="." mode="schematron-get-full-path"/>
   </xsl:template>
   <!--MODE: SCHEMATRON-FULL-PATH-->
   <!--This mode can be used to generate an ugly though full XPath for locators-->
   <xsl:template match="*" mode="schematron-get-full-path">
      <xsl:apply-templates select="parent::*" mode="schematron-get-full-path"/>
      <xsl:text>/</xsl:text>
      <xsl:choose>
         <xsl:when test="namespace-uri()=''">
            <xsl:value-of select="name()"/>
         </xsl:when>
         <xsl:otherwise>
            <xsl:text>*:</xsl:text>
            <xsl:value-of select="local-name()"/>
            <xsl:text>[namespace-uri()='</xsl:text>
            <xsl:value-of select="namespace-uri()"/>
            <xsl:text>']</xsl:text>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:variable name="preceding"
                    select="count(preceding-sibling::*[local-name()=local-name(current())                                   and namespace-uri() = namespace-uri(current())])"/>
      <xsl:text>[</xsl:text>
      <xsl:value-of select="1+ $preceding"/>
      <xsl:text>]</xsl:text>
   </xsl:template>
   <xsl:template match="@*" mode="schematron-get-full-path">
      <xsl:apply-templates select="parent::*" mode="schematron-get-full-path"/>
      <xsl:text>/</xsl:text>
      <xsl:choose>
         <xsl:when test="namespace-uri()=''">@<xsl:value-of select="name()"/>
         </xsl:when>
         <xsl:otherwise>
            <xsl:text>@*[local-name()='</xsl:text>
            <xsl:value-of select="local-name()"/>
            <xsl:text>' and namespace-uri()='</xsl:text>
            <xsl:value-of select="namespace-uri()"/>
            <xsl:text>']</xsl:text>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <!--MODE: SCHEMATRON-FULL-PATH-2-->
   <!--This mode can be used to generate prefixed XPath for humans-->
   <xsl:template match="node() | @*" mode="schematron-get-full-path-2">
      <xsl:for-each select="ancestor-or-self::*">
         <xsl:text>/</xsl:text>
         <xsl:value-of select="name(.)"/>
         <xsl:if test="preceding-sibling::*[name(.)=name(current())]">
            <xsl:text>[</xsl:text>
            <xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1"/>
            <xsl:text>]</xsl:text>
         </xsl:if>
      </xsl:for-each>
      <xsl:if test="not(self::*)">
         <xsl:text/>/@<xsl:value-of select="name(.)"/>
      </xsl:if>
   </xsl:template>
   <!--MODE: SCHEMATRON-FULL-PATH-3-->
   <!--This mode can be used to generate prefixed XPath for humans 
	(Top-level element has index)-->
   <xsl:template match="node() | @*" mode="schematron-get-full-path-3">
      <xsl:for-each select="ancestor-or-self::*">
         <xsl:text>/</xsl:text>
         <xsl:value-of select="name(.)"/>
         <xsl:if test="parent::*">
            <xsl:text>[</xsl:text>
            <xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1"/>
            <xsl:text>]</xsl:text>
         </xsl:if>
      </xsl:for-each>
      <xsl:if test="not(self::*)">
         <xsl:text/>/@<xsl:value-of select="name(.)"/>
      </xsl:if>
   </xsl:template>
   <!--MODE: GENERATE-ID-FROM-PATH -->
   <xsl:template match="/" mode="generate-id-from-path"/>
   <xsl:template match="text()" mode="generate-id-from-path">
      <xsl:apply-templates select="parent::*" mode="generate-id-from-path"/>
      <xsl:value-of select="concat('.text-', 1+count(preceding-sibling::text()), '-')"/>
   </xsl:template>
   <xsl:template match="comment()" mode="generate-id-from-path">
      <xsl:apply-templates select="parent::*" mode="generate-id-from-path"/>
      <xsl:value-of select="concat('.comment-', 1+count(preceding-sibling::comment()), '-')"/>
   </xsl:template>
   <xsl:template match="processing-instruction()" mode="generate-id-from-path">
      <xsl:apply-templates select="parent::*" mode="generate-id-from-path"/>
      <xsl:value-of select="concat('.processing-instruction-', 1+count(preceding-sibling::processing-instruction()), '-')"/>
   </xsl:template>
   <xsl:template match="@*" mode="generate-id-from-path">
      <xsl:apply-templates select="parent::*" mode="generate-id-from-path"/>
      <xsl:value-of select="concat('.@', name())"/>
   </xsl:template>
   <xsl:template match="*" mode="generate-id-from-path" priority="-0.5">
      <xsl:apply-templates select="parent::*" mode="generate-id-from-path"/>
      <xsl:text>.</xsl:text>
      <xsl:value-of select="concat('.',name(),'-',1+count(preceding-sibling::*[name()=name(current())]),'-')"/>
   </xsl:template>
   <!--MODE: GENERATE-ID-2 -->
   <xsl:template match="/" mode="generate-id-2">U</xsl:template>
   <xsl:template match="*" mode="generate-id-2" priority="2">
      <xsl:text>U</xsl:text>
      <xsl:number level="multiple" count="*"/>
   </xsl:template>
   <xsl:template match="node()" mode="generate-id-2">
      <xsl:text>U.</xsl:text>
      <xsl:number level="multiple" count="*"/>
      <xsl:text>n</xsl:text>
      <xsl:number count="node()"/>
   </xsl:template>
   <xsl:template match="@*" mode="generate-id-2">
      <xsl:text>U.</xsl:text>
      <xsl:number level="multiple" count="*"/>
      <xsl:text>_</xsl:text>
      <xsl:value-of select="string-length(local-name(.))"/>
      <xsl:text>_</xsl:text>
      <xsl:value-of select="translate(name(),':','.')"/>
   </xsl:template>
   <!--Strip characters-->
   <xsl:template match="text()" priority="-1"/>
   <!--SCHEMA SETUP-->
   <xsl:template match="/">
      <svrl:schematron-output xmlns:svrl="http://purl.oclc.org/dsdl/svrl" title="" schemaVersion="">
         <xsl:comment>
            <xsl:value-of select="$archiveDirParameter"/>   
		 <xsl:value-of select="$archiveNameParameter"/>  
		 <xsl:value-of select="$fileNameParameter"/>  
		 <xsl:value-of select="$fileDirParameter"/>
         </xsl:comment>
         <svrl:ns-prefix-in-attribute-values uri="http://www.unece.org/cefact/namespaces/StandardBusinessDocumentHeader"
                                             prefix="sbdhNS"/>
         <svrl:ns-prefix-in-attribute-values uri="http://www.w3.org/2005/xpath-functions" prefix="fn"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M2"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M3"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M4"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M5"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M6"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M7"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M8"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M9"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M10"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M11"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M12"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M13"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M14"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M15"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M16"/>
      </svrl:schematron-output>
   </xsl:template>
   <!--SCHEMATRON PATTERNS-->

   <!--PATTERN -->

   <!--RULE -->
   <xsl:template match="sbdhNS:StandardBusinessDocumentHeader/sbdhNS:Sender/sbdhNS:Identifier"
                 priority="1000"
                 mode="M2">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="sbdhNS:StandardBusinessDocumentHeader/sbdhNS:Sender/sbdhNS:Identifier"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="matches(., '^0088:\d{13}$')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="matches(., '^0088:\d{13}$')">
               <xsl:attribute name="id">SenderAssertion-01</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        Sender Identifier did not parse as valid GLN number. It must start with “0088:” followed by exactly 13 digits without any hidden characters or padding.
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M2"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M2"/>
   <xsl:template match="@*|node()" priority="-2" mode="M2">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M2"/>
   </xsl:template>
   <!--PATTERN -->

   <!--RULE -->
   <xsl:template match="sbdhNS:StandardBusinessDocumentHeader/sbdhNS:Receiver/sbdhNS:Identifier"
                 priority="1000"
                 mode="M3">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="sbdhNS:StandardBusinessDocumentHeader/sbdhNS:Receiver/sbdhNS:Identifier"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="matches(., '^0088:\d{13}$')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="matches(., '^0088:\d{13}$')">
               <xsl:attribute name="id">ReceiverAssertion-01</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        Receiver Identifier did not parse as valid GLN number. It must start with “0088:” followed by exactly 13 digits without any hidden characters or padding.
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M3"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M3"/>
   <xsl:template match="@*|node()" priority="-2" mode="M3">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M3"/>
   </xsl:template>
   <!--PATTERN -->

   <!--RULE -->
   <xsl:template match="sbdhNS:StandardBusinessDocumentHeader/sbdhNS:DocumentIdentification/sbdhNS:Standard"
                 priority="1000"
                 mode="M4">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="sbdhNS:StandardBusinessDocumentHeader/sbdhNS:DocumentIdentification/sbdhNS:Standard"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="string() = '${expectedDocumentIdentifierStandard}'"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="string() = '${expectedDocumentIdentifierStandard}'">
               <xsl:attribute name="id">DocumentIdentificationAssertion-01</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        DocumentIdentification Standard is not ${expectedDocumentIdentifierStandard}. 
        It must be equivelant to the messageheader eventCoding tag within the message itself (binarycontent) without any hidden characters or padding.
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M4"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M4"/>
   <xsl:template match="@*|node()" priority="-2" mode="M4">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M4"/>
   </xsl:template>
   <!--PATTERN -->

   <!--RULE -->
   <xsl:template match="sbdhNS:StandardBusinessDocumentHeader/sbdhNS:DocumentIdentification/sbdhNS:TypeVersion"
                 priority="1000"
                 mode="M5">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="sbdhNS:StandardBusinessDocumentHeader/sbdhNS:DocumentIdentification/sbdhNS:TypeVersion"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="string() = '${expectedMessageDefinitionVersion}'"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="string() = '${expectedMessageDefinitionVersion}'">
               <xsl:attribute name="id">DocumentIdentificationAssertion-02</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        DocumentIdentification TypeVersion is not ${expectedMessageDefinitionVersion}.
        It must be equivelant to the messageheader definition tag within the message itself (binarycontent) without any hidden characters or padding.
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M5"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M5"/>
   <xsl:template match="@*|node()" priority="-2" mode="M5">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M5"/>
   </xsl:template>
   <!--PATTERN -->

   <!--RULE -->
   <xsl:template match="sbdhNS:StandardBusinessDocumentHeader/sbdhNS:DocumentIdentification/sbdhNS:InstanceIdentifier"
                 priority="1000"
                 mode="M6">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="sbdhNS:StandardBusinessDocumentHeader/sbdhNS:DocumentIdentification/sbdhNS:InstanceIdentifier"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="matches(., '^[0-9a-f]{8}-[0-9a-f]{4}-[0-5][0-9a-f]{3}-[089ab][0-9a-f]{3}-[0-9a-f]{12}$')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="matches(., '^[0-9a-f]{8}-[0-9a-f]{4}-[0-5][0-9a-f]{3}-[089ab][0-9a-f]{3}-[0-9a-f]{12}$')">
               <xsl:attribute name="id">DocumentIdentificationAssertion-03</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        DocumentIdentification InstanceIdentifier is not a UUID. Make sure it doesn't contain any hidden characters or padding.
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M6"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M6"/>
   <xsl:template match="@*|node()" priority="-2" mode="M6">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M6"/>
   </xsl:template>
   <!--PATTERN -->

   <!--RULE -->
   <xsl:template match="sbdhNS:StandardBusinessDocumentHeader/sbdhNS:DocumentIdentification/sbdhNS:Type"
                 priority="1000"
                 mode="M7">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="sbdhNS:StandardBusinessDocumentHeader/sbdhNS:DocumentIdentification/sbdhNS:Type"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="string() = 'Bundle'"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="string() = 'Bundle'">
               <xsl:attribute name="id">DocumentIdentificationAssertion-04</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        DocumentIdentification Type is not 'Bundle'. Make sure it doesn't contain any hidden characters or padding.
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M7"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M7"/>
   <xsl:template match="@*|node()" priority="-2" mode="M7">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M7"/>
   </xsl:template>
   <!--PATTERN -->

   <!--RULE -->
   <xsl:template match="sbdhNS:StandardBusinessDocumentHeader/sbdhNS:BusinessScope"
                 priority="1001"
                 mode="M8">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="sbdhNS:StandardBusinessDocumentHeader/sbdhNS:BusinessScope"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="sbdhNS:Scope[sbdhNS:Type = 'DOCUMENTID']"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="sbdhNS:Scope[sbdhNS:Type = 'DOCUMENTID']">
               <xsl:attribute name="id">BusinessScopeDocumentIDAssertion-01</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        BusinessScope DocumentID is not found in the BusinessScope enumeration.
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M8"/>
   </xsl:template>
   <!--RULE -->
   <xsl:template match="sbdhNS:StandardBusinessDocumentHeader/sbdhNS:BusinessScope/sbdhNS:Scope[sbdhNS:Type = 'DOCUMENTID']/sbdhNS:InstanceIdentifier"
                 priority="1000"
                 mode="M8">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="sbdhNS:StandardBusinessDocumentHeader/sbdhNS:BusinessScope/sbdhNS:Scope[sbdhNS:Type = 'DOCUMENTID']/sbdhNS:InstanceIdentifier"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="string() = 'urn:dk:medcom:prod:messaging:fhir:structuredefinition:${expectedStructureDefinition}#urn:dk:medcom:fhir:${expectedStructureDefinition}:${expectedMessageDefinitionVersion}'"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="string() = 'urn:dk:medcom:prod:messaging:fhir:structuredefinition:${expectedStructureDefinition}#urn:dk:medcom:fhir:${expectedStructureDefinition}:${expectedMessageDefinitionVersion}'">
               <xsl:attribute name="id">BusinessScopeDocumentIDAssertion-01</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        BusinessScope DocumentID InstanceIdentifier is not urn:dk:medcom:prod:messaging:fhir:structuredefinition:${expectedStructureDefinition}#urn:dk:medcom:fhir:${expectedStructureDefinition}:${expectedMessageDefinitionVersion}.
        Make sure it doesn't contain any hidden characters or padding.
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M8"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M8"/>
   <xsl:template match="@*|node()" priority="-2" mode="M8">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M8"/>
   </xsl:template>
   <!--PATTERN -->

   <!--RULE -->
   <xsl:template match="sbdhNS:StandardBusinessDocumentHeader/sbdhNS:BusinessScope"
                 priority="1001"
                 mode="M9">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="sbdhNS:StandardBusinessDocumentHeader/sbdhNS:BusinessScope"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="sbdhNS:Scope[sbdhNS:Type = 'PROCESSID']"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="sbdhNS:Scope[sbdhNS:Type = 'PROCESSID']">
               <xsl:attribute name="id">BusinessScopeProcessIDAssertion-01</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        BusinessScope ProcessID is not found in the BusinessScope enumeration.
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M9"/>
   </xsl:template>
   <!--RULE -->
   <xsl:template match="sbdhNS:StandardBusinessDocumentHeader/sbdhNS:BusinessScope/sbdhNS:Scope[sbdhNS:Type = 'PROCESSID']/sbdhNS:InstanceIdentifier"
                 priority="1000"
                 mode="M9">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="sbdhNS:StandardBusinessDocumentHeader/sbdhNS:BusinessScope/sbdhNS:Scope[sbdhNS:Type = 'PROCESSID']/sbdhNS:InstanceIdentifier"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="string() = 'sdn-emergence'"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="string() = 'sdn-emergence'">
               <xsl:attribute name="id">BusinessScopeProcessIDAssertion-01</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        BusinessScope ProcessID InstanceIdentifier is not 'sdn-emergence'. Make sure it doesn't contain any hidden characters or padding.
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M9"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M9"/>
   <xsl:template match="@*|node()" priority="-2" mode="M9">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M9"/>
   </xsl:template>
   <!--PATTERN -->

   <!--RULE -->
   <xsl:template match="sbdhNS:StandardBusinessDocumentHeader/sbdhNS:BusinessScope"
                 priority="1001"
                 mode="M10">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="sbdhNS:StandardBusinessDocumentHeader/sbdhNS:BusinessScope"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="sbdhNS:Scope[sbdhNS:Type = 'PATIENTID']"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="sbdhNS:Scope[sbdhNS:Type = 'PATIENTID']">
               <xsl:attribute name="id">BusinessScopePatientIDAssertion-01</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        BusinessScope PatientID is not found in the BusinessScope enumeration.
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M10"/>
   </xsl:template>
   <!--RULE -->
   <xsl:template match="sbdhNS:StandardBusinessDocumentHeader/sbdhNS:BusinessScope/sbdhNS:Scope[sbdhNS:Type = 'PATIENTID']/sbdhNS:InstanceIdentifier"
                 priority="1000"
                 mode="M10">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="sbdhNS:StandardBusinessDocumentHeader/sbdhNS:BusinessScope/sbdhNS:Scope[sbdhNS:Type = 'PATIENTID']/sbdhNS:InstanceIdentifier"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="string() = '${expectedPatientCPR}'"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="string() = '${expectedPatientCPR}'">
               <xsl:attribute name="id">BusinessScopePatientIDAssertion-01</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        BusinessScope PatientID InstanceIdentifier is not ${expectedPatientCPR}
        It must be equivelant to the patient identifier tag within the message itself (BinaryContent) without any hidden characters or padding.
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M10"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M10"/>
   <xsl:template match="@*|node()" priority="-2" mode="M10">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M10"/>
   </xsl:template>
   <!--PATTERN -->

   <!--RULE -->
   <xsl:template match="sbdhNS:StandardBusinessDocumentHeader/sbdhNS:BusinessScope"
                 priority="1001"
                 mode="M11">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="sbdhNS:StandardBusinessDocumentHeader/sbdhNS:BusinessScope"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="sbdhNS:Scope[sbdhNS:Type = 'SENDERID']"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="sbdhNS:Scope[sbdhNS:Type = 'SENDERID']">
               <xsl:attribute name="id">BusinessScopeSenderIDAssertion-01</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        BusinessScope SenderID is not found in the BusinessScope enumeration.
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M11"/>
   </xsl:template>
   <!--RULE -->
   <xsl:template match="sbdhNS:StandardBusinessDocumentHeader/sbdhNS:BusinessScope/sbdhNS:Scope[sbdhNS:Type = 'SENDERID']/sbdhNS:InstanceIdentifier"
                 priority="1000"
                 mode="M11">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="sbdhNS:StandardBusinessDocumentHeader/sbdhNS:BusinessScope/sbdhNS:Scope[sbdhNS:Type = 'SENDERID']/sbdhNS:InstanceIdentifier"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="string() = '${expectedSenderId}'"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="string() = '${expectedSenderId}'">
               <xsl:attribute name="id">BusinessScopeSenderIDAssertion-01</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        BusinessScope SenderID InstanceIdentifier is not ${expectedSenderId}
        It must be equivelant to the sender SOR identifier tag within the message itself (BinaryContent) without any hidden characters or padding.
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M11"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M11"/>
   <xsl:template match="@*|node()" priority="-2" mode="M11">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M11"/>
   </xsl:template>
   <!--PATTERN -->

   <!--RULE -->
   <xsl:template match="sbdhNS:StandardBusinessDocumentHeader/sbdhNS:BusinessScope"
                 priority="1001"
                 mode="M12">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="sbdhNS:StandardBusinessDocumentHeader/sbdhNS:BusinessScope"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="sbdhNS:Scope[sbdhNS:Type = 'RECEIVERID']"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="sbdhNS:Scope[sbdhNS:Type = 'RECEIVERID']">
               <xsl:attribute name="id">BusinessScopeReceiverIDAssertion-01</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        BusinessScope ReceiverID is not found in the BusinessScope enumeration.
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M12"/>
   </xsl:template>
   <!--RULE -->
   <xsl:template match="sbdhNS:StandardBusinessDocumentHeader/sbdhNS:BusinessScope/sbdhNS:Scope[sbdhNS:Type = 'RECEIVERID']/sbdhNS:InstanceIdentifier"
                 priority="1000"
                 mode="M12">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="sbdhNS:StandardBusinessDocumentHeader/sbdhNS:BusinessScope/sbdhNS:Scope[sbdhNS:Type = 'RECEIVERID']/sbdhNS:InstanceIdentifier"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="string() = '${expectedReceiverId}'"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="string() = '${expectedReceiverId}'">
               <xsl:attribute name="id">BusinessScopeReceiverIDAssertion-02</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        BusinessScope ReceiverID InstanceIdentifier is not ${expectedReceiverId}
        It must be equivelant to the receiver SOR identifier tag within the message itself (BinaryContent) without any hidden characters or padding.
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M12"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M12"/>
   <xsl:template match="@*|node()" priority="-2" mode="M12">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M12"/>
   </xsl:template>
   <!--PATTERN -->

   <!--RULE -->
   <xsl:template match="sbdhNS:StandardBusinessDocumentHeader/sbdhNS:BusinessScope"
                 priority="1001"
                 mode="M13">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="sbdhNS:StandardBusinessDocumentHeader/sbdhNS:BusinessScope"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="sbdhNS:Scope[sbdhNS:Type = 'MESSAGEIDENTIFIER']"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="sbdhNS:Scope[sbdhNS:Type = 'MESSAGEIDENTIFIER']">
               <xsl:attribute name="id">BusinessScopeMessageIdentifierAssertion-01</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        BusinessScope MessageIdentifier is not found in the BusinessScope enumeration.
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M13"/>
   </xsl:template>
   <!--RULE -->
   <xsl:template match="sbdhNS:StandardBusinessDocumentHeader/sbdhNS:BusinessScope/sbdhNS:Scope[sbdhNS:Type = 'MESSAGEIDENTIFIER']/sbdhNS:InstanceIdentifier"
                 priority="1000"
                 mode="M13">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="sbdhNS:StandardBusinessDocumentHeader/sbdhNS:BusinessScope/sbdhNS:Scope[sbdhNS:Type = 'MESSAGEIDENTIFIER']/sbdhNS:InstanceIdentifier"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="string() = '${expectedMessageIdentifier}'"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="string() = '${expectedMessageIdentifier}'">
               <xsl:attribute name="id">BusinessScopeMessageIdentifierAssertion-02</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        BusinessScope MessageIdentifier is not ${expectedMessageIdentifier}
        It must be equivelant to the messageheader id tag within the message itself (BinaryContent) without any hidden characters or padding.
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M13"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M13"/>
   <xsl:template match="@*|node()" priority="-2" mode="M13">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M13"/>
   </xsl:template>
   <!--PATTERN -->

   <!--RULE -->
   <xsl:template match="sbdhNS:StandardBusinessDocumentHeader/sbdhNS:BusinessScope"
                 priority="1001"
                 mode="M14">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="sbdhNS:StandardBusinessDocumentHeader/sbdhNS:BusinessScope"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="sbdhNS:Scope[sbdhNS:Type = 'MESSAGEENVELOPEIDENTIFIER']"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="sbdhNS:Scope[sbdhNS:Type = 'MESSAGEENVELOPEIDENTIFIER']">
               <xsl:attribute name="id">BusinessScopeMessageEnvelopeIdentifierAssertion-01</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        BusinessScope MessageEnvelopeIdentifier is not found in the BusinessScope enumeration.
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M14"/>
   </xsl:template>
   <!--RULE -->
   <xsl:template match="sbdhNS:StandardBusinessDocumentHeader/sbdhNS:BusinessScope/sbdhNS:Scope[sbdhNS:Type = 'MESSAGEENVELOPEIDENTIFIER']/sbdhNS:InstanceIdentifier"
                 priority="1000"
                 mode="M14">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="sbdhNS:StandardBusinessDocumentHeader/sbdhNS:BusinessScope/sbdhNS:Scope[sbdhNS:Type = 'MESSAGEENVELOPEIDENTIFIER']/sbdhNS:InstanceIdentifier"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="string() = '${expectedMessageEnvelopeIdentifier}'"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="string() = '${expectedMessageEnvelopeIdentifier}'">
               <xsl:attribute name="id">BusinessScopeMessageEnvelopeIdentifierAssertion-02</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        BusinessScope MessageEnvelopeIdentifier is not ${expectedMessageEnvelopeIdentifier}.
        It must be equivelant to id tag within the message itself (BinaryContent) without any hidden characters or padding.
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M14"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M14"/>
   <xsl:template match="@*|node()" priority="-2" mode="M14">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M14"/>
   </xsl:template>
   <!--PATTERN -->

   <!--RULE -->
   <xsl:template match="sbdhNS:StandardBusinessDocumentHeader/sbdhNS:BusinessScope"
                 priority="1001"
                 mode="M15">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="sbdhNS:StandardBusinessDocumentHeader/sbdhNS:BusinessScope"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="sbdhNS:Scope[sbdhNS:Type = 'StatisticalInformation']"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="sbdhNS:Scope[sbdhNS:Type = 'StatisticalInformation']">
               <xsl:attribute name="id">BusinessScopeStatisticalInformationAssertion-01</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        BusinessScope StatisticalInformation is not found in the BusinessScope enumeration.
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M15"/>
   </xsl:template>
   <!--RULE -->
   <xsl:template match="sbdhNS:StandardBusinessDocumentHeader/sbdhNS:BusinessScope/sbdhNS:Scope[sbdhNS:Type = 'StatisticalInformation']/sbdhNS:InstanceIdentifier"
                 priority="1000"
                 mode="M15">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="sbdhNS:StandardBusinessDocumentHeader/sbdhNS:BusinessScope/sbdhNS:Scope[sbdhNS:Type = 'StatisticalInformation']/sbdhNS:InstanceIdentifier"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="string() = 'MCM:${expectedDocumentIdentifierStandard}'"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="string() = 'MCM:${expectedDocumentIdentifierStandard}'">
               <xsl:attribute name="id">BusinessScopeStatisticalInformationAssertion-02</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        BusinessScope StatisticalInformation is not a valid MedCom monitoring id. It should be MCM:${expectedDocumentIdentifierStandard}.
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M15"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M15"/>
   <xsl:template match="@*|node()" priority="-2" mode="M15">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M15"/>
   </xsl:template>
   <!--PATTERN -->

   <!--RULE -->
   <xsl:template match="sbdhNS:StandardBusinessDocumentHeader/sbdhNS:BusinessScope"
                 priority="1003"
                 mode="M16">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="sbdhNS:StandardBusinessDocumentHeader/sbdhNS:BusinessScope"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="sbdhNS:Scope[sbdhNS:Type = 'EHMI-ReceiptAcknowledgement']"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="sbdhNS:Scope[sbdhNS:Type = 'EHMI-ReceiptAcknowledgement']">
               <xsl:attribute name="id">BusinessScopeReceiptRequestAssertion-01</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        BusinessScope EHMI-ReceiptAcknowledgement is not found in the BusinessScope enumeration.
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M16"/>
   </xsl:template>
   <!--RULE -->
   <xsl:template match="sbdhNS:StandardBusinessDocumentHeader/sbdhNS:BusinessScope/sbdhNS:Scope[sbdhNS:Type = 'EHMI-ReceiptAcknowledgement']"
                 priority="1002"
                 mode="M16">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="sbdhNS:StandardBusinessDocumentHeader/sbdhNS:BusinessScope/sbdhNS:Scope[sbdhNS:Type = 'EHMI-ReceiptAcknowledgement']"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="normalize-space(sbdhNS:InstanceIdentifier/string()) = 'Request'"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="normalize-space(sbdhNS:InstanceIdentifier/string()) = 'Request'">
               <xsl:attribute name="id">BusinessScopeReceiptRequestAssertion-02</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        BusinessScope EHMI-ReceiptAcknowledgement InstanceIdentifier is not 'Request'.
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M16"/>
   </xsl:template>
   <!--RULE -->
   <xsl:template match="sbdhNS:StandardBusinessDocumentHeader/sbdhNS:BusinessScope/sbdhNS:Scope[sbdhNS:Type = 'EHMI-ReceiptAcknowledgement']/sbdhNS:CorrelationInformation"
                 priority="1001"
                 mode="M16">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="sbdhNS:StandardBusinessDocumentHeader/sbdhNS:BusinessScope/sbdhNS:Scope[sbdhNS:Type = 'EHMI-ReceiptAcknowledgement']/sbdhNS:CorrelationInformation"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="xs:dateTime(sbdhNS:ExpectedResponseDateTime) gt xs:dateTime(sbdhNS:RequestingDocumentCreationDateTime)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="xs:dateTime(sbdhNS:ExpectedResponseDateTime) gt xs:dateTime(sbdhNS:RequestingDocumentCreationDateTime)">
               <xsl:attribute name="id">BusinessScopeReceiptRequestAssertion-03</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        ExpectedResponseDateTime must be later than RequestingDocumentCreationDateTime.
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="xs:dateTime(sbdhNS:ExpectedResponseDateTime) - xs:dateTime(sbdhNS:RequestingDocumentCreationDateTime)         le xs:dayTimeDuration('PT10M')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="xs:dateTime(sbdhNS:ExpectedResponseDateTime) - xs:dateTime(sbdhNS:RequestingDocumentCreationDateTime) le xs:dayTimeDuration('PT10M')">
               <xsl:attribute name="id">BusinessScopeReceiptRequestAssertion-04</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        ExpectedResponseDateTime must be within 10 minutes of RequestingDocumentCreationDateTime.
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M16"/>
   </xsl:template>
   <!--RULE -->
   <xsl:template match="sbdhNS:StandardBusinessDocumentHeader/sbdhNS:BusinessScope/sbdhNS:Scope[sbdhNS:Type = 'EHMI-ReceiptAcknowledgement']/sbdhNS:BusinessService"
                 priority="1000"
                 mode="M16">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="sbdhNS:StandardBusinessDocumentHeader/sbdhNS:BusinessScope/sbdhNS:Scope[sbdhNS:Type = 'EHMI-ReceiptAcknowledgement']/sbdhNS:BusinessService"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="sbdhNS:BusinessServiceName = 'EHMI-ReceiptAcknowledgement-Request'"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="sbdhNS:BusinessServiceName = 'EHMI-ReceiptAcknowledgement-Request'">
               <xsl:attribute name="id">BusinessScopeReceiptRequestAssertion-05</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
        BusinessServiceName must be 'EHMI-ReceiptAcknowledgement-Request'.
      </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M16"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M16"/>
   <xsl:template match="@*|node()" priority="-2" mode="M16">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M16"/>
   </xsl:template>
</xsl:stylesheet>
