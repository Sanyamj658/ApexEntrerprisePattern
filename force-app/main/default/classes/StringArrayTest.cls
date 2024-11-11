public class StringArrayTest {
      public static list<String>generateStringArray(Integer i){
        List<String> sl = new List<String>();
          for(Integer j=0; j<i; j++){
               sl.add('Test'+j);
          }
          return sl;    
      }
}