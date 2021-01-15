# SimpleQuery_UI

Simple Query helps you perform bulk queries against Active Directory and export the data in different formats.

![Alt text](/Example/1.png?raw=true)

All the entries added to the Search Form will be validated, those entries that do not correspond with the selected 'Object Class' as well as those entries that could not be found on the Domain will be displayed on a new form where you can see each skipped entry as well as the status (why was the entry skipped). This information can also be exported.

![Alt text](/Example/2.png?raw=true)

Once all entries have been validated a new form should appear where you can select which properties or attributes you wish to query. The Properties Form has a drop-down list with text prediction containing all the properties of the first object on the list. Note that you can use the 'Enter' key to add the selected / predicted items on the list.

![Alt text](/Example/3.png?raw=true)

Once the properties have been selected the main DataGrid should be filled and the 'Export' button should become enabled.

![Alt text](/Example/4.png?raw=true)
![Alt text](/Example/5.png?raw=true)
![Alt text](/Example/6.png?raw=true)

All buttons on the forms have shortcuts, the shortcuts can be accessed by pressing the 'ALT' key.
For example, on the main form, ALT+S is the shortcut for the 'Search' button, ALT+E is the shortcut for the 'Export' button, etc.

### Requirements:
   - PowerShell v5.1
   - ActiveDirectory PS Module
   - ImportExcel v7.1.0 PS Module

### Export Formats: *.xlsx, *.csv, *.txt, *.xml, *.json

#### For any bugs feel free to pm or email me.
  
#### __Special mention to Douglas Finke for creating the awesome ImportExcel PowerShell Module. Check out his GitHub at https://github.com/dfinke.__