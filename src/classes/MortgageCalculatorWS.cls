/**
* Web service to calculate the mortgage payments, max mortgage amount and update interest rate
* assumption: amortization period given in years
* assumption: asking price is the loan amount, not the loan amount + down payment
* @author 	Tanminder Rai
* @date 	Feb 13, 2017
*/
@RestResource(urlMapping='/mortgage-calculator/*')
global class MortgageCalculatorWS {

    /**
     * getAmount 	Get the payment or max mortgage amount 	
     * @return		JSON string with the payment amount or max mortgage amount
     */    
    @HttpGet
    global static String getAmount() {

        RestRequest request = RestContext.request;
        String url = request.requestURI.substring( request.requestURI.lastIndexOf('/')+1);
        Response response = new Response();

        if(url == 'payment-amount'){

            try {
                PaymentAmountRequest paymentAmountRequest = new PaymentAmountRequest(request.params);
                paymentAmountRequest.validate();
                Decimal result = paymentAmountRequest.getPaymentAmount();
                response.setResult(String.Valueof(result) );
            }
            catch(MortgageCalculatorException ex) {
                response.addError(ex.getMessage());
            }
            catch(Exception ex) {
                response.addError('Something unexpected happened. Please contact support');
            }

        }else if(url == 'mortgage-amount'){
            try {
                MortgageAmountRequest mortgageAmountRequest = new MortgageAmountRequest(request.params);
                mortgageAmountRequest.validate();
                Decimal result = mortgageAmountRequest.getMaxMortgageAmount();
                response.setResult(String.Valueof(result) );
            }
            catch(MortgageCalculatorException ex) {
                response.addError(ex.getMessage());
            }
            catch(Exception ex) {
                response.addError('Something unexpected happened. Please contact support');
            }
        }

        return JSON.serialize(response);
    }

    /**
     * updateInterestRate 	Updates the interest rate in the database
     * @return  			Message with the old and updated interest rate
     */
    @HttpPatch(urlMapping='/interest-rate/*')
    global static String updateInterestRate() {

    	RestRequest request = RestContext.request;	
        Response response = new Response();

        try {
            InterestRateRequest interestRate = new InterestRateRequest(request.params);
            interestRate.validate();
            interestRate.updateValue();
            response.setResult('Interest rate has been updated from ' + String.valueOf(interestRate.oldValue) 
                    + ' to ' + String.valueOf(interestRate.value) );
        }
        catch(MortgageCalculatorException ex) {
            response.addError(ex.getMessage());
        }
        catch(Exception ex) {
            response.addError('Something unexpected happened. Please contact support');
        }
        return JSON.serialize(response);
        
    }	

    /**
     * Custom exception
     */
    public class MortgageCalculatorException extends Exception {}

}