SELECT  Name = Paravalue.value('Name[1]', 'VARCHAR(250)')
       ,Type = Paravalue.value('Type[1]', 'VARCHAR(250)')
       ,Nullable = Paravalue.value('Nullable[1]', 'VARCHAR(250)')
       ,AllowBlank = Paravalue.value('AllowBlank[1]', 'VARCHAR(250)')
       ,MultiValue = Paravalue.value('MultiValue[1]', 'VARCHAR(250)')
       ,UsedInQuery = Paravalue.value('UsedInQuery[1]', 'VARCHAR(250)')
       ,Prompt = Paravalue.value('Prompt[1]', 'VARCHAR(250)')
       ,DynamicPrompt = Paravalue.value('DynamicPrompt[1]', 'VARCHAR(250)')
       ,PromptUser = Paravalue.value('PromptUser[1]', 'VARCHAR(250)')
       ,State = Paravalue.value('State[1]', 'VARCHAR(250)')
 FROM (
     SELECT C.Name,CONVERT(XML,C.Parameter) AS ParameterXML
       FROM  ReportServer.dbo.Catalog C
      WHERE  C.Content is not null
        AND  C.Type  = 2
        AND  C.Name  =  'ReportName'
    ) a
CROSS APPLY ParameterXML.nodes('//Parameters/Parameter') p ( Paravalue )