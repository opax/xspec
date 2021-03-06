<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet exclude-result-prefixes="#all" version="2.0"
	xmlns:x="http://www.jenitennison.com/xslt/xspec" xmlns:xs="http://www.w3.org/2001/XMLSchema"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<!--
		Makes absolute URI from @schematron and resolves it with catalog.
		Output XML structure is for Ant <xmlproperty> task.
	-->
	<xsl:template as="element(xspec)" match="document-node()">
		<xspec>
			<schematron>
				<uri>
					<!-- Resolve with node base URI -->
					<xsl:variable as="xs:anyURI" name="schematron-uri"
						select="/x:description/@schematron/resolve-uri(., base-uri())" />

					<!-- Resolve with catalog
						https://sourceforge.net/p/saxon/mailman/message/36339785/
						"document-uri() returns the (absolutized) requested URI, while base-uri() returns
						the actual document location after catalog resolution." -->
					<xsl:variable as="xs:anyURI" name="schematron-uri"
						select="doc($schematron-uri)/base-uri()" />

					<!-- Can be 'file:C:/...' for some reason (maybe https://issues.apache.org/jira/browse/XMLCOMMONS-24). Fix it. -->
					<xsl:value-of select="replace($schematron-uri, '^(file:)([^/])', '$1/$2')" />
				</uri>
			</schematron>
		</xspec>
	</xsl:template>
</xsl:stylesheet>
