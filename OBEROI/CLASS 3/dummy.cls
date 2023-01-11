public class dummy{
public List<booking__C> bl {get;set;}
public List<Integer> intList {get;set;}
public map<Integer,List<booking__C>> bMap {get;set;}

public dummy(){


 bl = new List<booking__C>();
 bl = [select id,name from booking__C]; 
intList = new List<Integer>();
system.debug('bl::'+bl.size());
bMap = new Map<Integer,List<Booking__C>>(); 

Integer i = 1;
Integer j = 1;
for(booking__C b : bl){   
    if(j == 4){
        j = 1;
        i++;
    }
    if(bMap.containsKey(i)){
        List<Booking__C> dummy = bMap.get(i);
        dummy.add(b);
        bMap.put(i,dummy);
    }else{
        List<Booking__C> dummy = new List<Booking__C>();
        dummy.add(b);
        bMap.put(i,dummy);
    }
    j++;
}

for(Integer k : bMap.keySet()){
    system.debug('i:: '+k +' ::: size::: '+bMap.get(k).size());
    intList.add(k);   
}

system.debug('intList::'+intList);
}
}