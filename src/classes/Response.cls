/**
 * Class to create the response
 */
public class Response {
    public Boolean success     {get; private set;}
    public String errorMessage {get; private set;}
    public String result      {get; private set;}

    /**
     * Constructor
     */
    public Response() {
        success = true;
    }

    /**
     * [addError Sets the error message]
     * @param errorMessage [The error message to display]
     */
    public void addError(String errorMessage) {
        success = false;
        this.errorMessage = errorMessage;
    }

    /**
     * [setResult Sets the result]
     * @param result [result that is returned back to the user]
     */
    public void setResult(String result) {
        success = true;
        this.result = result;
    }
}