/**
 * Interest rate request class
 */
public with sharing class InterestRateRequest {

    public Decimal value;
    public Decimal oldValue;

    /**
     * [InterestRateRequest loads the interest rate from the custom settings, if no value defaults to 2.5]
     */
    public InterestRateRequest() {
        Mortgage_Calculator_Defaults__c defaults = Mortgage_Calculator_Defaults__c.getInstance();
        if(defaults.Interest_Rate__c != null){
            value = defaults.Interest_Rate__c;
        } else {
            value = 2.5;
        }
    }

    public InterestRateRequest(Map<String, String> urlRequest){
        value = Double.valueOf(urlRequest.get('InterestRate'));
    }

    public Decimal getValue() {
        return value;
    }

    public void updateValue() {
        Mortgage_Calculator_Defaults__c defaults = Mortgage_Calculator_Defaults__c.getOrgDefaults();
        oldValue = defaults.Interest_Rate__c;
        defaults.Interest_Rate__c = this.value;
        upsert defaults Mortgage_Calculator_Defaults__c.Id;      
    }

    public void validate(){
        if(value == null){
            throw new MortgageCalculatorException('Missing Interest Rate');
        }
    }

    /**
     * Custom exception
     */
    private class MortgageCalculatorException extends Exception {}

}