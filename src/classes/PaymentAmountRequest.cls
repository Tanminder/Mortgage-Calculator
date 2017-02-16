/**
 * Class for the payment amount request
 */
public class PaymentAmountRequest {
    public Decimal LoanAmount          {get; set;}
    public Decimal DownPayment          {get; set;}
    public String PaymentSchedule      {get; set;}
    public Decimal AmoritzationPeriod   {get; set;}

    private final Double DOWN_PAYMENT_PIVOT_AMT = 500000;
    private final Double DOWN_PAYMENT_PERCENT_LOW = 0.05;
    private final Double DOWN_PAYMENT_PERCENT_HIGH = 0.05;
	public final Integer MIN_AMORTIZATION_PERIOD = 5;
	public final Integer MAX_AMORTIZATION_PERIOD = 25;
	private final Double MAX_MORTGAGE_LOAN_ALLOWED = 1000000; //1 million
	private Map<String, Integer> paymentScheduleMap = new Map<String, Integer>{'monthly'=> 1,'biweekly'=> 2,'weekly'=>4};
    /**
     * Constructor
     * @param  urlRequest [Url request]
     */
    public PaymentAmountRequest(Map<String,String> urlRequest) {
        LoanAmount = Double.valueOf(urlRequest.get('askingPrice'));
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
        validateDownPayment();
        validateAmortizationPeriod();
    }

    /**
     * [getPaymentAmount Get the payment amount]
     * @return [description]
     */
    public Decimal getPaymentAmount() {
        //calculate insurance
        Double insurancePercent = calculateMortgageInsurance();
        LoanAmount += LoanAmount * insurancePercent;

        //calculate the payment amount per month
        Decimal paymentAmt = LoanAmount * calcMortgage();

        //divide by payment schedule if weekly or biweekly
        Double period = paymentScheduleMap.get( paymentSchedule.toLowerCase() );        
        paymentAmt = paymentAmt/period; 

        return paymentAmt.setScale(2);
    }

    private void validateRequiredField() {
        if(LoanAmount == null){
            throw new MortgageCalculatorException('Missing Asking Price');
        }
        if(DownPayment == null){
            throw new MortgageCalculatorException('Missing Down Payment');                
        }
        if(PaymentSchedule == null){
            throw new MortgageCalculatorException('Missing Payment Schedule');                
        }
        if(AmoritzationPeriod == null){
            throw new MortgageCalculatorException('Missing Amoritzation Period');                
        }
    }

    private void validateDownPayment() {
         Double minDownPayment;
        if(loanAmount <= DOWN_PAYMENT_PIVOT_AMT){
            minDownPayment = DOWN_PAYMENT_PIVOT_AMT * DOWN_PAYMENT_PERCENT_LOW;
        }else {
            minDownPayment = DOWN_PAYMENT_PIVOT_AMT * DOWN_PAYMENT_PERCENT_LOW;
            minDownPayment += (loanAmount - DOWN_PAYMENT_PIVOT_AMT)*DOWN_PAYMENT_PERCENT_HIGH;
        }
        if (downPayment < minDownPayment) {
        	throw new MortgageCalculatorException('Down payment must be at least 5% of first $500k plus 10% of any amount above $500k');
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
     * calculateMortgageInsurance   Calculate mortgage insurance
     * @return                      Mortgage insurance
     */
    private Double calculateMortgageInsurance(){

        //Insurance not available for mortgages over certain amount eg. 1 million
        if(loanAmount > MAX_MORTGAGE_LOAN_ALLOWED) return null;

        Double downPaymentPercent = downPayment/loanAmount * 100; 
        Double insurancePercent;
        if(downPaymentPercent >= 5 && downPaymentPercent <= 9.99){
            insurancePercent = 3.15;
        }else if(downPaymentPercent >= 10 && downPaymentPercent <= 14.99){
            insurancePercent = 2.4;
        }else if(downPaymentPercent >= 15 && downPaymentPercent <= 19.99){
            insurancePercent = 1.8;
        }
        return insurancePercent/100;
    }

	/**
	 * calcMortgage	 Mortgage calculation
	 */
    private Double calcMortgage(){
    	InterestRate interestRate = new InterestRate();
    	Double c = interestRate.getValue() / 1200;
    	Double n = AmoritzationPeriod * 12;
    	return (c* Math.pow( (1+c), n)) /(Math.pow((1+c),n)-1);
    }

    /**
     * Custom exception
     */
    public class MortgageCalculatorException extends Exception {}
        
}