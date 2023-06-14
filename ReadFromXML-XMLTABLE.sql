SELECT * FROM
XMLTABLE('/Matrix/Rows/Row' PASSING
'
<Matrix>
	<AffectsFormMode>1</AffectsFormMode>
	<BackColor>14543598</BackColor>
	<Description/>
	<DisplayDesc>0</DisplayDesc>
	<Enabled>1</Enabled>
	<FontSize>-1</FontSize>
	<ForeColor>-1</ForeColor>
	<FromPane>2</FromPane>
	<Height>410</Height>
	<Layout>0</Layout>
	<Left>5</Left>
	<LinkTo/>
	<Rows>
		<Row>
			<Visible>1</Visible>
			<Columns>
				<Column>
					<ID>0</ID>
					<Value>1</Value>
				</Column>
				<Column>
					<ID>1</ID>
					<Value>OB</Value>
				</Column>
				<Column>
					<ID>2</ID>
					<Value/>
				</Column>
				<Column>
					<ID>3</ID>
					<Value/>
				</Column>
				<Column>
					<ID>67</ID>
					<Value/>
				</Column>
				<Column>
					<ID>4</ID>
					<Value/>
				</Column>
			</Columns>
		</Row>
	</Rows>
</Matrix>
'
COLUMNS 
--"Id" nvarchar(10) PATH 'Columns/Column/ID',
"Value" nvarchar(10) PATH 'Columns/Column[2]/Value'

) as XTABLE;


