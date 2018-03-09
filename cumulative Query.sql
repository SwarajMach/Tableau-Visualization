----To calculate the cumulative amount

Declare @Account nvarchar(1000)
set @Account = 93800

Select sum(amount),[HFM Account Description] from
(
Select Sum(A.[Val#in rep#cur#]) AS amount,B.[HFM Account Description]
from [dbo].[SAP2$] A JOIN [dbo].[SAP_HFM_MAP] B ON B.[SAP Account] = A.[Cost Element]
JOIN [dbo].[cost_centres] C ON A.[Cost Center] = C.[ Cost Center]
where A.[Fiscal Year] = 2017 
--and A.[Period] = 10
--AND B.[HFM Account Description] = 'SGA straight time'
and b.[HFM Account] = @Account
--and b.[HFM Account] = 93800
group by B.[HFM Account Description]

UNION ALL

Select sum([Sum USD]) as amount,[HFM Account Description]
 from [dbo].[priority] where [HFM #] = @Account and [Fiscal Year] = '2017' 
 and Segment in ('Healthcare','Industry')
 --and [Function] is not null-- and [COSTC2 DESC#] = 'Salaries' 
 --and [period] = 10 
 group by [HFM Account Description]

 UNION ALL

Select sum(Amount) as amount, B.[HFM Account Description] from [dbo].[GPI_plans$] A
JOIN [dbo].[SAP_HFM_MAP] B ON A.[HFM Account] = B.[HFM Account] where 
A.[HFM Account] = @Account
--A.[HFM Account] = 93358
group by [HFM Account Description]

UNION ALL

Select sum(amount) as amount, B.[HFM Account Description] from [dbo].[gpi_xmark] A
JOIN [dbo].[SAP_HFM_MAP] B ON A.[HFM Account] = B.[HFM Account] where 
A.[HFM Account] = @Account
--A.[HFM Account] = 93358
group by [HFM Account Description]
)C
group by [HFM Account Description]

