package AI_project;

/**
 *
 * @author pride
 */
import jess.*;

public class AI_project{

    /**
     * @param args the command line arguments
     */
    static String str = "AI.clp";
   
    public static void main(String[] args) throws JessException {
        // TODO code application logic here
        Rete r = new Rete();
        r.batch(str);
     
        r.reset();
      //  r.assertString("Fred");
        r.run();
    }
    
}
