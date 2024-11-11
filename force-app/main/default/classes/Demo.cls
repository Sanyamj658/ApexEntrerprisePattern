public class Demo {
    public String helloWorldString;
    public Integer a;
    private static final String DEFAULT_STRING;

    static {
        DEFAULT_STRING = 'This block will run once';
    }

    public Demo() {
        this(DEFAULT_STRING);
    }

    public Demo(String stringToDisplay) {
        this.helloWorldString = stringToDisplay;
    }

    public Demo(String stringToDisplay, Integer a) {
        this.helloWorldString = stringToDisplay;
        this.a = a;
    }

    public void printOutput() {
        if (a != null) {
            System.debug('value is: ' + helloWorldString + ', a is: ' + a);
        } else {
            System.debug('value is: ' + helloWorldString);
        }
    }
}