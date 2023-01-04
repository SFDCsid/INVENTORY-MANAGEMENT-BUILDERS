global with sharing class Ex_INFormat {
    public static String INFormating(Decimal money) {
        Boolean negative = false;
        if(money < 0) { 
            negative = true;
        }
        Decimal tempMoney = money;
        String m0 = tempMoney.setscale(0,RoundingMode.HALF_UP).toPlainString();
        String decimalPart;
        List<String> tempStr = new List<String>();
        if(String.isNotBlank(m0)) {
            tempStr = m0.split('\\.');
            if(tempStr != null && tempStr.size() ==2) {
              decimalPart = tempStr[1];
            }
        }
       
        //String m1 = String.valueOf(math.abs(money.setscale(0,RoundingMode.HALF_UP))).reverse();
        // String m1 = tempStr[0].reverse();
        String m1 = String.valueOf(math.abs(Integer.valueOf(tempStr[0]))).reverse();
        String mF = '';
        for(Integer i=0; i < m1.length() ; i++) {
            mF += m1.substring(i,i+1);
            if(i==2) {
                mF += ',';
            }
            if(i==4 || i==6 || i==8 || i==10 || i==12) {
                mF += ',';
            }
        }
        mf = mf.reverse();
        if(mf.substring(0,1).equals(',')) {
            mf = mf.substring(1);
        }
        if(String.isNotBlank(decimalPart))
           mf = mf + '.'  + decimalPart;
       
        if(!negative)
            mf =  mf + '/-';
        else
            mf = '- ' + mf + '/-';
          return mf;
    }
}