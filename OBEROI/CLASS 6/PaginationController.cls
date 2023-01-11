public with sharing virtual class PaginationController {

    public static PaginationWrapper Beginning(PaginationWrapper p) { //user clicked beginning
        p.counter = 0;
        return p;
    }

    public static PaginationWrapper Previous(PaginationWrapper p) { //user clicked previous button
        p.counter -= p.list_size;
        return p;
    }

    public static PaginationWrapper Next(PaginationWrapper p) { //user clicked next button
        p.counter += p.list_size;
        return p;
    }

    public static PaginationWrapper End(PaginationWrapper p) { //user clicked end
        p.counter = p.total_size - math.mod(p.total_size, p.list_size);
        system.debug('p.counter:: '+p.counter);
        if(p.counter > 0){
        system.debug('first');
          p.last_limit = p.total_size - p.counter;
        }  
        if(p.last_limit != null && p.last_limit == 0){
        system.debug('second');
          p.last_limit = p.list_size;
        }  
        return p;
    }
    
    public static Boolean disablePrevious(PaginationWrapper p) { //this will disable the previous and beginning buttons
        if (p.counter>0) return false; else return true;
    }

    public static Boolean disableNext(PaginationWrapper p) { //this will disable the next and end buttons
        System.debug('p.counter:::::::'+p.counter);
        System.debug('p.list_size:::::::'+p.list_size);
        System.debug('p.total_size:::::::'+p.total_size);
        if (p.counter + p.list_size < p.total_size) return false; else return true;
    }

    public static Integer getTotal_size(PaginationWrapper p) {
        return p.total_size;
    }
    
    public static Integer getPageNumber(PaginationWrapper p) {
        return p.counter/p.list_size + 1;
    }

    public static Integer getTotalPages(PaginationWrapper p) {
        if (math.mod(p.total_size, p.list_size) > 0) {
            return p.total_size/p.list_size + 1;
        } else {
            return (p.total_size/p.list_size);
        }
    }
    
    public class PaginationWrapper {
      public integer counter;  //keeps track of the offset
      public integer list_size; //sets the page size or number of rows
      public integer total_size; //used to show user the total size of the list
      public string created_date; // used to add into soql
      public string last_date;
      public integer last_limit;
      public string first_limit;
      
      public PaginationWrapper() {
      
      }
      
      public PaginationWrapper(Integer c, Integer s, Integer t ) {
        this.counter = c;
        this.list_size = s;
        this.total_size = t;
       // this.created_date = d;
      }
    }
}