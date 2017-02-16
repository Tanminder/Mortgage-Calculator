@isTest
private class MortgageCalculatorWS_Test
{
	/**
	 * Test to check the payment amount is returned
	 */
	@isTest
	static void getPaymentAmount_Test()
	{
        // Set up a test request
        RestRequest request = new RestRequest();
        request.requestUri =
            'https://crystelray-developer-edition.na30.force.com/services/apexrest/mortgage-calculator/payment-amount?'
            + 'askingPrice=500000'
            + '&downPayment=25000'
            + '&amortizationPeriod=20'
            + '&paymentSchedule=weekly';
        request.httpMethod = 'GET';
        RestContext.request = request;
        // Call the method to test
        String paymentAmount = MortgageCalculatorWS.getAmount();
        // Verify results
        //System.assert(paymentAmount.success);
        //System.assertEquals('683.24', paymentAmount.result);
	}

	/**
	 * Test to check the max mortgage amount is returned
	 */
	@isTest
	static void getMortgageAmount_Test()
	{
        // Set up a test request
        RestRequest request = new RestRequest();
        request.requestUri =
            'https://crystelray-developer-edition.na30.force.com/services/apexrest/mortgage-calculator/mortgage-amount?'
            + 'askingPrice=500000'
            + '&downPayment=25000'
            + '&amortizationPeriod=20'
            + '&paymentAmount=600'
            + '&paymentSchedule=weekly';
        request.httpMethod = 'GET';
        RestContext.request = request;
        // Call the method to test
        String maxMortgage = MortgageCalculatorWS.getAmount();
        // Verify results
        //System.assert(maxMortgage.success);
        //System.assertEquals('138228.29', maxMortgage.result);

	}

	/**
	 * Test to check the interest rate is updated
	 */
	@isTest
	static void getAmount_Test()
	{
        // Set up a test request
        RestRequest request = new RestRequest();
        request.requestUri =
            'https://crystelray-developer-edition.na30.force.com/services/apexrest/mortgage-calculator/interest-rate?'
            + 'interestRate=5.0';
        request.httpMethod = 'PATCH';
        RestContext.request = request;
        // Call the method to test
        String interestRate = MortgageCalculatorWS.updateInterestRate();
        // Verify results
        //System.assert(interestRate.success);
        //System.assert(interestRate.result.contains('Interest rate has been updated from'));

	}
}