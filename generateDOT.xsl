<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="text" indent="no"/>

	<xsl:template match="пелевин">
		graph {
			overlap=voronoi
    		splines=true

    		bgcolor="#1f1f1f"

    		node [fontsize=10 fontname="Helvetica" penwidth=0.6]
    		edge [penwidth=0.6 color="#eeeeee"]

    		<xsl:apply-templates/>
    		<xsl:call-template name="строить-связи"/>
		}
	</xsl:template>

	<xsl:template match="произведения">
		subgraph {
			node [shape=box penwidth=0.8 style=filled fillcolor="#181818" color="#090909" fontcolor="#fefefe"]

			<xsl:for-each select="сущность">
				"<xsl:value-of select="название"/>"
			</xsl:for-each>
		}
	</xsl:template>

	<xsl:template match="связи">
		subgraph {
			node [shape=oval style=filled color="#ececec" fontcolor="#ececec" fillcolor="#2f2f2f"]

			<xsl:for-each select="сущность">
				"<xsl:value-of select="название"/>"

				<xsl:if test="тип = 'явление'">
					[shape=egg color="#e8e8e8" fontcolor="#e8e8e8" style=""]
				</xsl:if>
			</xsl:for-each>
		}
	</xsl:template>

	<xsl:template name="строить-связи">
		<xsl:for-each select="//произведения/сущность">
			<xsl:variable name="название"><xsl:value-of select="название"/></xsl:variable>

			<xsl:for-each select="//связь[text() = current()/название]/../../название">
				"<xsl:value-of select="$название"/>" -- "<xsl:value-of select="current()"/>"
			</xsl:for-each>
		</xsl:for-each>
    </xsl:template>

    <xsl:template match="text()|@*"/>
</xsl:stylesheet>