select "C0", "C1", "C2", "C3" from
(
select "TipoDePez", 
ROW_NUMBER() Over (Partition by "ClasePez") "RN", 
LEAD("TipoDePez",0,'') Over (Partition by "ClasePez" Order by "TipoDePez") "C0",
LEAD("TipoDePez",1,'') Over (Partition by "ClasePez" Order by "TipoDePez") "C1",
LEAD("TipoDePez",2,'') Over (Partition by "ClasePez" Order by "TipoDePez") "C2",
LEAD("TipoDePez",3,'') Over (Partition by "ClasePez" Order by "TipoDePez") "C3"
from 

(select 'Lisa' "TipoDePez", 'a' "ClasePez", 1 "Precio" from dummy
union all
select 'Pejerrey',  'a' , 2  from dummy
union all
select 'Salmon' , 'a' , 8  from dummy
union all
select 'Sardina' , 'a' , 4 from dummy
union all
select 'Pez Espada' , 'a',  7  from dummy
union all
select 'Palometa' , 'b' , 1  from dummy
union all
select 'Piraña' , 'b' , 1  from dummy
union all
select 'Sabalo' , 'b' , 2  from dummy
)
) where "RN" = 1
