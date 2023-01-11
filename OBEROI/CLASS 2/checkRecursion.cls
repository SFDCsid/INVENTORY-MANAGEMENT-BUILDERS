public with sharing class checkRecursion {
    
    private static boolean firstRun = true;
    private static boolean firstRunTask = true;
    private static boolean firstRunA = true;
    public static boolean isFirstRun() {
        if(firstRun) {
            firstRun = false;
            return true;
        } else {
            return firstRun;
        }
        
    }
    
    public static void resetFirstRun() {
        firstRun = true;
    }
    
    public static boolean isFirstRunTask() {
        if(firstRunTask) {
            firstRunTask = false;
            return true;
        } else {
            return firstRunTask;
        }
        
    }
    
    public static void resetFirstRunTask() {
        firstRunTask = true;
    }
    
    public static boolean isFirstRunA() {
        if(firstRunA) {
            firstRunA = false;
            return true;
        } else {
            return firstRunA;
        }
        
    }
    
    public static void resetFirstRunA() {
        firstRunA = true;
    }
}