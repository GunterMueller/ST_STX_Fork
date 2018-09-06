<?xml version="1.0" encoding="iso-8859-2"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version="1.0">

<!-- Zkopírování celého dokumentu -->
<xsl:template match="node()|@*">
  <xsl:copy>
    <xsl:apply-templates select="node()|@*"/>
  </xsl:copy>
</xsl:template>

<xsl:template match="classname">
  <!-- Zkopírování původního elementu -->
  <xsl:copy-of select="."/>
  <!-- Vytvoření rejstříkového hesla -->
  <indexterm>
    <primary>class</primary>
    <secondary><xsl:value-of select="."/></secondary>
  </indexterm>
</xsl:template>

<xsl:template match="methodname">
<!-- Zkopírování původního elementu -->
  <xsl:copy-of select="."/>
  <!-- Vytvoření rejstříkového hesla -->
  <indexterm>
    <primary>method</primary>
    <secondary><xsl:value-of select="."/></secondary>
  </indexterm>
</xsl:template>

<xsl:template match="varname">
<!-- Zkopírování původního elementu -->
  <xsl:copy-of select="."/>
  <!-- Vytvoření rejstříkového hesla -->
  <indexterm>
    <primary>variable</primary>
    <secondary><xsl:value-of select="."/></secondary>
  </indexterm>
</xsl:template>



<xsl:template match="filename">
<!-- Zkopírování původního elementu -->
  <xsl:copy-of select="."/>
  <!-- Vytvoření rejstříkového hesla -->
  <indexterm>
    <primary>file</primary>
    <secondary><xsl:value-of select="."/></secondary>
  </indexterm>
</xsl:template>




<!-- Každé jméno souboru se také přidá do rejstříku -->
<xsl:template match="filename">
  <!-- Zkopírování původního elementu -->
  <xsl:copy-of select="."/>
  <!-- Vytvoření rejstříkového hesla -->
  <indexterm>
    <primary><xsl:value-of select="."/></primary>
  </indexterm>
</xsl:template>

</xsl:stylesheet>