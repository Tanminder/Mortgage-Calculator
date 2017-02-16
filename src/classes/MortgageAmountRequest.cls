/**
 * Class for the payment amount request
 */
public class MortgageAmountRequest {
    public Decimal PaymentAmount       {get; set;}
    public Decimal DownPayment         {get; set;}
    public String PaymentSchedule      {get; set;}
    public Decimal AmoritzationPeriod  {get; set;}

    private final Double DOWN_PAYMENT_PIVOT_AMT = 500000;
    private final Double DOWN_PAYMENT_PERCENT_LOW = 0.05;
    private final Double DOWN_PAYMENT_PERCENT_HIGH = 0.05;
	public final Integer MIN_AMORTIZATION_PERIOD = 5;
	public final Integer MAX_AMORTIZATION_PERIOD = 25;
	private final Double MAX_MORTGAGE_LOAN_ALLOWED = 1000000; //1 million

    /**
     * Constructor
     * @param  urlRequest [Url request]
     */
    public MortgageAmountRequest(Map<String,String> urlRequest) {
        PaymentAmount = Double.valueOf(urlRequest.get('PaymentAmount'));
        DownPayment = Double.valueOf(urlRequest.get('DownPayment'));
        PaymentSchedule = urlRequest.get('PaymentSchedule').toLowerCase();
        AmoritzationPeriod = Double.valueOf(urlRequest.get('AmoritzationPeriod'));
    }

    /**
     * [validate Method for validation the received data]
     * @return  throws exception if data is invalid
     */
    public void validate() {
        validateRequiredField();
        validateAmortizationPeriod();
    }

	/**
	 * getMaxMortgageAmount	Calculate the max mortgage amount
	 * @return 						Max mortgage amount
	 */
	public Double getMaxMortgageAmount(){

		Decimal maxMortgageAmount = PaymentAmount/calcMortgage();

		//if down payment is given, add to max mortgage amount 
		if (downPayment!=null) maxMortgageAmount += downPayment;

		return maxMortgageAmount.setScale(2);
	}

    private void validateRequiredField() {
        if(PaymentAmount == null){
            throw new MortgageCalculatorException('Missing Payment Amount');                
        }
        if(PaymentSchedule == null){
            throw new MortgageCalculatorException('Payment Schedule');                
        }
        if(AmoritzationPeriod == null){
            throw new MortgageCalculatorException('Missing Amoritzation Period');                
        }
    }

    private void validateAmortizationPeriod(){
        if (!(AmoritzationPeriod > MIN_AMORTIZATION_PERIOD) && (AmoritzationPeriod < MAX_AMORTIZATION_PERIOD)){
        	throw new MortgageCalculatorException('Amortization Period not valid. Should be between ' + MIN_AMORTIZATION_PERIOD + 
    				' to ' + MAX_AMORTIZATION_PERIOD + ' years.');
        }
    }   

    private void validatePaymentSchedule(){
    	if(!(PaymentSchedule == 'monthly' || PaymentSchedule == 'weekly' || PaymentSchedule == 'biweekly')){
    		throw new MortgageCalculatorException('Payment Schedule can only be montly, weekly or biweekly');
    	}
    }


	/**
	 * calcMortgage	 Mortgage calculation
	 */
    private Double calcMortgage(){
    	InterestRateRequest interestRate = new InterestRateRequest();
    	Double c = interestRate.getValue() / 1200;
    	Double n = AmoritzationPeriod * 12;
    	return (c* Math.pow( (1+c), n)) /(Math.pow((1+c),n)-1);
    }

    /**
     * Custom exception
     */
    public class MortgageCalculatorException extends Exception {}
        
}